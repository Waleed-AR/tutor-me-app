import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khososei/models/student_model.dart';
import 'package:khososei/models/teacher_model.dart';
import 'package:khososei/student_or_teacher.dart';
import 'package:khososei/controller/student_tabs_controller.dart';
import 'package:khososei/controller/teacher_tabs_controller.dart';
import 'package:path/path.dart';

class AuthController extends GetxController {
  String userUid = '';
  var verId = '';
  int? resendTokenId;
  bool phoneAuthCheck = false;
  dynamic credentials;
  var isProfileUploading = false;
  String phoneNumber = '';
  String numOfUsers = '';
  String numOfImages = '';
  String numOfIdentifications = '';

  phoneAuth(String phone) async {
    try {
      credentials = null;
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          log('Completed');
          // credentials = credential;
          // await FirebaseAuth.instance.signInWithCredential(credential);
          phoneNumber = phone;
        },
        forceResendingToken: resendTokenId,
        verificationFailed: (FirebaseAuthException e) {
          log('Failed');
          if (e.code == 'invalid-phone-number') {
            debugPrint('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          log('Code sent');
          verId = verificationId;
          resendTokenId = resendToken;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      log("Error occured $e");
    }
  }

  verifyOtp(String otpNumber, BuildContext context) async {
    log("Called");
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: otpNumber);

    log("LogedIn");

    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      decideRoute();
    }).catchError((e) {
      showOTPError(context);
    });
  }

  showOTPError(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
        height: 40,
        decoration: const BoxDecoration(color: Colors.red),
        alignment: Alignment.center,
        child: const Text(
          "الرقم المدخل غير صحيح",
          style: TextStyle(fontSize: 15, fontFamily: "Cairo"),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      backgroundColor: Colors.transparent,
    ));
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  decideRoute() {
    /// step 1 - check if user is logged in
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      /// step 2 - check whether user profile exists
      FirebaseDatabase.instance
          .ref()
          .child('teachers')
          .child(user.uid)
          .get()
          .then((value) {
        if (value.exists) {
          getTeacherInfo();
          Get.offAll(const TeacherTabsController());
        } else {
          FirebaseDatabase.instance
              .ref()
              .child('students')
              .child(user.uid)
              .get()
              .then((value) {
            if (value.exists) {
              getStudentInfo();
              Get.offAll(const StudentTabsController());
            } else {
              Get.offAll(StudentOrTeacher(),
                  transition: Transition.leftToRight);
            }
          });
        }
      });
    }
  }

  uploadImage(File image, String role) async {
    String imageUrl = '';
    String fileName = basename(image.path);
    var reference = FirebaseStorage.instance
        .ref()
        .child('$role/$fileName'); // Modify this path/string as you need
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then(
      (value) {
        imageUrl = value;
      },
    );
    return imageUrl;
  }

  storeStudentInfo(String phone, File? accountimage, String fname, String lname,
      String area, String gender, String age, String level, String role) async {
    String url;
    if (accountimage == null) {
      url = "";
    } else {
      url = await uploadImage(accountimage, role);
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseDatabase.instance.ref().child(role).child(uid).set({
      // FirebaseFirestore.instance.collection(role).doc(uid).set({
      'uid': uid,
      'phone': phone,
      'image': url,
      'first_name': fname,
      'last_name': lname,
      'area': area,
      'gender': gender,
      'age': age,
      'level': level,
    }).then((value) {
      isProfileUploading = false;

      Get.to(() => const StudentTabsController());
    });
  }

  storeTeacherInfo(
      String phone,
      File? accountimage,
      String fname,
      String lname,
      String area,
      String gender,
      String age,
      String level,
      String nationality,
      String course,
      String description,
      String role) async {
    String url;
    if (accountimage == null) {
      url = "";
    } else {
      url = await uploadImage(accountimage, role);
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseDatabase.instance.ref().child(role).child(uid).set({
      'uid': uid,
      'phone': phone,
      'image': url,
      'first_name': fname,
      'last_name': lname,
      'area': area,
      'gender': gender,
      'age': age,
      'level': level,
      'nationality': nationality,
      'course': course,
      'description': description,
    }).then((value) {
      isProfileUploading = false;

      Get.to(() => const TeacherTabsController());
    });
  }

  var myTeacher = TeacherModel();
  getTeacherInfo() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child('teachers')
        .child(FirebaseAuth.instance.currentUser!.uid);
    DatabaseEvent event = await ref.once();
    String? fname = event.snapshot.child('first_name').value.toString();
    String? lname = event.snapshot.child('last_name').value.toString();
    String? age = event.snapshot.child('age').value.toString();
    String? area = event.snapshot.child('area').value.toString();
    String? course = event.snapshot.child('course').value.toString();
    String? description = event.snapshot.child('description').value.toString();
    String? gender = event.snapshot.child('gender').value.toString();

    String? nationality = event.snapshot.child('nationality').value.toString();
    String? level = event.snapshot.child('level').value.toString();

    String? phone = event.snapshot.child('phone').value.toString();
    String? image = event.snapshot.child('image').value.toString();
    myTeacher = TeacherModel(
        first_name: fname,
        last_name: lname,
        age: age,
        area: area,
        course: course,
        description: description,
        gender: gender,
        nationality: nationality,
        level: level,
        phone: phone,
        image: image);
  }

  var myStudent = StudentModel();
  getStudentInfo() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child('students')
        .child(FirebaseAuth.instance.currentUser!.uid);
    DatabaseEvent event = await ref.once();
    String? fname = event.snapshot.child('first_name').value.toString();
    String? lname = event.snapshot.child('last_name').value.toString();
    String? age = event.snapshot.child('age').value.toString();
    String? area = event.snapshot.child('area').value.toString();
    String? gender = event.snapshot.child('gender').value.toString();
    String? level = event.snapshot.child('level').value.toString();
    String? phone = event.snapshot.child('phone').value.toString();
    String? image = event.snapshot.child('image').value.toString();
    myStudent = StudentModel(
        first_name: fname,
        last_name: lname,
        age: age,
        area: area,
        gender: gender,
        level: level,
        phone: phone,
        image: image);
  }
}

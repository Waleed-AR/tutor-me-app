import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:khososei/login_screen.dart';
import 'package:khososei/studentScreens/student_myprofile.dart';
import '../controller/auth_controller.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  AuthController authController = Get.find<AuthController>();
  @override
  DatabaseReference ref = FirebaseDatabase.instance
      .ref()
      .child('students')
      .child(FirebaseAuth.instance.currentUser!.uid);
  String? fname = '';
  String? lname = '';
  String? phone = '';
  String? image = '';
  Future _getDataFromDatabase() async {
    DatabaseEvent event = await ref.once();
    if (mounted) {
      setState(() {
        fname = event.snapshot.child('first_name').value.toString();
        lname = event.snapshot.child('last_name').value.toString();

        phone = event.snapshot.child('phone').value.toString();
        image = event.snapshot.child('image').value.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
    authController.getStudentInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 40,
        ),
        // button to take image for the profile
        Stack(alignment: Alignment.topRight, children: [
          image.toString() == ""
              ? Container(
                  width: 120,
                  height: 128,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.lightGreen[400],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 70,
                    ),
                  ),
                )
              : Container(
                  width: 120,
                  height: 128,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(image.toString()),
                        fit: BoxFit.cover),
                    shape: BoxShape.circle,
                  ),
                ),
        ]),
        const SizedBox(
          height: 10,
        ),
        fname.toString() == '' && lname.toString() == ''
            ? const Text("الأسم")
            : Text(
                fname.toString() + ' ' + lname.toString(),
                style: const TextStyle(
                    fontFamily: "Cairo",
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
        const SizedBox(
          height: 50,
        ),

        // profile info tab
        Container(
          height: 80,
          width: 300,
          child: Card(
            elevation: 2,
            child: ElevatedButton(
              onPressed: () {
                // will take to the your profile info page
                Get.to(() => StudentProfile());
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  side: const BorderSide(color: Colors.black, width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.arrow_back,
                  ),
                  Expanded(child: Container()),
                  const SizedBox(
                    width: 89,
                  ),
                  const Text(
                    "الإعدادات ",
                    style: TextStyle(fontFamily: "Cairo", fontSize: 18),
                  ),
                  const Icon(
                    Icons.settings,
                    color: Colors.grey,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        // log-out tab
        Container(
          height: 80,
          width: 300,
          child: Card(
            elevation: 2,
            child: ElevatedButton(
              onPressed: () {
                // popup massage (are you sure massage)
                showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: Container(
                        width: 300,
                        height: 150,
                        color: Colors.grey[100],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "هل تريد تسجيل الخروج؟",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontFamily: "Cairo"),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    authController.signOut();
                                    // will take to the login page
                                    Get.offAll(LoginPage(),
                                        transition: Transition.upToDown);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      primary: Colors.white,
                                      onPrimary: Colors.black,
                                      side: const BorderSide(
                                          color: Colors.red, width: 2)),
                                  child: const Text("نعم",
                                      style: TextStyle(fontFamily: "Cairo")),
                                ),
                                const SizedBox(
                                  width: 75,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // go back and remove the popup massage
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      primary: Colors.white,
                                      onPrimary: Colors.black,
                                      side: const BorderSide(
                                          color: Colors.green, width: 2)),
                                  child: const Text(
                                    "لا",
                                    style: TextStyle(fontFamily: "Cairo"),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  side: const BorderSide(color: Colors.black, width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.arrow_back,
                  ),
                  Expanded(child: Container()),
                  const SizedBox(
                    width: 89,
                  ),
                  const Text(
                    "تسجيل الخروج ",
                    style: TextStyle(fontFamily: "Cairo", fontSize: 18),
                  ),
                  const Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}

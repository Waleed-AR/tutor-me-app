import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/auth_controller.dart';

class StudentProfileSettingScreen extends StatefulWidget {
  StudentProfileSettingScreen();

  @override
  State<StudentProfileSettingScreen> createState() =>
      _StudentProfileSettingScreenState();
}

class _StudentProfileSettingScreenState
    extends State<StudentProfileSettingScreen> {
  TextEditingController first_nameController = TextEditingController();
  TextEditingController last_nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthController authController = Get.find<AuthController>();

  String? selectedArea = "";
  File? accountimage = null;

  Future pickaccountImage(ImageSource source) async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: source);
      if (image != null) {
        accountimage = File(image.path);
        setState(() {});
      }
    } on PlatformException catch (e) {
      print('"$e"خطأ ارجعوا التحقق من الإعدادات');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ))
          ],
          // actionsIconTheme: ,
          automaticallyImplyLeading: false,
          elevation: 10,
          title: const Text(
            "تسجيل جديد",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: "Cairo"),
          ),

          backgroundColor: Colors.lightGreen[400],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () {
                          pickaccountImage(ImageSource.gallery);
                        },
                        child: accountimage == null
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
                                      image: FileImage(accountimage!),
                                      fit: BoxFit.cover),
                                  shape: BoxShape.circle,
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 23),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFieldWidget('الاسم الأول', first_nameController),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldWidget('الاسم الأخير', last_nameController),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldWidgetAge('العمر', ageController),
                      const SizedBox(
                        height: 10,
                      ),
                      DropDownWidgetGender(
                        "الجنس",
                        genderController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropDownWidgetArea(
                        "المنطقة",
                        areaController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropDownWidgetLevel("المرحلة", levelController),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                width: double.infinity,
                height: 55,
                child: authController.isProfileUploading
                    ? Center(
                        child: CircularProgressIndicator(
                            color: Colors.lightGreen[400]),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          if (first_nameController.text.isEmpty ||
                              last_nameController.text.isEmpty ||
                              ageController.text.isEmpty ||
                              genderController.text == '-1' ||
                              levelController.text == '-1' ||
                              areaController.text == '-1') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Container(
                                height: 40,
                                decoration:
                                    const BoxDecoration(color: Colors.red),
                                alignment: Alignment.center,
                                child: const Text(
                                  "! الرجاء إدخال جميع المعلومات",
                                  style: TextStyle(
                                      fontSize: 15, fontFamily: "Cairo"),
                                ),
                              ),
                              behavior: SnackBarBehavior.floating,
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                            ));
                          } else {
                            setState(() {
                              authController.isProfileUploading = true;
                            });
                            authController.storeStudentInfo(
                                FirebaseAuth.instance.currentUser!.phoneNumber
                                    .toString(),
                                accountimage,
                                first_nameController.text,
                                last_nameController.text,
                                areaController.text,
                                genderController.text,
                                ageController.text,
                                levelController.text,
                                "students");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: Colors.lightGreen[400],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        child: const Text(
                          "تسجيل",
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: "Cairo",
                              color: Colors.white),
                        )),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ));
  }

  TextFieldWidget(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          title,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Cairo'),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
            width: 2000,
            height: 45,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 1,
                  )
                ],
                borderRadius: BorderRadius.circular(5)),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                controller: controller,
                onTap: () {
                  if (controller != null) {
                    if (controller.selection ==
                        TextSelection.fromPosition(
                            TextPosition(offset: controller.text.length - 1))) {
                      controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length));
                    }
                  }
                },
                //textAlign: TextAlign.start,
                textDirection: TextDirection.rtl,
                textAlignVertical: TextAlignVertical.top,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 16,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 5, right: 5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.0))),
              ),
            )),
      ],
    );
  }

  TextFieldWidgetAge(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          title,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Cairo'),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
            width: 2000,
            height: 45,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 1,
                  )
                ],
                borderRadius: BorderRadius.circular(5)),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: controller,
                onTap: () {
                  if (controller != null) {
                    if (controller.selection ==
                        TextSelection.fromPosition(
                            TextPosition(offset: controller.text.length - 1))) {
                      controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length));
                    }
                  }
                },
                //textAlign: TextAlign.start,
                textDirection: TextDirection.rtl,
                textAlignVertical: TextAlignVertical.top,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 16,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 5, right: 5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.0))),
              ),
            )),
      ],
    );
  }

  DropDownWidgetArea(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          title,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Cairo'),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
            width: 2000,
            height: 45,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 1,
                  )
                ],
                borderRadius: BorderRadius.circular(5)),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: DropdownButtonFormField(
                value: "-1",
                items: const [
                  DropdownMenuItem(
                    value: "-1",
                    child: Text(""),
                  ),
                  DropdownMenuItem(
                    value: "الجدود الشمالية",
                    alignment: Alignment.topRight,
                    child: Text(
                      "الجدود الشمالية",
                      style: TextStyle(fontFamily: "Cairo"),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "الجوف",
                    alignment: Alignment.topRight,
                    child: Text("الجوف", style: TextStyle(fontFamily: "Cairo")),
                  ),
                  DropdownMenuItem(
                    value: "تبوك",
                    alignment: Alignment.topRight,
                    child: Text("تبوك", style: TextStyle(fontFamily: "Cairo")),
                  ),
                  DropdownMenuItem(
                    value: "حائل",
                    alignment: Alignment.topRight,
                    child: Text("حائل", style: TextStyle(fontFamily: "Cairo")),
                  ),
                  DropdownMenuItem(
                    value: "القصيم",
                    alignment: Alignment.topRight,
                    child:
                        Text("القصيم", style: TextStyle(fontFamily: "Cairo")),
                  ),
                  DropdownMenuItem(
                    value: "المدينة المنورة",
                    alignment: Alignment.topRight,
                    child: Text("المدينة المنورة",
                        style: TextStyle(fontFamily: "Cairo")),
                  ),
                  DropdownMenuItem(
                    value: "الشرقية",
                    alignment: Alignment.topRight,
                    child:
                        Text("الشرقية", style: TextStyle(fontFamily: "Cairo")),
                  ),
                  DropdownMenuItem(
                    value: "الرياض",
                    alignment: Alignment.topRight,
                    child:
                        Text("الرياض", style: TextStyle(fontFamily: "Cairo")),
                  ),
                  DropdownMenuItem(
                    value: "مكة المكرمة",
                    alignment: Alignment.topRight,
                    child: Text("مكة المكرمة",
                        style: TextStyle(fontFamily: "Cairo")),
                  ),
                  DropdownMenuItem(
                    value: "الباحة",
                    alignment: Alignment.topRight,
                    child:
                        Text("الباحة", style: TextStyle(fontFamily: "Cairo")),
                  ),
                  DropdownMenuItem(
                    value: "نجران",
                    alignment: Alignment.topRight,
                    child: Text("نجران", style: TextStyle(fontFamily: "Cairo")),
                  ),
                  DropdownMenuItem(
                    value: "عسير",
                    alignment: Alignment.topRight,
                    child: Text("عسير", style: TextStyle(fontFamily: "Cairo")),
                  ),
                  DropdownMenuItem(
                    alignment: Alignment.topRight,
                    value: "جازان",
                    child: Text("جازان", style: TextStyle(fontFamily: "Cairo")),
                  ),
                ],
                onChanged: (String? newValue) {
                  areaController.text = newValue!;
                  setState(() {
                    // selectedValue = newValue!;
                  });
                },
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Cairo",
                    color: Colors.black),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 10, right: 5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.0))),
              ),
            )),
      ],
    );
  }

  DropDownWidgetLevel(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          title,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Cairo'),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
            width: 2000,
            height: 45,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 1,
                  )
                ],
                borderRadius: BorderRadius.circular(5)),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: DropdownButtonFormField(
                value: "-1",
                items: const [
                  DropdownMenuItem(
                    value: "-1",
                    child: Text(""),
                  ),
                  DropdownMenuItem(
                    value: "ثانوي",
                    alignment: Alignment.topRight,
                    child: Text(
                      "ثانوي",
                      style: TextStyle(fontFamily: "Cairo"),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "متوسط",
                    alignment: Alignment.topRight,
                    child: Text("متوسط", style: TextStyle(fontFamily: "Cairo")),
                  ),
                  DropdownMenuItem(
                    value: "إبتدائي",
                    alignment: Alignment.topRight,
                    child:
                        Text("إبتدائي", style: TextStyle(fontFamily: "Cairo")),
                  ),
                ],
                onChanged: (String? newValue) {
                  levelController.text = newValue!;
                  setState(() {
                    // selectedValue = newValue!;
                  });
                },
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Cairo",
                    color: Colors.black),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 10, right: 5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.0))),
              ),
            )),
      ],
    );
  }

  DropDownWidgetGender(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          title,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Cairo'),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
            width: 2000,
            height: 45,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 1,
                  )
                ],
                borderRadius: BorderRadius.circular(5)),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: DropdownButtonFormField(
                value: "-1",
                items: const [
                  DropdownMenuItem(
                    value: "-1",
                    child: Text(""),
                  ),
                  DropdownMenuItem(
                    value: "ذكر",
                    alignment: Alignment.topRight,
                    child: Text(
                      "ذكر",
                      style: TextStyle(fontFamily: "Cairo"),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "انثى",
                    alignment: Alignment.topRight,
                    child: Text("أنثى", style: TextStyle(fontFamily: "Cairo")),
                  ),
                ],
                onChanged: (String? newValue) {
                  genderController.text = newValue!;
                  setState(() {
                    // selectedValue = newValue!;
                  });
                },
                style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Cairo",
                    color: Colors.black),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 10, right: 5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.0))),
              ),
            )),
      ],
    );
  }
}

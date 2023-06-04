import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:khososei/studentScreens/student_profile_settings.dart';
import 'package:khososei/teacherScreens/teacher_profile_settings.dart';

class StudentOrTeacher extends StatefulWidget {
  StudentOrTeacher();

  @override
  State<StudentOrTeacher> createState() => _StudentOrTeacherState();
}

class _StudentOrTeacherState extends State<StudentOrTeacher> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: const EdgeInsets.only(left: 25, right: 25),
            alignment: Alignment.center,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    "ما هي مهنتك؟",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Cairo"),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 100,
                    width: 300,
                    child: Card(
                      color: Colors.lightGreen[400],
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Get.to(TeacherProfileSettingScreen(),
                              transition: Transition.leftToRight);
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "معلم",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: "Cairo"),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.school,
                                size: 32,
                                color: Colors.white,
                              ),
                            ]),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 100,
                    width: 300,
                    child: Card(
                      color: Colors.lightGreen[400],
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Get.to(StudentProfileSettingScreen(),
                              transition: Transition.leftToRight);
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "طالب",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: "Cairo"),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.person,
                                size: 32,
                                color: Colors.white,
                              ),
                            ]),
                      ),
                    ),
                  ),
                ]))));
  }
}

import 'package:flutter/material.dart';

import 'package:khososei/teacherScreens/teacher_profile_page.dart';
import 'package:khososei/teacherScreens/students_list.dart';

class TeacherTabsController extends StatelessWidget {
  const TeacherTabsController({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,

          // actionsIconTheme: ,
          automaticallyImplyLeading: false,
          //elevation: 10,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
          backgroundColor: Colors.lightGreen[400],
        ),
        body: Column(children: const [
          Expanded(
            child: TabBarView(children: [
              //1st tab
              StudentListScreen(),
              //2nd tab
              TeacherProfilePage()
            ]),
          )
        ]),
        bottomNavigationBar: Material(
          color: Colors.lightGreen[400],
          child: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.view_list),
              child: Text(
                "قائمة الطلاب",
                style: TextStyle(fontFamily: "Cairo"),
              ),
            ),
            Tab(
              icon: Icon(Icons.person),
              child: Text(
                "الملف الشخصي",
                style: TextStyle(fontFamily: "Cairo"),
              ),
            ),
          ], indicatorColor: Colors.white),
        ),
      ),
    );
  }
}

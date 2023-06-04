import 'package:flutter/material.dart';
import 'package:khososei/studentScreens/student_profile_page.dart';
import 'package:khososei/studentScreens/teachers_list.dart';

class StudentTabsController extends StatelessWidget {
  const StudentTabsController({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  Icons.people_alt,
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
              TeacherListScreen(),
              //2nd tab
              StudentProfilePage()
            ]),
          )
        ]),
        bottomNavigationBar: Material(
          color: Colors.lightGreen[400],
          child: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.view_list),
              child: Text(
                "قائمة المعلمين",
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

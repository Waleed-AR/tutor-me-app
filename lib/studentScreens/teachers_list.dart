import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({Key? key}) : super(key: key);

  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('teachers');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FirebaseAnimatedList(
          query: ref,
          itemBuilder: (context, snapshot, animation, index) {
            return SizedBox(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ExpansionTile(
                    controlAffinity: ListTileControlAffinity.trailing,
                    childrenPadding: const EdgeInsets.all(16).copyWith(top: 0),
                    expandedAlignment: Alignment.centerRight,
                    expandedCrossAxisAlignment: CrossAxisAlignment.end,
                    leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, border: Border.all()),
                        child: snapshot.child('image').value.toString() == ""
                            ? const Icon(Icons.person_outline)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(snapshot
                                        .child('image')
                                        .value
                                        .toString())),
                              )),
                    title: Text(
                      snapshot.child('first_name').value.toString() +
                          " " +
                          snapshot.child('last_name').value.toString(),
                      style: const TextStyle(fontFamily: "Cairo"),
                    ),
                    subtitle: Text(snapshot.child('level').value.toString(),
                        style: const TextStyle(fontFamily: "Cairo")),
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              const Icon(
                                size: 20,
                                Icons.menu_book_rounded,
                                color: Colors.blueGrey,
                              ),
                              Text(
                                  " " +
                                      snapshot.child('course').value.toString(),
                                  style: const TextStyle(
                                      fontFamily: "Cairo",
                                      fontWeight: FontWeight.bold)),
                            ]),
                            Row(children: [
                              const Icon(
                                size: 20,
                                Icons.credit_card,
                                color: Colors.blueGrey,
                              ),
                              Text(
                                  " " +
                                      snapshot
                                          .child('nationality')
                                          .value
                                          .toString(),
                                  style: const TextStyle(
                                      fontFamily: "Cairo",
                                      fontWeight: FontWeight.bold)),
                            ]),
                            Row(children: [
                              const Icon(
                                size: 20,
                                Icons.location_pin,
                                color: Colors.red,
                              ),
                              Text(
                                  " " + snapshot.child('area').value.toString(),
                                  style: const TextStyle(
                                      fontFamily: "Cairo",
                                      fontWeight: FontWeight.bold)),
                            ]),
                            Row(children: [
                              const Icon(
                                size: 20,
                                Icons.phone,
                                color: Colors.green,
                              ),
                              Text(
                                  " " +
                                      snapshot.child('phone').value.toString(),
                                  style: const TextStyle(
                                      fontFamily: "Cairo",
                                      fontWeight: FontWeight.bold)),
                            ]),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(snapshot.child('description').value.toString(),
                                style: const TextStyle(fontFamily: "Cairo")),
                          ])
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

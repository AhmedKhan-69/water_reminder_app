
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:water_reminder/pages/homepage.dart';
import 'package:water_reminder/pages/weight_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

bool? flag;

class _SplashScreenState extends State<SplashScreen> {
  String gender = '';
  DateTime bedTime = DateTime.now();
  Timestamp stamp1 = Timestamp.now();
  Timestamp stamp2 = Timestamp.now();
  DateTime wakeTime = DateTime.now();

  @override
  void initState() {
    getData(null, gender);
    checkstate();
    super.initState();

    Future.delayed(const Duration(seconds: 3), (() {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => (flag == true)
              ? Homepage(
                  bedtime: bedTime,
                  gender: gender,
                  waketime: wakeTime,
                )
              : const WeightPage(
                  title: 'title',
                ),
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 247, 249),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            "Water Reminder App",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      )),
    );
  }

  checkstate() async {
    await FirebaseFirestore.instance
        .collection('Default-User')
        .doc('user1')
        .get()
        .then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          flag = true;
        } else {
          flag = false;
        }
      },
    );
  }
}

CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('Default-User');
int? getData(
    [int? intake,
    String? gender,
    DateTime? bedTime,
    Timestamp? stamp1,
    Timestamp? stamp2,
    DateTime? wakeTime,
    Function? callbackfunction]) {
  collectionReference.doc('user1').get().then((value) {
    intake = (intake != null) ? (value)['waterIntake'] : null;
    gender = (gender != null) ? (value)['gender'] : null;

    stamp1 = (stamp1 != null) ? (value)['bedTime'] : null;

    bedTime = (bedTime != null) ? stamp1!.toDate() : null;

    stamp2 = (stamp2 != null) ? (value)['bedTime'] : null;

    wakeTime = (wakeTime != null) ? stamp2!.toDate() : null;

    (intake == null) ? callbackfunction!(gender) : callbackfunction!(intake);
  });
  return intake;
}

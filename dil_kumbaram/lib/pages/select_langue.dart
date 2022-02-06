import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dil_kumbaram/contants/contants.dart';
import 'package:dil_kumbaram/pages/student.dart';
import 'package:dil_kumbaram/pages/teacher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

class SelectLangue extends StatefulWidget {
  const SelectLangue({Key? key}) : super(key: key);

  @override
  _SelectLangueState createState() => _SelectLangueState();
}

class _SelectLangueState extends State<SelectLangue> {
  final ButtonStyle loginbutton = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 20),
    primary: HexColor("#6B48FF"),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
  );
  @override
  void initState() {
    super.initState();
    state();
  }

  void state() async {
    _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> userData) {
      if (userData.data()!['Dil'] != "") {
        if (userData.data()!['Rol'] == "Student" ||
            userData.data()!['Rol'] == "Student+") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const StudentPage(),
            ),
            (route) => false,
          );
        } else if (userData.data()!['Rol'] == "Teacher") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => TeacherPage(
                langue: userData.data()!['Dil'],
              ),
            ),
            (route) => false,
          );
        }
      }
    });
  }

  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 2),
    () => 'Data Loaded',
  );
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _calculation,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SelectingLangue(loginbutton: loginbutton);
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text("Hata"),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}

class SelectingLangue extends StatelessWidget {
  const SelectingLangue({
    Key? key,
    required this.loginbutton,
  }) : super(key: key);

  final ButtonStyle loginbutton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: HexColor("#5D5FEF"),
          ),
          onPressed: () => {
            Navigator.pop(context),
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  height: 100.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/newlogo.png',
                    width: 293.w,
                    height: 212.h,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      AutoSizeText(
                        "Hangi Dilde Başlamak İstersin?",
                        style: Constants.getTitleStyle(),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      AutoSizeText(
                        "Bu tercihini daha sonra profil kısmından dilediğin zaman değiştirebilirsin.",
                        style: Constants.getSubTitleStyle(),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      AutoSizeText(
                        "Tüm dillere erişebilirsin.",
                        style: Constants.getSubTitleStyle(),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      Ingilizce(loginbutton: loginbutton),
                      SizedBox(
                        height: 20.h,
                      ),
                      Almanca(loginbutton: loginbutton)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Ingilizce extends StatelessWidget {
  const Ingilizce({
    Key? key,
    required this.loginbutton,
  }) : super(key: key);

  final ButtonStyle loginbutton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 250.w,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              _firebaseFirestore
                  .collection('users')
                  .doc(_auth.currentUser!.uid)
                  .update({'Dil': 'İngilizce'});
            },
            child: const Text("İngilizce"),
            style: loginbutton,
          ),
        ),
        const Positioned(
          left: -15,
          child: Image(
            image: AssetImage('assets/images/english.png'),
          ),
        ),
      ],
    );
  }
}

class Almanca extends StatelessWidget {
  const Almanca({
    Key? key,
    required this.loginbutton,
  }) : super(key: key);

  final ButtonStyle loginbutton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 250.w,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              _firebaseFirestore
                  .collection('users')
                  .doc(_auth.currentUser!.uid)
                  .update({'Dil': 'Almanca'});
            },
            child: const Text("Almanca"),
            style: loginbutton,
          ),
        ),
        const Positioned(
          left: -15,
          child: Image(
            image: AssetImage('assets/images/almanca.png'),
          ),
        ),
      ],
    );
  }
}

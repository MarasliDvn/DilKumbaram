import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'package:searchfield/searchfield.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
CollectionReference users = FirebaseFirestore.instance.collection('users');
CollectionReference lesson = FirebaseFirestore.instance.collection('lesson');

class LessonAdd extends StatefulWidget {
  final String date;
  final String langue;
  const LessonAdd({Key? key, required this.date, required this.langue})
      : super(key: key);

  @override
  _LessonAddState createState() => _LessonAddState();
}

class _LessonAddState extends State<LessonAdd> {
  TextEditingController timeinput = TextEditingController();
  TextEditingController lessontime = TextEditingController();
  TextEditingController lessonlink = TextEditingController();
  TextEditingController studentNote = TextEditingController();
  TextEditingController student = TextEditingController();
  String ad = '';

  List<String> secili = [];
  @override
  void initState() {
    timeinput.text = "";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timeinput.dispose();
    lessontime.dispose();
    lessonlink.dispose();
    studentNote.dispose();
    student.dispose();
    secili.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.date,
          style: TextStyle(fontSize: 24.sp, color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: HexColor("#6B48FF"),
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                students(),
                SizedBox(
                  height: 10.h,
                ),
                TextField(
                  controller: timeinput, //editing controller of this TextField
                  decoration: InputDecoration(
                      fillColor: HexColor("#F9F9F9"),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#91919F")),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(11.0))),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(color: HexColor("#91919F")),
                      ),
                      labelStyle: TextStyle(color: HexColor("#91919F")),
                      //icon: Icon(Icons.timer), //icon of text field
                      labelText: "Saat" //label text of field
                      ),
                  keyboardType: TextInputType
                      .text, //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay time = TimeOfDay.now();
                    FocusScope.of(context).requestFocus(FocusNode());

                    TimeOfDay? picked = await showTimePicker(
                        context: context, initialTime: time);
                    if (picked != null && picked != time) {
                      timeinput.text =
                          picked.toString().substring(10, 15); // add this line.
                      setState(() {
                        time = picked;
                      });
                    }
                  },
                  onSubmitted: (deger) async {
                    timeinput.text = deger;
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextField(
                  onSubmitted: (deger) {
                    lessontime.text = deger;
                  },
                  controller: lessontime,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      fillColor: HexColor("#F9F9F9"),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#91919F")),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(11.0))),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(color: HexColor("#91919F")),
                      ),
                      labelStyle: TextStyle(color: HexColor("#91919F")),
                      //icon: Icon(Icons.timer), //icon of text field
                      labelText: "Ders Süresi (Dakika)" //label text of field
                      ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextField(
                  controller: lessonlink,
                  onSubmitted: (deger) {
                    lessonlink.text = deger;
                  },
                  decoration: InputDecoration(
                      fillColor: HexColor("#F9F9F9"),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#91919F")),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(11.0))),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(color: HexColor("#91919F")),
                      ),
                      labelStyle: TextStyle(color: HexColor("#91919F")),
                      //icon: Icon(Icons.timer), //icon of text field
                      labelText: "Ders Linki" //label text of field
                      ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextField(
                  controller: studentNote,
                  onSubmitted: (deger) {
                    studentNote.text = deger;
                  },
                  decoration: InputDecoration(
                    fillColor: HexColor("#F9F9F9"),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#91919F")),
                        borderRadius: const BorderRadius.all(Radius.circular(11.0))),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(color: HexColor("#91919F")),
                    ),
                    labelStyle: TextStyle(color: HexColor("#91919F")),
                    //icon: Icon(Icons.timer), //icon of text field
                    labelText: "Öğrenciye Not Ekle (Tercihen)",
                    //label text of field
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    onPressed: () async {
                      if (student.text.isNotEmpty &&
                          timeinput.text.isNotEmpty &&
                          lessontime.text.isNotEmpty &&
                          lessonlink.text.isNotEmpty) {
                        //dakika();
                        FirebaseFirestore.instance
                            .collection('users')
                            .where('Adı', isEqualTo: student.text)
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            dakika(doc["Eposta"].toString());
                          });
                        });
                      } else {
                        final snackBar = SnackBar(
                          content: const Text(
                            'Alanlar boş kalamaz.',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: (Colors.red),
                          action: SnackBarAction(
                            textColor: Colors.white,
                            label: 'Tamam',
                            onPressed: () {},
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }

                      //dersekle();
                    },
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: const Center(child: Text('Ders Ekle'))))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> dakika(String eposta) async {
    String lessonurl =
        "https://dilkumbaram.com/admin/api/dakika.php?eposta=" + eposta + "";
    var result = await Dio().get(lessonurl);

    var dakika = result.data.toString();
    if (dakika.isNotEmpty) {
      if (int.parse(dakika) == 0) {
        final snackBar = SnackBar(
          content: const Text(
            'Öğrencinin dakika hakkı 0 kalmıştır.',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (Colors.yellow),
          action: SnackBarAction(
            textColor: Colors.black,
            label: 'Tamam',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        dersekle(eposta);
      }
    } else {
      final snackBar = SnackBar(
        content: const Text(
          'Öğrencinin dakika hakkı yoktur.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: (Colors.red),
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'Tamam',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> dersekle(String eposta) async {
    DocumentReference docRef = lesson.doc();
    DateTime tempDate =  DateFormat("dd.MM.yyyy").parse(widget.date.substring(0,widget.date.length-4));
    Map<String, dynamic> addLesson = {};
    addLesson['Ders'] = widget.langue;
    addLesson['Öğretmen'] = _auth.currentUser!.displayName;
    addLesson['Öğrenci'] = student.text;
    addLesson['Saat'] = timeinput.text;
    addLesson['Dakika'] = lessontime.text;
    addLesson['Link'] = lessonlink.text;
    addLesson['Not'] = studentNote.text;
    addLesson['Tarih'] = tempDate;
    addLesson['Id'] = docRef.id;

    String lessonurl = "https://dilkumbaram.com/admin/api/dersler.php?id=" +
        docRef.id +
        "&ders=" +
        widget.langue +
        "&ogretmen=" +
        _auth.currentUser!.displayName.toString() +
        "&ogrenci=" +
        student.text +
        "&saat=" +
        timeinput.text +
        "&dakika=" +
        lessontime.text +
        "&tarih=" +
        widget.date +
        "&eposta=" +
        eposta +
        "";
    var result = await Dio().get(lessonurl);
    if (result.toString() == '0') {
      final snackBar = SnackBar(
        content: const Text(
          'Öğrencinin Dakikası Yetmiyor.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: (Colors.red),
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'Tamam',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (result.toString() == '1') {
      await docRef.set(addLesson, SetOptions(merge: true)).then((v) async {
        final snackBar = SnackBar(
          content: const Text(
            'Ders Eklendi',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: (Colors.green),
          action: SnackBarAction(
            textColor: Colors.white,
            label: 'Tamam',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  StreamBuilder<QuerySnapshot<Object?>> students() {
    return StreamBuilder<QuerySnapshot>(
        stream: users.where("Rol", isEqualTo: 'Student').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('Yükleniyor');
          } else {
            secili.clear();
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              DocumentSnapshot snap = snapshot.data!.docs[i];
              secili.add(snap['Adı'] != "" ? snap['Adı'] : snap['Eposta']);
            }
            return SearchField(
              searchInputDecoration: InputDecoration(
                fillColor: HexColor("#F9F9F9"),
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor("#91919F")),
                    borderRadius: const BorderRadius.all(Radius.circular(11.0))),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: BorderSide(color: HexColor("#91919F")),
                ),
                labelStyle: TextStyle(color: HexColor("#91919F")),
              ),
              controller: student,
              suggestionState: SuggestionState.hidden,
              maxSuggestionsInViewPort: 6,
              hint: 'Öğrenci Seçiniz.',
              suggestions: secili,
            );
          }
        });
  }
}

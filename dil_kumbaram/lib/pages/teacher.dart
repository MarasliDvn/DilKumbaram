import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dil_kumbaram/pages/first_screen_first_page.dart';
import 'package:dil_kumbaram/pages/teacher_lessonadd.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;

FirebaseAuth _auth = FirebaseAuth.instance;
CollectionReference lesson = FirebaseFirestore.instance.collection('lesson');
late String datenow;
List<String> dates = [];

class TeacherPage extends StatefulWidget {
  final langue;
  const TeacherPage({Key? key, required this.langue}) : super(key: key);

  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  final ButtonStyle logoutbutton = ElevatedButton.styleFrom(
    textStyle: TextStyle(fontSize: 12.sp),
    primary: Colors.red,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
  );
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('tr');
  }

  void datelist() {
    dates.clear();
    for (int i = 0; i <= 30; i++) {
      datenow =
          DateFormat("dd.MM.yyyy E","tr").format(DateTime.now().add(Duration(days: i)));
      dates.add(datenow);
    }
  }

  Future<void> _signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
  }

  Future<String> getDakika(String data) async {
    String dakika = 'ssss';
    var a = await FirebaseFirestore.instance
        .collection('users')
        .where('Adı', isEqualTo: data)
        .get();

    String lessonurl = "https://dilkumbaram.com/admin/api/dakika.php?eposta=" +
        a.docs[0]['Eposta'] +
        "";
    var result = await Dio().get(lessonurl);
    dakika = result.data.toString();
    return dakika;
  }

  @override
  Widget build(BuildContext context) {
    datelist();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ders Randevuları",
          style: TextStyle(fontSize: 24.sp, color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: HexColor("#6B48FF"),
        elevation: 0,
      ),
      body: Container(
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
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _signOut();
                        await
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => const FirstPage(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text("Çıkış Yap"),
                      style: logoutbutton,
                    )),
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: dates.length,
                      itemBuilder: (context, index) {
                        DateTime tempDate =  DateFormat("dd.MM.yyyy").parse(dates[index]);
                        Timestamp myTimeStamp = Timestamp.fromDate(tempDate);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: ExpansionTile(
                              tilePadding:
                                  const EdgeInsets.only(left: 25, right: 25),
                              childrenPadding: const EdgeInsets.only(
                                  left: 25, right: 25, bottom: 5),
                              backgroundColor: HexColor('#6B48FF'),
                              textColor: Colors.white,
                              collapsedBackgroundColor: HexColor('#6B48FF'),
                              collapsedTextColor: Colors.white,
                              collapsedIconColor: Colors.white,
                              iconColor: Colors.white,
                              title: Text(dates[index]),
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                    stream: lesson
                                        .where("Tarih", isEqualTo: myTimeStamp)
                                        .where("Öğretmen",
                                            isEqualTo:
                                                _auth.currentUser!.displayName)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Text('Yükleniyor');
                                      } else {
                                        return ListView(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          children: snapshot.data!.docs
                                              .map((DocumentSnapshot document) {
                                            dynamic? dakika;
                                            Map<String, dynamic> data = document
                                                .data()! as Map<String, dynamic>;

                                            return Card(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 15),
                                                padding: const EdgeInsets.all(10),
                                                child: Column(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: IconButton(
                                                        icon: const FaIcon(
                                                            FontAwesomeIcons
                                                                .timesCircle),
                                                        color: Colors.red,
                                                        onPressed: () async {
                                                          await sorgu(
                                                              context, data);
                                                        },
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                width: 100.w,
                                                                child:
                                                                    AutoSizeText(
                                                                  "Öğrenci ",
                                                                  maxLines: 3,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16.sp),
                                                                ),
                                                              ),
                                                              AutoSizeText(
                                                                " : " +
                                                                    data[
                                                                        'Öğrenci'],
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    color: HexColor(
                                                                        '#6B48FF'),
                                                                    fontSize:
                                                                        16.sp),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                width: 100.w,
                                                                child:
                                                                    AutoSizeText(
                                                                  "Saat ",
                                                                  maxLines: 3,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16.sp),
                                                                ),
                                                              ),
                                                              AutoSizeText(
                                                                " : " +
                                                                    data['Saat'],
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    color: HexColor(
                                                                        '#6B48FF'),
                                                                    fontSize:
                                                                        16.sp),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                width: 100.w,
                                                                child:
                                                                    AutoSizeText(
                                                                  "Dakika ",
                                                                  maxLines: 3,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16.sp),
                                                                ),
                                                              ),
                                                              AutoSizeText(
                                                                " : " +
                                                                    data[
                                                                        'Dakika'] +
                                                                    " dk",
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    color: HexColor(
                                                                        '#6B48FF'),
                                                                    fontSize:
                                                                        16.sp),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                width: 100.w,
                                                                child:
                                                                    AutoSizeText(
                                                                  "Kalan Dakika ",
                                                                  maxLines: 3,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16.sp),
                                                                ),
                                                              ),
                                                              FutureBuilder(
                                                                future: getDakika(
                                                                    data[
                                                                        'Öğrenci']),
                                                                builder:
                                                                    (BuildContext
                                                                            context,
                                                                        snapshot) {
                                                                  var deger = snapshot
                                                                      .data
                                                                      .toString();
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    if (snapshot
                                                                            .connectionState ==
                                                                        ConnectionState
                                                                            .waiting) {
                                                                      return const Center(
                                                                        child:
                                                                            CircularProgressIndicator(),
                                                                      );
                                                                    } else {
                                                                      return AutoSizeText(
                                                                        " : " +
                                                                            deger,
                                                                        maxLines:
                                                                            1,
                                                                        style: TextStyle(
                                                                            color: HexColor(
                                                                                '#6B48FF'),
                                                                            fontSize:
                                                                                16.sp),
                                                                      );
                                                                    }
                                                                  } else if (snapshot
                                                                      .hasError) {
                                                                    return const Text(
                                                                        '-');
                                                                  }
                                                                  return const CircularProgressIndicator();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: IconButton(
                                                        icon: const FaIcon(
                                                            FontAwesomeIcons
                                                                .solidBell),
                                                        color: Colors.green,
                                                        onPressed: () {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection('users')
                                                              .where('Adı',
                                                                  isEqualTo: data[
                                                                      'Öğrenci'])
                                                              .get()
                                                              .then((QuerySnapshot
                                                                  querySnapshot) {
                                                            querySnapshot.docs
                                                                .forEach(
                                                                    (doc) async {
                                                              debugPrint(doc[
                                                                  'notifyToken']);
                                                              final HttpClient
                                                                  httpClient =
                                                                  HttpClient();
                                                              const String
                                                                  fcmUrl =
                                                                  'https://fcm.googleapis.com/fcm/send';
                                                              const fcmKey =
                                                                  "AAAAccRB0XQ:APA91bGhd-rvwLl7bCgb0mYDOM3lFSXQPJ-24a1b968raXLLf_qBUz_nNiG096azUgbY8KPOI0SUv636bP6FKzBJqa9yFR6rKhwiwZDq1dq7VfGMaeTLn-wShq92IjUO99fUcDOWmpuV";
                                                              var headers = {
                                                                'Content-Type':
                                                                    'application/json',
                                                                'Authorization':
                                                                    'key=$fcmKey'
                                                              };
                                                              var request =
                                                                  http.Request(
                                                                      'POST',
                                                                      Uri.parse(
                                                                          fcmUrl));
                                                              request.body =
                                                                  '''{"to":"${doc['notifyToken']}","priority":"high","notification":{"title":"Randevu","body":"Ders Saatiniz Yaklaşıyor!"}}''';
                                                              request.headers
                                                                  .addAll(
                                                                      headers);

                                                              http.StreamedResponse
                                                                  response =
                                                                  await request
                                                                      .send();

                                                              if (response
                                                                      .statusCode ==
                                                                  200) {
                                                                const snackBar =
                                                                    SnackBar(
                                                                  content: Text(
                                                                    'Bildirim Gönderildi.',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  backgroundColor:
                                                                      (Colors
                                                                          .green),
                                                                );
                                                                ScaffoldMessenger
                                                                        .of(
                                                                            context)
                                                                    .showSnackBar(
                                                                        snackBar);
                                                              } else {
                                                                const snackBar =
                                                                    SnackBar(
                                                                  content: Text(
                                                                    'Bildirim Gönderilemedi.',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  backgroundColor:
                                                                      (Colors
                                                                          .red),
                                                                );
                                                                ScaffoldMessenger
                                                                        .of(
                                                                            context)
                                                                    .showSnackBar(
                                                                        snackBar);
                                                              }
                                                            });
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      }
                                    }),
                                SizedBox(
                                  height: 50.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => LessonAdd(
                                                      date: dates[index],
                                                      langue: widget.langue,
                                                    )));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.only(bottom: 15),
                                        child: Row(
                                          children: const [
                                            AutoSizeText(
                                              'Ders Ekle',
                                              maxLines: 2,
                                              style:
                                                  TextStyle(color: Colors.black),
                                            ),
                                            Icon(Icons.add, color: Colors.black)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  sorgu(BuildContext context, Map<String, dynamic> data) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(data['Öğrenci'] + ' Adlı Öğrencinin Dersi Silinsin mi?'),
        actions: [
          CupertinoDialogAction(
              child: const Text('Evet'),
              onPressed: () {
                setState(() {});
                FirebaseFirestore.instance
                    .collection('users')
                    .where('Adı', isEqualTo: data['Öğrenci'])
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  querySnapshot.docs.forEach((doc) async {
                    String lessonurl =
                        "https://dilkumbaram.com/admin/api/dersler2.php?id=" +
                            data['Id'] +
                            "&eposta=" +
                            doc["Eposta"].toString() +
                            "&dakika=" +
                            data['Dakika'] +
                            "";
                    var result = await Dio().get(lessonurl);
                    if (int.parse(result.toString()) == 1) {
                      FirebaseFirestore.instance
                          .collection("lesson")
                          .doc(data['Id'])
                          .delete()
                          .then((v) async {});
                    }
                  });
                });

                Navigator.pop(context);
              }),
          CupertinoDialogAction(
              child: const Text(
                'Hayır',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}

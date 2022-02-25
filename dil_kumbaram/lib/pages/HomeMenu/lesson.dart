import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

bool degerr = false;
FirebaseAuth _auth = FirebaseAuth.instance;
launchWhatsApp() async {
  FirebaseFirestore.instance
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      String langue = documentSnapshot.get('Dil');
      if (langue == 'İngilizce') {
        const link = WhatsAppUnilink(
          phoneNumber: '+905330792483',
          text: "Merhaba, konuşma paketleriniz hakkında bilgi almak istiyorum.",
        );

        await launch('$link', forceSafariVC: false);
      }
      if (langue == 'Almanca') {
        const link = WhatsAppUnilink(
          phoneNumber: '+905465997970',
          text: "Merhaba, konuşma paketleriniz hakkında bilgi almak istiyorum.",
        );

        await launch('$link', forceSafariVC: false);
      }
    } else {
      print('Document does not exist on the database');
    }
  });
}

class LessonPage extends StatefulWidget {
  final bool durum;
  const LessonPage({Key? key, required this.durum}) : super(key: key);

  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('lesson')
      .where("Öğrenci", isEqualTo: _auth.currentUser!.displayName)
      .orderBy('Tarih', descending: true)
      .snapshots();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: widget.durum
          ? AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: HexColor("#5D5FEF"),
                ),
                onPressed: () => {
                  Navigator.pop(context),
                },
              ),
              iconTheme: IconThemeData(
                color: HexColor("#5D5FEF"), //change your color here
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          : AppBar(
              iconTheme: IconThemeData(
                color: HexColor("#5D5FEF"), //change your color here
              ),
              backgroundColor: Colors.transparent,
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
            child: Lessons(usersStream: _usersStream),
          )),
    );
  }
}

class Lessons extends StatelessWidget {
  Lessons({
    Key? key,
    required Stream<QuerySnapshot<Object?>> usersStream,
  })  : _usersStream = usersStream,
        super(key: key);

  final Stream<QuerySnapshot<Object?>> _usersStream;
  ScrollController listcontroller = ScrollController();
  var datenow = DateFormat.yMEd('tr').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width.w * 0.8,
              height: MediaQuery.of(context).size.height.h * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/slide2.png',
                    fit: BoxFit.contain,
                    width: 150.w,
                    height: 150.h,
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  AutoSizeText(
                    'Aktif dersiniz bulunmuyor.',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style:
                        TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Text(
                    'Geç olmadan ve keşke demeden harekete geçmenizi öneriyoruz.',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Dersler ve speaking hakkında bilgi almak için alttaki butondan şimdi iletişime geçebilirsin.',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  SizedBox(
                      height: 50.h,
                      width: 250.w,
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(111.0),
                            ),
                          ),
                          icon: const FaIcon(FontAwesomeIcons.whatsapp),
                          onPressed: () async {
                            launchWhatsApp();
                          },
                          label: const Text('Bilgi Al')))
                ],
              ),
            ),
          );
        }
        return Column(
          children: [
            SizedBox(
              height: 65.h,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                  'Planlanan Derslerim',
                  style:
                      TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                )),
            contact(context),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height.h * 0.8,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  controller: listcontroller,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    
                    DateTime tarih = DateFormat.yMd('tr').parse(datenow);
                    Timestamp stamp = data['Tarih'];
                    DateTime tarih2 =stamp.toDate();
                    final difference = tarih2.difference(tarih).inDays;
                    String formattedDate = DateFormat('dd.MM.yyyy E','tr').format(tarih2);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: difference < 0
                            ? Colors.red.shade200
                            : HexColor('#F4F4F4'),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText(formattedDate),
                                  AutoSizeText(data['Ders']),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const AutoSizeText(
                                          'Eğitmen: ',
                                          maxLines: 3,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        AutoSizeText(
                                          data['Öğretmen'],
                                          maxLines: 3,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const AutoSizeText(
                                          'Eğitmen Notu: ',
                                          maxLines: 3,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        AutoSizeText(
                                          data['Not'],
                                          maxLines: 3,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AutoSizeText(
                                    data['Saat'],
                                    maxLines: 1,
                                    style:
                                        TextStyle(color: HexColor('#6B48FF')),
                                  ),
                                  AutoSizeText(
                                    data['Dakika'] + ' dk',
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: HexColor('#6B48FF')),
                                    onPressed: () async {
                                      if (difference >= 0) {
                                        String url = data['Link'];
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      }
                                    },
                                    child: difference < 0
                                        ? const Text('Süresi Geçti')
                                        : const Text('Derse Git')),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  SizedBox contact(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            height: 50.h,
          ),
          AutoSizeText(
            'Herhangi bir sorun yaşamanız durumunda bizimle iletişime geçebilirsiniz. Dersinizin planlamaya yansıması biraz zaman alabilir.',
            textAlign: TextAlign.center,
            maxLines: 6,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
          ),
          SizedBox(
            height: 20.h,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width.w * 0.8,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(111.0),
                    ),
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.whatsapp,
                    size: 18.sp,
                  ),
                  onPressed: () async {
                    launchWhatsApp();
                  },
                  label: Text(
                    'İletişime Geç',
                    style: TextStyle(fontSize: 18.sp),
                  ))),
        ],
      ),
    );
  }
}

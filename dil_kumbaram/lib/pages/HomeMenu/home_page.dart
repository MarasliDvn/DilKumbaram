import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dil_kumbaram/pages/HomeMenu/lesson.dart';
import 'package:dil_kumbaram/pages/HomeMenu/test_page.dart';
import 'package:dil_kumbaram/pages/SubMenu/kaliplar.dart';

import 'package:dil_kumbaram/pages/SubMenu/kaynaklar_category.dart';
import 'package:dil_kumbaram/pages/SubMenu/kg.dart';
import 'package:dil_kumbaram/pages/premium.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

late String langue;
FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
List<String> baslik = [
  'Kendini Geliştir',
  'Testler',
  'Kaynaklar',
  'Kalıplar',
  'Derslerim'
];
List<String> subBaslik = [
  'Kelimeleri Kartlarla öğren.',
  'Anlama becerini geliştir.',
  'Tekrar etmeye devam et.',
  'Cümleler, atasözleri, daha fazlası.',
  'Speaking yap, derslere katıl.',
];
List<HexColor> colors = [
  HexColor('#008EFE'),
  HexColor('#FE8900'),
  HexColor('#FF0A55'),
  HexColor('#D049FF'),
  HexColor('#00BE08')
];

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({Key? key}) : super(key: key);

  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  String premium = "";
  late PurchaserInfo purchaserInfo;

 

  @override
  void initState() {
    super.initState();
    initPlatformState();
    userIsPremium();
  }
   Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup("goog_REMQBgsymZREiZDwUgZVMLFqYFn");
    purchaserInfo = await Purchases.getPurchaserInfo();
  }

  Future<String> userIsPremium() async {
    await Purchases.setup("goog_REMQBgsymZREiZDwUgZVMLFqYFn");
    purchaserInfo = await Purchases.getPurchaserInfo();
    if (purchaserInfo.entitlements.all["Premium"] != null &&
        purchaserInfo.entitlements.all["Premium"]!.isActive) {
      return 'Abone';
    } else {
      return 'Standart';
    }
  }
  @override
  Widget build(BuildContext context) {
   

    initializeDateFormatting('tr');
    CollectionReference users = _firebaseFirestore.collection('users');
    String imageAssets = "";
    
  

    return SingleChildScrollView(
      child: Container(
         decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TitleWidget(users, imageAssets),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  //subTittle(formattedDate),
                  FutureBuilder(
                      future: userIsPremium(),
                      builder: (context, snapshot) {
                        var deger = snapshot.data.toString();
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return deger == 'Standart'
                              ? const Premium()
                              : const SizedBox();
                        }
                      }),
                  Menu()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column subTittle(String formattedDate) {
    return Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(formattedDate)),
                   SizedBox(
                    height: 10.h,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Learn from yesterday, live for today,hope for tomorrow.',
                        style:
                            TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Dünden öğren, bugün İçin yaşa, yarın İçin umut et.',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
  }

  // ignore: non_constant_identifier_names
  GridView Menu() {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          childAspectRatio: 4,
        ),
        itemCount: baslik.length,
        itemBuilder: (context, index) {
          return InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => KendiniGelistir(dil: langue)),
                  );
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  const TestPage(durum: true,)),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => KaynaklarCategory(
                              langue: langue,
                            )),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Kaliplar()),
                  );
                  break;
                case 4:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LessonPage(durum: true,)),
                  );
                  break;
              }
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 3,
                shadowColor: Colors.white,
                color: colors[index],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  baslik[index].toString(),
                                  style:  TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  subBaslik[index].toString(),
                                  style:  TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  // ignore: non_constant_identifier_names
  Stack TitleWidget(CollectionReference<Object?> users, String imageAssets) {
    return Stack(
      children: [
         Padding(
          padding: const EdgeInsets.all(24.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 250.w,
                child: const AutoSizeText(
                  'Yeniden merhaba, devam etmeye hazır mısın? ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              )),
        ),
        GestureDetector(
          onTap: () {
            changeLanguege();
          },
          child: Hero(
            tag: 'languae',
            child: Align(
              alignment: Alignment.topRight,
              child: LangueImage(users, imageAssets),
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> changeLanguege() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: SizedBox(
              height: 200.h,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                        child: AutoSizeText(
                      'Dil Seçiniz',
                      style: TextStyle(fontSize: 24),
                    )),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              _firebaseFirestore
                                  .collection('users')
                                  .doc(_auth.currentUser!.uid)
                                  .update({'Dil': 'İngilizce'});
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Image.asset('assets/images/english.png')),
                        InkWell(
                            onTap: () {
                              _firebaseFirestore
                                  .collection('users')
                                  .doc(_auth.currentUser!.uid)
                                  .update({'Dil': 'Almanca'});
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Image.asset('assets/images/almanca.png')),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  // ignore: non_constant_identifier_names
  FutureBuilder<DocumentSnapshot<Object?>> LangueImage(
      CollectionReference<Object?> users, String imageAssets) {
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(_auth.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            langue = data['Dil'];
            if (data['Dil'] == 'İngilizce') {
              imageAssets = "assets/images/english.png";
            } else if (data['Dil'] == 'Almanca') {
              imageAssets = "assets/images/almanca.png";
            } else {
              imageAssets = "assets/images/almanca.png";
            }
            return Image.asset(imageAssets);
          }

          return const CircularProgressIndicator();
        });
  }
}

class Premium extends StatefulWidget {
  const Premium({Key? key}) : super(key: key);

  @override
  State<Premium> createState() => _PremiumState();
}

class _PremiumState extends State<Premium> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110.h,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const PremiumPage()))
              .then((value) {
            setState(() {
              // refresh state
            });
          });
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 3,
          shadowColor: Colors.white,
          color: HexColor("#6B48FF"),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children:  [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText(
                            'İndirimli Premium Başlat!',
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText(
                            'Kısa süreliğine geçerli %67 indirim ile kendini geliştir.',
                            style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          )),
                    ],
                  ),
                ),
                //Expanded(
                // child: Align(
                // alignment: Alignment.centerRight,
                //child: Image.asset('assets/images/premium.png'),
                //),
                //),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showCustomDialog(BuildContext context) {}

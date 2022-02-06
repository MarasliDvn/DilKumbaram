import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dil_kumbaram/pages/first_screen_first_page.dart';
import 'package:dil_kumbaram/pages/premium.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mailto/mailto.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late PurchaserInfo purchaserInfo;
  String dakika = "-";
  String premium = "";

  Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup("goog_REMQBgsymZREiZDwUgZVMLFqYFn");
    purchaserInfo = await Purchases.getPurchaserInfo();
  }

  Future<String> userIsPremium() async {
    purchaserInfo = await Purchases.getPurchaserInfo();
    if (purchaserInfo.entitlements.all["Premium"] != null &&
        purchaserInfo.entitlements.all["Premium"]!.isActive) {
      return 'Abone';
    } else {
      return 'Standart';
    }
  }

  CollectionReference users = _firebaseFirestore.collection('users');
  final ButtonStyle logoutbutton = ElevatedButton.styleFrom(
    textStyle: TextStyle(fontSize: 12.sp),
    primary: HexColor("#6B48FF"),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
  );
  final ButtonStyle orderbutton = ElevatedButton.styleFrom(
    textStyle: TextStyle(fontSize: 12.sp, color: Colors.black),
    primary: Colors.grey,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
  );
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    initPlatformState();
    getDakika();
  }

  @override
  Widget build(BuildContext context) {
    userIsPremium();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: 50.h,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Profilim',
                  style:
                      TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 50.h,
            ),
            Expanded(
              child: SizedBox(
                child: Column(
                  children: [
                    SizedBox(height: 25.h, child: eposta()),
                    const Divider(
                      thickness: 2,
                    ),
                    SizedBox(height: 25.h, child: langue()),
                    const Divider(
                      thickness: 2,
                    ),
                    SizedBox(height: 25.h, child: dakikaRow()),
                    const Divider(
                      thickness: 2,
                    ),
                    SizedBox(height: 25.h, child: account()),
                    const Divider(
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    FutureBuilder(
                        future: userIsPremium(),
                        builder: (context, snapshot) {
                          var deger = snapshot.data.toString();
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                              child: Text('Hata Oluştu.'),
                            );
                          } else {
                            return deger == 'Standart'
                                ? const Premium()
                                : const SizedBox();
                          }
                        }),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () async {
                            final mailtoLink = Mailto(
                              to: ['info@dilkumbaram.com'],
                              subject: '',
                              body: '',
                            );
                            // Convert the Mailto instance into a string.
                            // Use either Dart's string interpolation
                            // or the toString() method.
                            await launch('$mailtoLink');
                          },
                          child: const Text("Geri Bildirim & Destek"),
                          style: orderbutton,
                        )),
                    SizedBox(
                      height: 15.h,
                    ),
                    SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () async {
                            String url =
                                'https://dilkumbaram.com/privacy-policy';
                            if (await canLaunch(url)) {
                              launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: const Text("Gizlilik Politikası"),
                          style: orderbutton,
                        )),
                    SizedBox(
                      height: 15.h,
                    ),
                    SizedBox(
                        height: 50.h,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            String url = 'https://dilkumbaram.com/terms';
                            if (await canLaunch(url)) {
                              launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: const Text("Kullanım Sözleşmesi"),
                          style: orderbutton,
                        )),
                    SizedBox(
                      height: 15.h,
                    ),
                    SizedBox(
                        height: 50.h,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await _signOut();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const FirstPage(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text("Çıkış Yap"),
                          style: logoutbutton,
                        )),
                    SizedBox(
                      height: 15.h,
                    ),
                    Center(
                      child: Text(
                        'Dil Kumbaram © 2022',
                        style: TextStyle(fontSize: 13.sp),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Row eposta() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AutoSizeText(
          "Eposta",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16.sp),
        ),
        FutureBuilder<DocumentSnapshot>(
            future: users.doc(_auth.currentUser!.uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Hata!");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return const Text("Mevcut Değil");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;

                return AutoSizeText(
                  data['Eposta'],
                  style: TextStyle(fontSize: 16.sp),
                );
              }

              return const Text("Yükleniyor...");
            })
      ],
    );
  }

  Row langue() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AutoSizeText(
          "Seçili Dil",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16.sp),
        ),
        FutureBuilder<DocumentSnapshot>(
            future: users.doc(_auth.currentUser!.uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Hata!");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return const Text("Mevcut Değil");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                String dropdownValue = data['Dil'];
                return DropdownButton(
                  underline: const SizedBox(),
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      _firebaseFirestore
                          .collection('users')
                          .doc(_auth.currentUser!.uid)
                          .update({'Dil': dropdownValue});
                    });
                  },
                  items: <String>['İngilizce', 'Almanca']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    );
                  }).toList(),
                );
              }

              return const Text("Yükleniyor...");
            })
      ],
    );
  }

  Row account() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Üyelik",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16.sp),
        ),
        FutureBuilder(
            future: userIsPremium(),
            builder: (context, snapshot) {
              var deger = snapshot.data.toString();
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text('Yükleniyor'),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Hata Oluştu.'),
                );
              } else {
                return deger == 'Standart'
                    ? Text(
                        'Standart',
                        style: TextStyle(fontSize: 16.sp),
                      )
                    : Text(
                        'Abone',
                        style: TextStyle(fontSize: 16.sp),
                      );
              }
            }),
      ],
    );
  }

  getDakika() async {
    String lessonurl = "https://dilkumbaram.com/admin/api/dakika.php?eposta=" +
        _auth.currentUser!.email.toString() +
        "";
    var result = await Dio().get(lessonurl);

    dakika = result.data.toString();
    setState(() {});
  }

  Row dakikaRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Dakika",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16.sp),
        ),
        Text(
          dakika,
          style: TextStyle(fontSize: 16.sp),
        ),
      ],
    );
  }
}

class Premium extends StatefulWidget {
  const Premium({
    Key? key,
  }) : super(key: key);

  @override
  State<Premium> createState() => _PremiumState();
}

class _PremiumState extends State<Premium> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.h,
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
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'İndirimli Premium Başlat!',
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Kısa süreliğine geçerli %67 indirim ile kendini geliştir.',
                            style: TextStyle(
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
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

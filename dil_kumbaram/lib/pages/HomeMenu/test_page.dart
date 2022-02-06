import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dil_kumbaram/pages/HomeMenu/testpage_details.dart';
import 'package:dil_kumbaram/pages/premium.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
String langue = "";

class TestPage extends StatefulWidget {
  final bool durum;
  const TestPage({Key? key, required this.durum}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String premium = "";
  late PurchaserInfo purchaserInfo;

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

  @override
  void initState() {
    super.initState();
    languee();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    userIsPremium().then((String result) {});
    return Scaffold(
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
      body: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Testler',
                      style: TextStyle(
                          fontSize: 32.sp, fontWeight: FontWeight.bold))),
              SizedBox(
                height: 35.h,
              ),
              kelimewidget(context),
              dinlemewidget(context),
              izlemewidget(context),
              cumlewidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Card cumlewidget(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          userIsPremium().then((String result) {
            if (result == 'Standart') {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PremiumPage()));
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TestDetails(
                        dil: langue,
                        test: 'Cümle Testi',
                      )));
            }
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/cumletesti.png',
              fit: BoxFit.fill,
            ),
            Positioned(
              left: 15,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Cümle Testi',
                    style: TextStyle(color: Colors.white, fontSize: 24.sp),
                  )),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
    );
  }

  Card izlemewidget(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          userIsPremium().then((String result) {
            if (result == 'Standart') {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PremiumPage()));
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TestDetails(
                        dil: langue,
                        test: 'İzleme Testi',
                      )));
            }
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/izlemetesti.png',
              fit: BoxFit.fill,
            ),
            const Positioned(
              left: 15,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'İzleme Testi',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
    );
  }

  Card dinlemewidget(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          userIsPremium().then((String result) {
            if (result == 'Standart') {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PremiumPage()));
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TestDetails(
                        dil: langue,
                        test: 'Dinleme Testi',
                      )));
            }
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/dinlemetesti.png',
              fit: BoxFit.fill,
            ),
            const Positioned(
              left: 15,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Dinleme Testi',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
    );
  }

  Card kelimewidget(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          userIsPremium().then((String result) {
            if (result == 'Standart') {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PremiumPage()));
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TestDetails(
                        dil: langue,
                        test: 'Kelime Testi',
                      )));
            }
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/kelimetesti.png',
              fit: BoxFit.fill,
            ),
            Positioned(
              left: 15,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Kelime Testi',
                    style: TextStyle(color: Colors.white, fontSize: 24.sp),
                  )),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
    );
  }
}

Future<void> languee() async {
  await FirebaseFirestore.instance
      .collection('users')
      .where('Eposta', isEqualTo: _auth.currentUser!.email.toString())
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var element in querySnapshot.docs) {
      langue = element['Dil'];
    }
  });
}

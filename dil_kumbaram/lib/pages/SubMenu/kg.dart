
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dil_kumbaram/models/kg_models.dart';

import 'package:dil_kumbaram/pages/SubMenu/kg_category.dart';
import 'package:dil_kumbaram/pages/premium.dart';
import 'package:dil_kumbaram/services/kg_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
String langue = "";

class KendiniGelistir extends StatefulWidget {
  final String dil;
  const KendiniGelistir({Key? key, required this.dil}) : super(key: key);

  @override
  _KendiniGelistirState createState() => _KendiniGelistirState();
}

class _KendiniGelistirState extends State<KendiniGelistir> {
  late Future<List<KgModel>> _kgList;
  late Future<List<KgModel>> _kgList2;
  late PurchaserInfo purchaserInfo;
  late SharedPreferences sharedPreferences;
  Future<void> readySharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    debugPrint(sharedPreferences.getKeys().toString());
    setState(() {});
  }

  Future<void> initPlatformState() async {
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
    initPlatformState();
    readySharedPreferences();
    if (widget.dil == 'İngilizce') {
      _kgList = KgApi.getKgisti();
      _kgList2 = KgApi.getKgisti2();
    }
    if (widget.dil == 'Almanca') {
      _kgList = KgApi.getKgasti();
      _kgList2 = KgApi.getKgasti2();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Kendini Geliştir',
                      style: TextStyle(
                          fontSize: 32.sp, fontWeight: FontWeight.bold))),
              SizedBox(
                height: 35.sp,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Popüler Desteler',
                      style: TextStyle(
                          fontSize: 24.sp, fontWeight: FontWeight.bold))),
              populer(),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Tüm Desteler',
                      style: TextStyle(
                          fontSize: 24.sp, fontWeight: FontWeight.bold))),
              all(),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<KgModel>> all() {
    return FutureBuilder<List<KgModel>>(
        future: _kgList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<KgModel> _kgList = snapshot.data!;

            return Expanded(
              child: SizedBox(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: _kgList.length,
                    itemBuilder: (context, index) {
                      var kategori = _kgList[index].kategori;
                      String _url = 'https://kumbaram.dilkumbaram.com/' +
                          _kgList[index].glink.toString();

                      bool durum;
                      if (purchaserInfo.entitlements.all["Premium"] != null &&
                          purchaserInfo.entitlements.all["Premium"]!.isActive) {
                        durum = true;
                      } else {
                        durum = false;
                      }
                      String kategorii = kategori.toString();
                      debugPrint(sharedPreferences.get(kategorii).toString());
                      //sharedPreferences.remove(kategorii);
                      return InkWell(
                        //splashColor: Colors.transparent,
                        //highlightColor: Colors.transparent,
                        //hoverColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          if (kategorii == 'Renkler' ||
                              kategorii == 'Karıştırılan İngilizce Kelimeler' ||
                              kategorii == 'Aile Üyeleri' ||
                              kategorii == 'Ülkeler' ||
                              kategorii == 'Din ve İnanç') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => KgCategory(
                                          category: kategorii,
                                          dil: widget.dil,
                                          url: _url,
                                        ))).then((value) {
                              setState(() {
                                // refresh state
                              });
                            });
                          } else if (durum) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => KgCategory(
                                          category: kategorii,
                                          dil: widget.dil,
                                          url: _url,
                                        ))).then((value) {
                              setState(() {
                                // refresh state
                              });
                            });
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PremiumPage())).then((value) {
                              setState(() {
                                // refresh state
                              });
                            });
                          }
                        },
                        child: SizedBox(
                          height: 55.h,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 3,
                            color: kategorii == 'Renkler' ||
                                    kategorii ==
                                        'Karıştırılan İngilizce Kelimeler' ||
                                    kategorii == 'Aile Üyeleri' ||
                                    kategorii == 'Ülkeler' ||
                                    kategorii == 'Din ve İnanç'
                                ? HexColor('#6B48FF')
                                : durum
                                    ? HexColor('#6B48FF')
                                    : HexColor('#E8E8E8'),
                            shadowColor: Colors.grey,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 15.w,
                                ),
                                Image.network(
                                  _url,
                                  height: 24.h,
                                  width: 24.w,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  width: 15.sp,
                                ),
                                Expanded(
                                  child: Text(
                                    kategori.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.sp,
                                      color: kategorii == 'Renkler' ||
                                              kategorii ==
                                                  'Karıştırılan İngilizce Kelimeler' ||
                                              kategorii == 'Aile Üyeleri' ||
                                              kategorii == 'Ülkeler' ||
                                              kategorii == 'Din ve İnanç'
                                          ? HexColor('#FFFFFF')
                                          : durum
                                              ? HexColor('#FFFFFF')
                                              : HexColor('#4F4F4F'),
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                sharedPreferences.get(widget.dil + kategorii) ==
                                        1
                                    ? Container(
                                        margin: EdgeInsets.only(right: 10.sp),
                                        child: Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                          size: 32.sp,
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Veri Gelmedi'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  FutureBuilder<List<KgModel>> populer() {
    return FutureBuilder<List<KgModel>>(
        future: _kgList2,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<KgModel> _kgList2 = snapshot.data!;

            return SizedBox(
              height: 150.h,
              child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  shrinkWrap: true,
                  //scrollDirection: Axis.horizontal,
                  itemCount: _kgList2.length,
                  itemBuilder: (context, index) {
                    var kategori = _kgList2[index].kategori;
                    String img = "";
                    String _url = 'https://kumbaram.dilkumbaram.com/' +
                        _kgList2[index].glink.toString();
                    if (index == 0) {
                      img = "assets/images/p1.png";
                    } else if (index == 1) {
                      img = "assets/images/p2.png";
                    } else if (index == 2) {
                      img = "assets/images/p3.png";
                    }

                    HexColor hexColor2;
                    BoxDecoration boxDecoration;
                    if (purchaserInfo.entitlements.all["Premium"] != null &&
                        purchaserInfo.entitlements.all["Premium"]!.isActive) {
                      hexColor2 = HexColor("#FFFFFF");
                      boxDecoration = BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: AssetImage(img), fit: BoxFit.cover),
                      );
                    } else {
                      //hexColor2 = HexColor("#4F4F4F");
                      hexColor2 = HexColor("#FFFFFF");
                      boxDecoration = BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: AssetImage(img), fit: BoxFit.cover),
                      );
                    }
                    //sharedPreferences.remove(kategori.toString());
                    return InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () async {
                        late PurchaserInfo purchaserInfo;
                        await Purchases.setup(
                            "goog_REMQBgsymZREiZDwUgZVMLFqYFn");
                        purchaserInfo = await Purchases.getPurchaserInfo();
                        if (purchaserInfo.entitlements.all["Premium"] != null &&
                            purchaserInfo
                                .entitlements.all["Premium"]!.isActive) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KgCategory(
                                        category: kategori.toString(),
                                        dil: widget.dil,
                                        url: _url,
                                      ))).then((value) {
                            setState(() {
                              // refresh state
                            });
                          });
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PremiumPage())).then((value) {
                            setState(() {
                              // refresh state
                            });
                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        width: 150.w,
                        decoration: boxDecoration,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 0,
                          color: Colors.transparent,
                          shadowColor: Colors.grey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    kategori.toString(),
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.sp,
                                      color: hexColor2,
                                    ),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              sharedPreferences.get(
                                          widget.dil + kategori.toString()) ==
                                      1
                                  ? Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 32.sp,
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Veri Gelmedi'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
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

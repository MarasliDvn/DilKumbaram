
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dil_kumbaram/models/kaliplar_models.dart';
import 'package:dil_kumbaram/pages/SubMenu/kaliplar_details.dart';
import 'package:dil_kumbaram/pages/premium.dart';
import 'package:dil_kumbaram/services/kaliplar_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class Kaliplar extends StatefulWidget {
  const Kaliplar({Key? key}) : super(key: key);

  @override
  _KaliplarState createState() => _KaliplarState();
}

class _KaliplarState extends State<Kaliplar> {
  late Future<List<KaliplarModel>> _kaliplarList;
  late PurchaserInfo purchaserInfo;

  Future<void> initPlatformState() async {
    await Purchases.setup("goog_REMQBgsymZREiZDwUgZVMLFqYFn");
    purchaserInfo = await Purchases.getPurchaserInfo();
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _kaliplarList = KaliplarApi.getKalipData();
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
        backgroundColor: HexColor('#f4f4f4'),
        elevation: 0,
      ),
      body: Container(
         decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
             Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Kal??plar',
                      style: TextStyle(
                          fontSize: 32.sp, fontWeight: FontWeight.bold))),
              SizedBox(
                height: 35.h,
              ),
              //Align(alignment: Alignment.centerLeft, child: Text('Seviye',style: TextStyle(fontSize: 18))),
              FutureBuilder<List<KaliplarModel>>(
                  future: _kaliplarList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<KaliplarModel> _listKalip = snapshot.data!;
                      return Expanded(
                        child: SizedBox(
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: _listKalip.length,
                              itemBuilder: (context, index) {
                                var kategori = _listKalip[index].kategori;
                                bool durum;
                                if (purchaserInfo.entitlements.all["Premium"] !=
                                        null &&
                                    purchaserInfo.entitlements.all["Premium"]!
                                        .isActive) {
                                  durum = true;
                                } else {
                                  durum = false;
                                }
                                String kategorii = kategori.toString();
                                String icon = 'assets/images/standart.png';

                                icon = iconlar(kategorii, icon);

                                return InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: () async {
                                    String langue = "";
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .where('Eposta',
                                            isEqualTo: _auth.currentUser!.email
                                                .toString())
                                        .get()
                                        .then((QuerySnapshot querySnapshot) {
                                      for (var element in querySnapshot.docs) {
                                        langue = element['Dil'];
                                      }
                                    });
                                    if (kategorii == 'Atas??zleri' ||
                                        kategorii == 'Seyahat kal??plar??' ||
                                        kategorii ==
                                            'Toplant?? ve Sunumlar') {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  KaliplarDetails(
                                                    langue: langue,
                                                    kategori: kategorii,
                                                  )));
                                    } else if (durum) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  KaliplarDetails(
                                                    langue: langue,
                                                    kategori: kategorii,
                                                  )));
                                    } else {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PremiumPage()))
                                          .then((value) {
                                        setState(() {
                                          // refresh state
                                        });
                                      });
                                    }
                                  },
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minHeight: 55.h, maxHeight: 70.w),
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: (7.5).h,top: (7.5).h),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        elevation: 3,
                                        color: kategorii == 'Atas??zleri' ||
                                                kategorii ==
                                                    'Seyahat kal??plar??' ||
                                                kategorii ==
                                                    'Toplant?? ve Sunumlar'
                                            ? HexColor('#6B48FF')
                                            : durum
                                                ? HexColor('#6B48FF')
                                                : HexColor('#E8E8E8'),
                                        shadowColor: Colors.grey,
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(left: 10),
                                              child: Image.asset(
                                                icon,
                                                height: 24.h,
                                                width: 24.w,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15.w,
                                            ),
                                            Flexible(
                                              child: Container(
                                                margin: const EdgeInsets.all(8),
                                                child: Text(
                                                  kategori.toString(),
                                                  overflow: TextOverflow.ellipsis,
                                                  
                                                  style: TextStyle(
                                                    fontSize: 24.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: kategorii ==
                                                                'Atas??zleri' ||
                                                            kategorii ==
                                                                'Seyahat kal??plar??' ||
                                                            kategorii ==
                                                                'Toplant?? ve Sunumlar'
                                                        ? HexColor('#FFFFFF')
                                                        : durum
                                                            ? HexColor('#FFFFFF')
                                                            : HexColor('#4F4F4F'),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
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
                  })
            ],
          ),
        ),
      ),
    );
  }

  String iconlar(String kategorii, String icon) {
    if (kategorii == 'Dizi ve Filmler') {
      icon = 'assets/images/icons/film.png';
    }
    if (kategorii == 'Diyalog Kal??plar??') {
      icon = 'assets/images/icons/konusma.png';
    }
    if (kategorii == 'Yol tarifi nas??l yap??l??r?') {
      icon = 'assets/images/icons/yol.png';
    }
    if (kategorii == 'Seyahat kal??plar??') {
      icon = 'assets/images/icons/seyehatgezi.png';
    }
    if (kategorii == 'Toplant?? ve Sunumlar') {
      icon = 'assets/images/icons/toplant??.png';
    }
    if (kategorii == 'Mutlaka g??z at') {
      icon = 'assets/images/icons/mutlaka.png';
    }
    if (kategorii == 'Telefon g??r????mesi') {
      icon = 'assets/images/icons/ileti??im.png';
    }
    if (kategorii == 'Tan????ma & hal hat??r') {
      icon = 'assets/images/icons/tanisma.png';
    }
    if (kategorii == 'Sipari?? verme') {
      icon = 'assets/images/icons/al????veri??.png';
    }
    if (kategorii == 'Saatler') {
      icon = 'assets/images/icons/saatler.png';
    }
    if (kategorii == 'Otel diyalog') {
      icon = 'assets/images/icons/hotel.png';
    }
    if (kategorii == '??kinci el e??ya diyalog') {
      icon = 'assets/images/icons/2.el.png';
    }
    if (kategorii == 'Hava durumu') {
      icon = 'assets/images/icons/havadurumu.png';
    }
    if (kategorii == 'Hastane diyalog') {
      icon = 'assets/images/icons/hastanediyalog.png';
    }
    if (kategorii == 'Duygular') {
      icon = 'assets/images/icons/duygular.png';
    }
    if (kategorii == 'Arkada??l??k') {
      icon = 'assets/images/icons/arkada??l??k.png';
    }
    if (kategorii == 'Al????veri?? diyalog') {
      icon = 'assets/images/icons/al????veri??diyalog.png';
    }
    if (kategorii == 'Adres sorma') {
      icon = 'assets/images/icons/adressorma.png';
    }
    return icon;
  }
}

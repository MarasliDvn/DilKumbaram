
import 'package:dil_kumbaram/models/kaynaklar_models.dart';
import 'package:dil_kumbaram/pages/SubMenu/kaynaklar_details.dart';
import 'package:dil_kumbaram/pages/premium.dart';
import 'package:dil_kumbaram/services/kaynaklar_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class KaynaklarCategory extends StatefulWidget {
  final String langue;
  const KaynaklarCategory({Key? key, required this.langue}) : super(key: key);

  @override
  _KaynaklarCategoryState createState() => _KaynaklarCategoryState();
}

class _KaynaklarCategoryState extends State<KaynaklarCategory> {
  late Future<List<KaynaklarModel>> _kaynaklarList;
  late PurchaserInfo purchaserInfo;

  Future<void> initPlatformState() async {
    await Purchases.setup("goog_REMQBgsymZREiZDwUgZVMLFqYFn");
    purchaserInfo = await Purchases.getPurchaserInfo();
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _kaynaklarList = KaynaklarApi.getKaynakData(widget.langue);
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
                  child: Text('Kaynaklar',
                      style: TextStyle(
                          fontSize: 32.sp, fontWeight: FontWeight.bold))),
             
              SizedBox(
                height: 35.h,
              ),
              //Align(alignment: Alignment.centerLeft, child: Text('Seviye',style: TextStyle(fontSize: 18))),
              kategoriler(),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<KaynaklarModel>> kategoriler() {
    return FutureBuilder<List<KaynaklarModel>>(
        future: _kaynaklarList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<KaynaklarModel> _listKaynak = snapshot.data!;
            return Expanded(
              child: SizedBox(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: _listKaynak.length,
                    itemBuilder: (context, index) {
                      var kategori = _listKaynak[index].kategori;
                      bool durum;
                      if (purchaserInfo.entitlements.all["Premium"] != null &&
                          purchaserInfo.entitlements.all["Premium"]!.isActive) {
                        durum = true;
                      } else {
                        durum = false;
                      }
                      String kategorii = kategori.toString();

                      return InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () async {
                          if (kategorii == 'İsim') {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => KaynaklarDetails(
                                      langue: widget.langue,
                                      kategori: kategorii,
                                    )));
                          } else if (durum) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => KaynaklarDetails(
                                      langue: widget.langue,
                                      kategori: kategorii,
                                    )));
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
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(maxHeight: 70.h, minHeight: 55.w),
                          child: Container(
                            margin: EdgeInsets.only(bottom: (7.5).h, top: (7.5).h),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 3,
                              color: kategorii == 'İsim'
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
                                      "assets/images/standart.png",
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
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24.sp,
                                          color: kategorii == 'İsim'
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
        });
  }
}

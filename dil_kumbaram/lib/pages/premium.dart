// ignore_for_file: avoid_print

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:restart_app/restart_app.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({Key? key}) : super(key: key);

  @override
  _PremiumPageState createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  late PurchaserInfo purchaserInfo;
  bool toggle = true;
  bool toggle2 = false;
  Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup("goog_REMQBgsymZREiZDwUgZVMLFqYFn");
    purchaserInfo = await Purchases.getPurchaserInfo();
  }

  final ButtonStyle nextButton = ElevatedButton.styleFrom(
    textStyle: TextStyle(fontSize: 12, color: HexColor("#6B48FF")),
    primary: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
  );
  final ButtonStyle resume = ElevatedButton.styleFrom(
    textStyle: const TextStyle(
        fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
    primary: HexColor('#5FF21A'),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
  );
  final ButtonStyle nextButton2 = ElevatedButton.styleFrom(
    textStyle: TextStyle(fontSize: 12, color: HexColor("#6B48FF")),
    primary: HexColor("#ABFFC3"),
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
  }

  Future<void> showPaywallMonthly() async {
    Offerings offerings = await Purchases.getOfferings();
    if (offerings.current != null && offerings.current!.monthly != null) {
      //final currentMonthlyProduct = offerings.current!.monthly!.product;
      await makePurchases(offerings.current!.monthly);
    }
  }

  Future<void> showPaywallAnnual() async {
    Offerings offerings = await Purchases.getOfferings();
    if (offerings.current != null && offerings.current!.annual != null) {
      //final currentAnnualProduct = offerings.current!.annual!.product;
      await makePurchases(offerings.current!.annual);
    }
  }

  Future<void> makePurchases(Package? package) async {
    try {
      purchaserInfo = await Purchases.purchasePackage(package!);
      print(purchaserInfo);
      Restart.restartApp();
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#6B48FF'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  )),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Image.asset('assets/images/premium.png'),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: AutoSizeText(
                          "%67 İndirim ile \n Kendini Geliştir",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: AutoSizeText(
                          "Kısa süreliğine geçerli kampanya",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
                        child: Column(
                          children: [
                            SizedBox(
                                width: double.infinity,
                                height: 65.h,
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        toggle = true;
                                        toggle2 = false;
                                      });
                                    },
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Wrap(children: [
                                            toggle
                                                ? Icon(
                                                    Icons.circle_rounded,
                                                    color: HexColor("#6B48FF"),
                                                  )
                                                : Icon(
                                                    Icons.circle_outlined,
                                                    color: HexColor("#6B48FF"),
                                                  ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Text(
                                              'Yıllık',
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  color: HexColor("#6B48FF")),
                                            ),
                                          ]),
                                          Row(
                                            children: [
                                              Text(
                                                '579 ₺ yerine',
                                                style: TextStyle(
                                                    fontSize: 11.sp,
                                                    color: HexColor("#6B48FF")
                                                        .withOpacity(0.5)),
                                              ),
                                              SizedBox(
                                                width: 5.h,
                                              ),
                                              Text(
                                                '219 ₺',
                                                style: TextStyle(
                                                    fontSize: 20.sp,
                                                    color: HexColor("#6B48FF")),
                                              ),
                                            ],
                                          ),
                                        ]),
                                    style: toggle ? nextButton2 : nextButton)),
                            SizedBox(
                              height: 15.h,
                            ),
                            SizedBox(
                                width: double.infinity,
                                height: 65.h,
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        toggle2 = true;
                                        toggle = false;
                                      });
                                    },
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Wrap(children: [
                                            toggle2
                                                ? Icon(
                                                    Icons.circle_rounded,
                                                    color: HexColor("#6B48FF"),
                                                  )
                                                : Icon(
                                                    Icons.circle_outlined,
                                                    color: HexColor("#6B48FF"),
                                                  ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Text(
                                              'Aylık',
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  color: HexColor("#6B48FF")),
                                            ),
                                          ]),
                                          Text(
                                            '79 ₺',
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                color: HexColor("#6B48FF")),
                                          ),
                                        ]),
                                    style: toggle2 ? nextButton2 : nextButton)),
                            SizedBox(
                              height: 35.h,
                            ),
                            const Madde(),
                            SizedBox(
                              height: 35.h,
                            ),
                            SizedBox(
                                width: double.infinity,
                                height: 55.h,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      if (toggle) {
                                        await showPaywallAnnual();
                                        //Restart.restartApp();
                                      } else if (toggle2) {
                                        await showPaywallMonthly();
                                        //Restart.restartApp();
                                      } else {
                                        final snackBar = SnackBar(
                                          content: const Text(
                                            'Lütfen Bir Abonelik Seçiniz.',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: (Colors.red),
                                          action: SnackBarAction(
                                            textColor: Colors.white,
                                            label: 'Tamam',
                                            onPressed: () {},
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                      setState(() {});
                                    },
                                    child: Text(
                                      'Devam',
                                      style: TextStyle(
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    style: resume)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Madde extends StatelessWidget {
  const Madde({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
                size: 24.sp,
              ),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                  child: AutoSizeText(
                "Video ve telafuz testleri",
                maxLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 20.sp),
              )),
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
                size: 24.sp,
              ),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                  child: AutoSizeText(
                "Binlerce sesli kelime kartı",
                maxLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 20.sp),
              )),
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
                size: 24.sp,
              ),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                  child: AutoSizeText(
                "Konu anlatımı ve gramer",
                maxLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 20.sp),
              )),
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
                size: 24.sp,
              ),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                  child: AutoSizeText(
                "Kalıplar ve diyaloglar",
                maxLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 20.sp),
              )),
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
                size: 24.sp,
              ),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                  child: AutoSizeText(
                "İstediğin dili öğren",
                maxLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 20.sp),
              )),
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
                size: 24.sp,
              ),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                  child: AutoSizeText(
                "Sınırsız erişim",
                maxLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 20.sp),
              )),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';

import 'package:dil_kumbaram/contants/contants.dart';
import 'package:dil_kumbaram/pages/HomeMenu/error_test_details.dart';
import 'package:dil_kumbaram/pages/HomeMenu/testpage_details.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';



class TestStart extends StatefulWidget {
  final String dil, test;
  const TestStart({Key? key, required this.dil, required this.test})
      : super(key: key);

  @override
  _TestStartState createState() => _TestStartState();
}

class _TestStartState extends State<TestStart> {
  final ButtonStyle loginbutton = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 20),
    primary: HexColor("#6B48FF"),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(11.0)),
    ),
  );
  final ButtonStyle loginbutton2 = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 20),
    primary: const Color.fromRGBO(255, 0, 0, 0.5),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(11.0)),
    ),
  );
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SelectingLangue(
        loginbutton: loginbutton,
        test: widget.test,
        dil: widget.dil,
        loginbutton2: loginbutton2);
  }
}

class SelectingLangue extends StatelessWidget {
  final String test, dil;
  final ButtonStyle loginbutton2;
  const SelectingLangue({
    Key? key,
    required this.loginbutton,
    required this.loginbutton2,
    required this.test,
    required this.dil,
  }) : super(key: key);

  final ButtonStyle loginbutton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  height: 100.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/testpage.png',
                    width: 139.w,
                    height: 143.h,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      AutoSizeText(
                        test,
                        style: Constants.getTitleStyle(),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      RichText(
                        text: TextSpan(
                            style: Constants.getSubTitleStyle(),
                            children: [
                              TextSpan(
                                  text: test +
                                      "nde tüm kelimeler karışık olarak önüne gelir ve bildiğin kelimelerle bir daha karşılaşmazsın, aynı zamanda"),
                              const TextSpan(
                                  text: ' hatalarından ders alarak',
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 0, 0, 0.5))),
                              const TextSpan(text: ' ilerleyebilirsin.'),
                            ]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      Ingilizce(
                        loginbutton: loginbutton,
                        dil: dil,
                        test: test,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Almanca(
                        loginbutton2: loginbutton2,
                        dil: dil,
                        test: test,
                      )
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

class Ingilizce extends StatelessWidget {
  final String dil, test;
  const Ingilizce({
    Key? key,
    required this.loginbutton,
    required this.dil,
    required this.test,
  }) : super(key: key);

  final ButtonStyle loginbutton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250.w,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TestDetails(
                    dil: dil,
                    test: test,
                  )));
        },
        child: const AutoSizeText("Testi Başlat"),
        style: loginbutton,
      ),
    );
  }
}

class Almanca extends StatelessWidget {
  final String dil, test;
  const Almanca({
    Key? key,
    required this.dil,
    required this.test,
    required this.loginbutton2,
  }) : super(key: key);

  final ButtonStyle loginbutton2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250.w,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TestDetailsError(
                    dil: dil,
                    test: test,
                  )));
        },
        child: const AutoSizeText(
          "Hatalarından Ders Al",
          maxLines: 1,
        ),
        style: loginbutton2,
      ),
    );
  }
}

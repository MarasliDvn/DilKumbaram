import 'package:dil_kumbaram/widgets/firstpage_widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';



// ignore: camel_case_types
class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle registerbutton = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      primary: HexColor("#6B48FF"),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
    );
    final ButtonStyle loginbutton = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        primary: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FirstPageWidgets(
          registerbutton: registerbutton, loginbutton: loginbutton),
    );
  }
}

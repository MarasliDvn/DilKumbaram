
import 'package:dil_kumbaram/widgets/rpass_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class RpassPage extends StatefulWidget {
  const RpassPage({Key? key}) : super(key: key);

  @override
  _RpassPageState createState() => _RpassPageState();
}

class _RpassPageState extends State<RpassPage> {
  
  final ButtonStyle loginbutton = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      primary: HexColor("#6B48FF"),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
    );
    final ButtonStyle googleLogin = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        primary: HexColor('#FF8181'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ));
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        
        leading:  IconButton(
          icon:  Icon(
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
        child: RpassWidgets(formKey: _formKey, loginbutton: loginbutton, googleLogin: googleLogin)),
    );
  }
}





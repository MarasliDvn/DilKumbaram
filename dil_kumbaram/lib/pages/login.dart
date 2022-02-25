import 'package:dil_kumbaram/widgets/loginpage_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
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
        reverse: true,

        child: Padding(
           padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom*0.8),
          child: LoginPageWidgets(formKey: _formKey, loginbutton: loginbutton, googleLogin: googleLogin),
        )),
    );
  }
}








import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hexcolor/hexcolor.dart';



class RpassWidgets extends StatefulWidget {
  const RpassWidgets({
    Key? key,
    required GlobalKey<FormState> formKey,
    required this.loginbutton,
    required this.googleLogin,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final ButtonStyle loginbutton;
  final ButtonStyle googleLogin;

  @override
  State<RpassWidgets> createState() => _RpassWidgetsState();
}

class _RpassWidgetsState extends State<RpassWidgets> {
  String _email = '';
  Future resetPass() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content:
            Text("Şifre sıfırlama bağlantısı e-posta adresinize gönderildi."),
        duration: Duration(milliseconds: 3000),
      ));
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      FocusScope.of(context).requestFocus(FocusNode());
      if (e.toString() ==
          '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Bu e-posta adresi kayıtlı değil.',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(milliseconds: 3000),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: 100.h,
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/newlogo.png',
                width: 293.w,
                height: 212.h,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: widget._formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Material(
                      elevation: 5,
                      shadowColor: HexColor('#000000'),
                      borderRadius: BorderRadius.circular(10),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          //errorStyle: TextStyle(color: Colors.orange),
                          fillColor: HexColor("#F8F8FC"),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#91919F")),
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'E-mail',
                          //hintText: 'E-mail',
                          labelStyle: TextStyle(color: HexColor("#91919F")),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.email_rounded,
                              color: HexColor("#6360FF"),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: HexColor("#6B48FF")),
                          ),
                        ),
                        onSaved: (deger) {
                          _email = deger!;
                        },
                        validator: (deger) {
                          if (deger!.isEmpty) {
                            return 'E-mail boş olamaz';
                          } else if (!EmailValidator.validate(deger)) {
                            return 'Geçerli mail giriniz';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 250.w,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () {
                            bool _validate =
                                widget._formKey.currentState!.validate();
                            if (_validate) {
                              widget._formKey.currentState!.save();
                              resetPass();
                              widget._formKey.currentState!.reset();
                            }
                          },
                          child: const Text('Şifre Sıfırla'),
                          style: widget.loginbutton,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

class RegisterPageWidgets extends StatefulWidget {
  const RegisterPageWidgets({
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
  State<RegisterPageWidgets> createState() => _RegisterPageWidgetsState();
}

class _RegisterPageWidgetsState extends State<RegisterPageWidgets> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _rpassword = TextEditingController();

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
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          fillColor: HexColor("#F8F8FC"),
                          filled: true,
                          //errorStyle: TextStyle(color: Colors.orange),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#91919F")),
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Ad Soyad',
                          //hintText: 'Ad Soyad',
                          labelStyle: TextStyle(color: HexColor("#91919F")),
                          prefixIcon: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.person,
                                color: HexColor("#6360FF"),
                              )),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: HexColor("#6B48FF")),
                          ),
                        ),
                        controller: _name,
                        validator: (deger) {
                          if (deger!.isEmpty) {
                            return 'Ad boş olamaz.';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                   SizedBox(
                      height: 20.h,
                    ),
                    Material(
                      elevation: 5,
                      shadowColor: HexColor('#000000'),
                      borderRadius: BorderRadius.circular(10),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          fillColor: HexColor("#F8F8FC"),
                          filled: true,
                          //errorStyle: TextStyle(color: Colors.orange),
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
                        controller: _email,
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
                      height: 20.h,
                    ),
                    Material(
                      elevation: 5,
                      shadowColor: HexColor('#000000'),
                      borderRadius: BorderRadius.circular(10),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          fillColor: HexColor("#F8F8FC"),
                          filled: true,
                          //errorStyle: TextStyle(color: Colors.orange),
                         enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#91919F")),
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Şifre',
                          //hintText: 'Şifre',

                          labelStyle: TextStyle(color: HexColor("#91919F")),
                          prefixIcon: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.lock,
                                color: HexColor("#6360FF"),
                              )),

                         focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: HexColor("#6B48FF")),
                          ),
                        ),
                        obscureText: true,
                        controller: _password,
                        validator: (deger) {
                          if (deger!.length < 6) {
                            return 'Şifre ne az 6 karakter olmalı';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Material(
                       elevation: 5,
                      shadowColor: HexColor('#000000'),
                      borderRadius: BorderRadius.circular(10),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          fillColor: HexColor("#F8F8FC"),
                          filled: true,
                          //errorStyle: TextStyle(color: Colors.orange),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#91919F")),
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Şifre Tekrarı',
                          //hintText: 'Şifre Tekrarı',
                          labelStyle: TextStyle(color: HexColor("#91919F")),
                          prefixIcon: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.lock,
                                color: HexColor("#6360FF"),
                              )),
                    
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: HexColor("#6B48FF")),
                            ),
                        ),
                        obscureText: true,
                        controller: _rpassword,
                        validator: (deger) {
                          if (deger != _password.text) {
                            return 'Şifreler Eşleşmiyor';
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
                              FocusScope.of(context).requestFocus(FocusNode());
                              _register(_name.text, _email.text,
                                  _rpassword.text, context);

                              widget._formKey.currentState!.reset();
                            }
                          },
                          child: const Text('Kayıt Ol'),
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

void _register(
    String ad, String email, String password, BuildContext buildContext) async {
  String result = '';
  Color color = Colors.white;
  try {
    UserCredential _credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? _newUser = _credential.user;
    await _newUser!.sendEmailVerification();
    if (_auth.currentUser != null) {
      String? token = await FirebaseMessaging.instance.getToken();
      Map<String, dynamic> addUser = {};
      addUser['Adı'] = ad;
      addUser['Eposta'] = _auth.currentUser!.email;
      addUser['Dil'] = "";
      addUser['Rol'] = "Student";
      addUser['Uid'] = _auth.currentUser!.uid;
      addUser['notifyToken'] = token;
      await _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set(addUser, SetOptions(merge: true))
          .then((v) => debugPrint('Eklendi'));

      result =
          'Kayıt Oluşturuldu. Giriş yapabilmek için mail adresinizi onaylayın.';
      await _auth.signOut();
    }

    ///Debugg/////////
    //debugPrint(_newUser.toString());
    ///////////////

    color = Colors.green.shade300;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      result = 'Girilen Parola Çok Zayıf.';
    } else if (e.code == 'email-already-in-use') {
      result = 'Bu e-posta adresi daha önce kayıt edilmiştir.';
    }
    color = Colors.red.shade300;
  } catch (e) {
    debugPrint('******HATA VAR*****');
    debugPrint(e.toString());
    result = 'Kayıt Oluşturulamadı. Daha Sonra Tekrar Deneyiniz.';
    color = Colors.red.shade300;
  }

  ScaffoldMessenger.of(buildContext).showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Text(
        result,
        style: const TextStyle(fontSize: 12),
      ),
    ),
  );
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dil_kumbaram/pages/resetpassword.dart';
import 'package:dil_kumbaram/pages/select_langue.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

class LoginPageWidgets extends StatefulWidget {
  const LoginPageWidgets({
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
  State<LoginPageWidgets> createState() => _LoginPageWidgetsState();
}

class _LoginPageWidgetsState extends State<LoginPageWidgets> {
  String _email = '', _password = '';

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
                
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        //errorStyle: TextStyle(color: Colors.orange),
                        fillColor: HexColor("#F8F8FC"),
                        filled: true,
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10)) ,
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
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFormField(
                      //initialValue: 'emrealtunbilek@gmail.com',
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        fillColor: HexColor("#F8F8FC"),
                        filled: true,
                        //errorStyle: TextStyle(color: Colors.orange),
                         errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10)) ,
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
                      onSaved: (deger) {
                        _password = deger!;
                      },
                      validator: (deger) {
                        if (deger!.length < 6) {
                          return 'Şifre ne az 6 karakter olmalı';
                        } else {
                          return null;
                        }
                      },
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
                              _login(_email, _password, context);

                              widget._formKey.currentState!.reset();
                            }
                          },
                          child: const Text('Giriş Yap'),
                          style: widget.loginbutton,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 250.w,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () {
                            _signInWithGoogle(context);
                          },
                          child: const AutoSizeText('Google ile Giriş Yap'),
                          style: widget.googleLogin,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RpassPage()),
                          );
                        },
                        child: Text(
                          'Şifreni mi unuttun?',
                          style: GoogleFonts.dmSans(
                              textStyle: TextStyle(
                                  color: HexColor('#91919F'),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400)),
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

void _login(String email, String password, BuildContext context) async {
  String result = '';
  Color color = Colors.black;
  try {
    if (_auth.currentUser == null) {
      User? _loginUser = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (_loginUser!.emailVerified) {
        result = 'Giriş Yapıldı.';
        color = Colors.green;
        String? token = await FirebaseMessaging.instance.getToken();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({'notifyToken': token});
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const SelectLangue(),
          ),
          (route) => false,
        );
      } else {
        result = 'Lütfen Mailinizi Onayladıktan Sonra Giriş Yapınız.';
        color = Colors.orange;
        _auth.signOut();
      }
    } else {
      debugPrint("Oturum Zaten Açılmıştır");
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      result = 'Bu mail adresine kayıtlı hesap bulunmamaktadır.';
    } else if (e.code == 'wrong-password') {
      result = 'Şifre Yanlış Veya Eksik Girilmiştir.';
    }
    color = Colors.red;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Text(
        result,
        style: const TextStyle(fontSize: 12),
      ),
    ),
  );
}

Future<UserCredential?> _signInWithGoogle(BuildContext context) async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    var result = (await _auth.signInWithCredential(credential));
    String langue = "";
    String role = "";
    await FirebaseFirestore.instance
        .collection('users')
        .where('Eposta', isEqualTo: _auth.currentUser!.email.toString())
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        langue = element['Dil'];
        role = element['Rol'];
      }
    });

    if (result.user!.email != null) {
      String? token = await FirebaseMessaging.instance.getToken();
      Map<String, dynamic> addUser = {};
      addUser['Adı'] = result.user!.displayName;
      addUser['Eposta'] = result.user!.email;
      addUser['Dil'] = langue;
      addUser['Rol'] = role.isNotEmpty ? role : 'Student';
      addUser['Uid'] = result.user!.uid;
      addUser['notifyToken'] = token;
      _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set(addUser, SetOptions(merge: true))
          .then((v) => debugPrint('Eklendi'));
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const SelectLangue(),
      ),
      (route) => false,
    );
  } catch (e) {
    debugPrint("Gmail giriş hata" + e.toString());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Gmail İle Giriş Hatalı.',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}

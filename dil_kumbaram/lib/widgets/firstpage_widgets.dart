import 'package:dil_kumbaram/pages/login.dart';
import 'package:dil_kumbaram/pages/register.dart';

import 'package:dil_kumbaram/widgets/slidewidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class FirstPageWidgets extends StatelessWidget {
  const FirstPageWidgets({
    Key? key,
    required this.registerbutton,
    required this.loginbutton,
  }) : super(key: key);

  final ButtonStyle registerbutton;
  final ButtonStyle loginbutton;

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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
             SizedBox(
              height: 150.h,
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: const [
                  SliderFirstPage(),
                
                ],
              ),
            ),
            SizedBox(height: 68.h,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 250.w,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  child:  Text('Kayıt Ol',style: TextStyle(fontSize: 20.sp),),
                  style: registerbutton,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: Text(
                    'Giriş Yap',
                    style: TextStyle(color: HexColor("#6B48FF"),fontSize: 20.sp,),
                  ),
                  style: loginbutton,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

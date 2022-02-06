import 'package:dil_kumbaram/pages/HomeMenu/home_page.dart';
import 'package:dil_kumbaram/pages/HomeMenu/lesson.dart';
import 'package:dil_kumbaram/pages/HomeMenu/profil.dart';
import 'package:dil_kumbaram/pages/HomeMenu/test_page.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectBottomIndex = 0;
  late List<Widget> allPages;
  late AnaSayfa anaSayfa;
  late TestPage testPage;
  late LessonPage lessonPage;
  late ProfilPage profilPage;

  var keyAnaSayfa = const PageStorageKey('key_ana_page');
  var keyTestPage = const PageStorageKey('key_test_page');
  var keyLessonPage = const PageStorageKey('key_Lesson_page');
  var keyProfilPage = const PageStorageKey('key_Profil_page');
  late PurchaserInfo purchaserInfo;
  @override
  void initState() {
    super.initState();
    anaSayfa =  AnaSayfa(key: keyAnaSayfa);
    testPage =  TestPage(key: keyTestPage,durum: false,);
    lessonPage =  LessonPage(key: keyLessonPage,durum: false,);
    profilPage =  ProfilPage(key: keyProfilPage,);
    allPages = [anaSayfa, testPage, lessonPage, profilPage];
  }
  
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: allPages[selectBottomIndex],
      bottomNavigationBar: bottomNavMenu(),
    );
  }

  ClipRRect bottomNavMenu() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.grey.shade200,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.border_color_rounded), label: 'Testler'),
          BottomNavigationBarItem(
              icon: Icon(Icons.date_range), label: 'Derslerim'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded), label: 'Profil'),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: selectBottomIndex,
        selectedItemColor: HexColor("#6B48FF"),
        onTap: (index) {
          setState(() {
            selectBottomIndex = index;
          });
        },
      ),
    );
  }
}

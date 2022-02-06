/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dil_kumbaram/pages/SubMenu/kaynaklar_category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
String langue = "";

class Kaynaklar extends StatefulWidget {
  const Kaynaklar({Key? key}) : super(key: key);

  @override
  _KaynaklarState createState() => _KaynaklarState();
}

class _KaynaklarState extends State<Kaynaklar> {
  @override
  void initState() {
    super.initState();
    languee();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: const [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Kaynaklar', style: TextStyle(fontSize: 24))),
                SizedBox(
                  height: 35,
                ),
                //Align(alignment: Alignment.centerLeft, child: Text('Seviye',style: TextStyle(fontSize: 18))),

                A1(),
                A2(),
                B1(),
                B2(),
                C1(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> languee() async {
  await FirebaseFirestore.instance
      .collection('users')
      .where('Eposta', isEqualTo: _auth.currentUser!.email.toString())
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var element in querySnapshot.docs) {
      langue = element['Dil'];
    }
  });
}

class A1 extends StatelessWidget {
  const A1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => KaynaklarCategory(
                    langue: langue,
                    seviye: 'A1 Seviyesi',
                  )));
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/a1.png',
              fit: BoxFit.fill,
            ),
            const Positioned(
              left: 15,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'A1 Seviyesi',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
    );
  }
}

class A2 extends StatelessWidget {
  const A2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
           Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => KaynaklarCategory(
                    langue: langue,
                    seviye: 'A2 Seviyesi',
                  )));
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/a2.png',
              fit: BoxFit.fill,
            ),
            const Positioned(
              left: 15,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'A2 Seviyesi',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
    );
  }
}

class B1 extends StatelessWidget {
  const B1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
           Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => KaynaklarCategory(
                    langue: langue,
                    seviye: 'B1 Seviyesi',
                  )));
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/b1.png',
              fit: BoxFit.fill,
            ),
            const Positioned(
              left: 15,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'B1 Seviyesi',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
    );
  }
}

class B2 extends StatelessWidget {
  const B2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
           Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => KaynaklarCategory(
                    langue: langue,
                    seviye: 'B2 Seviyesi',
                  )));
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/b2.png',
              fit: BoxFit.fill,
            ),
            const Positioned(
              left: 15,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'B2 Seviyesi',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
    );
  }
}

class C1 extends StatelessWidget {
  const C1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
           Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => KaynaklarCategory(
                    langue: langue,
                    seviye: 'C1 Seviyesi',
                  )));
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/c1.png',
              fit: BoxFit.fill,
            ),
            const Positioned(
              left: 15,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'C1 Seviyesi',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
    );
  }
}
*/
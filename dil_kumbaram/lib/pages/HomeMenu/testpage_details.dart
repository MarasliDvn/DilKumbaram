import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:dil_kumbaram/models/testler_models.dart';
import 'package:dil_kumbaram/pages/premium.dart';
import 'package:dil_kumbaram/services/Shuffle.dart';
import 'package:dil_kumbaram/services/testler_api.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestDetails extends StatefulWidget {
  final String dil, test;
  const TestDetails({Key? key, required this.dil, required this.test})
      : super(key: key);

  @override
  _TestDetailsState createState() => _TestDetailsState();
}

class _TestDetailsState extends State<TestDetails> {
  late Future<List<TestlerModel>> _testlerList;
  late int index;
  bool gecebilir2 = true;
  int _listlenght = 0;
  List<String> dogruList = [];
  List<String> yanlisList = [];
  late PurchaserInfo purchaserInfo;
  String user = '';
  AudioPlayer audioPlayer = AudioPlayer();
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  List<int> output = [];
  List<String> futureindex = [];

  Future<void> readySharedPreferences() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    index = sharedPreferences.getInt("sayac") ?? 0;
    //sharedPreferences.remove('kelime');
    //sharedPreferences.remove('kelime2');
    //sharedPreferences.remove('sayac');

    dogruList = sharedPreferences.getStringList("kelime") ?? [];
    yanlisList = sharedPreferences.getStringList("kelime2") ?? [];
    await checkindexing();

    setState(() {});
  }

  Future<void> checkindexing() async {
    List<String> clist = dogruList + yanlisList;
    List futurelist = await _testlerList;
    futureindex.clear();
    for (var i = 0; i < futurelist.length; i++) {
      futureindex.add(i.toString());
    }
    output.clear();
    for (final e in futureindex) {
      bool found = false;
      for (final f in clist) {
        if (e == f) {
          found = true;
          break;
        }
      }
      if (!found) {
        output.add(int.parse(e));
      }
    }
    if (output.isNotEmpty) {
      index = output.reduce(min);
    }
  }

  Future<void> readySharedPreferences2() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    index = sharedPreferences.getInt("sayac2") ?? 0;

    //sharedPreferences.remove('dinleme');
    //sharedPreferences.remove('dinleme2');
    //sharedPreferences.remove('sayac2');

    dogruList = sharedPreferences.getStringList("dinleme") ?? [];
    yanlisList = sharedPreferences.getStringList("dinleme2") ?? [];
    await checkindexing();
    setState(() {});
  }

  Future<void> readySharedPreferences3() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    index = sharedPreferences.getInt("sayac3") ?? 0;

    //sharedPreferences.remove('izleme');
    //sharedPreferences.remove('izleme2');
    //sharedPreferences.remove('sayac3');

    dogruList = sharedPreferences.getStringList("izleme") ?? [];
    yanlisList = sharedPreferences.getStringList("izleme2") ?? [];
    await checkindexing();
    setState(() {});
  }

  Future<void> readySharedPreferences4() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    index = sharedPreferences.getInt("sayac4") ?? 0;
    dogruList = sharedPreferences.getStringList("c??mle") ?? [];
    yanlisList = sharedPreferences.getStringList("c??mle2") ?? [];
    await checkindexing();
    setState(() {});
  }

  Future<void> saveData(int deger) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    index = deger;

    if (widget.test == 'Kelime Testi') {
      sharedPreferences.setInt("sayac", index);
    } else if (widget.test == 'Dinleme Testi') {
      sharedPreferences.setInt("sayac2", index);
    } else if (widget.test == '??zleme Testi') {
      sharedPreferences.setInt("sayac3", index);
    } else if (widget.test == 'C??mle Testi') {
      sharedPreferences.setInt("sayac4", index);
    }
  }

  Future<void> saveData2(int deger) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    index = deger;
    if (widget.test == 'Kelime Testi') {
      sharedPreferences.setInt("sayac", index);
    } else if (widget.test == 'Dinleme Testi') {
      sharedPreferences.setInt("sayac2", index);
    } else if (widget.test == '??zleme Testi') {
      sharedPreferences.setInt("sayac3", index);
    } else if (widget.test == 'C??mle Testi') {
      sharedPreferences.setInt("sayac4", index);
    }
  }

  Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(false);
    await Purchases.setup("goog_REMQBgsymZREiZDwUgZVMLFqYFn");
    purchaserInfo = await Purchases.getPurchaserInfo();
  }

  Future<String> userIsPremium() async {
    purchaserInfo = await Purchases.getPurchaserInfo();
    if (purchaserInfo.entitlements.all["Premium"] != null &&
        purchaserInfo.entitlements.all["Premium"]!.isActive) {
      return 'Abone';
    } else {
      return 'Standart';
    }
  }

  Future<String> userIsPremium2() async {
    purchaserInfo = await Purchases.getPurchaserInfo();
    if (purchaserInfo.entitlements.all["Premium"] != null &&
        purchaserInfo.entitlements.all["Premium"]!.isActive) {
      return user = 'Abone';
    } else {
      return user = 'Standart';
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    userIsPremium2();
    if (widget.test == 'Kelime Testi') {
      _testlerList = TestlerApi.getKelimeTesti(widget.dil);

      readySharedPreferences();
    } else if (widget.test == 'Dinleme Testi') {
      _testlerList = TestlerApi.getDinlemeTesti(widget.dil);
      readySharedPreferences2();
    } else if (widget.test == '??zleme Testi') {
      _testlerList = TestlerApi.getIzlemeTesti(widget.dil);
      readySharedPreferences3();
    } else if (widget.test == 'C??mle Testi') {
      _testlerList = TestlerApi.getCumleTesti(widget.dil);
      readySharedPreferences4();
    }
  }

  @override
  void dispose() {
    if (widget.test == '??zleme Testi') {
      videoPlayerController.dispose();
      chewieController.dispose();
    }
    if (widget.test == 'Dinleme Testi') {
      audioPlayer.release();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    final ButtonStyle cevap = ElevatedButton.styleFrom(
      textStyle: TextStyle(fontSize: 24.sp, color: Colors.black),
      primary: HexColor('#6B48FF'),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
    );
    final ButtonStyle cevap1 = ElevatedButton.styleFrom(
      textStyle: TextStyle(fontSize: 24.sp, color: Colors.black),
      primary: HexColor("#00FF75"),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
    );
    final ButtonStyle cevap2 = ElevatedButton.styleFrom(
      textStyle: TextStyle(fontSize: 24.sp, color: Colors.black),
      primary: HexColor("#FFA7A7"),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
    );

    debugPrint("Do??ru List:   " + dogruList.toString());
    debugPrint("Yanl???? List:  " + yanlisList.toString());
    return Scaffold(
      backgroundColor: HexColor("#f4f4f4"),
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(widget.test,
                        style: TextStyle(
                            fontSize: 32.sp, fontWeight: FontWeight.bold))),
                SizedBox(
                  height: 20.h,
                ),
                veriler(cevap1, cevap2, cevap, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<TestlerModel>> veriler(ButtonStyle cevap1,
      ButtonStyle cevap2, ButtonStyle cevap, BuildContext context) {
    return FutureBuilder<List<TestlerModel>>(
      future: _testlerList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return AlertDialog(
              content: const Text("En k??sa zamanda yeni sorular eklenecektir."),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: HexColor('#6B48FF')),
                  child: const Text("Tamam"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          } else {
            List<dynamic> cevaplar;
            List<TestlerModel> _listTestler = snapshot.data!;
            //debugPrint(index.toString());
            String _url = 'https://kumbaram.dilkumbaram.com/' +
                _listTestler[index].glink.toString();
            String dogru = _listTestler[index].dogru.toString();
            String yanlis1 = _listTestler[index].yanlis1.toString();
            String yanlis2 = _listTestler[index].yanlis2.toString();

            cevaplar =
                Listshufle.shufflelist(dogru, yanlis1, yanlis2, cevap1, cevap2);

            if (widget.test == '??zleme Testi') {
              videoPlayerController = VideoPlayerController.network(_url);
              videoPlayerController.initialize();
              chewieController = ChewieController(
                  videoPlayerController: videoPlayerController,
                  autoPlay: false,
                  looping: false,
                  allowFullScreen: false);
            }

            debugPrint(user);
            int sinir;
            widget.test == 'Kelime Testi' ? sinir = 15 : sinir = 2;
            user == 'Standart'
                ? _listlenght = sinir
                : _listlenght = _listTestler.length;
            return _listlenght != (dogruList + yanlisList).toSet().length
                ? testdetails(
                    context, _url, cevap, cevaplar, dogru, _listTestler)
                : user == 'Standart'
                    ? AlertDialog(
                        content:
                            const Text("T??m uygulamaya s??n??rs??z eri??im i??in premium'a ge??iniz."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PremiumPage())).then((value) {
                                setState(() {
                                  // refresh state
                                });
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                primary: HexColor('#6B48FF')),
                            child: const Text('Bilgi al',
                                style: TextStyle(color: Colors.white)),
                          )
                        ],
                      )
                    : AlertDialog(
                        content: const Text(
                            'Yeni sorular en k??sa zamanda eklenecek.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Tamam.'),
                          )
                        ],
                      );
          }
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Veri Gelmedi'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Column testdetails(BuildContext context, String _url, ButtonStyle cevap,
      List<dynamic> cevaplar, String dogru, List<TestlerModel> _listTestler) {
    return Column(
      children: [
        SizedBox(
            height: 250.h,
            width: 350.w,
            child: (widget.test == 'Kelime Testi' ||
                    widget.test == 'C??mle Testi')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.8,
                      alignment: Alignment.center,
                      placeholder: 'assets/images/loading.gif',
                      image: _url,
                    ),
                  )
                : widget.test == 'Dinleme Testi'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              audioPlayer.play(_url);
                            },
                            child: const Icon(Icons.play_arrow,
                                color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                              primary: Colors.blue, // <-- Button color
                              onPrimary: Colors.red, // <-- Splash color
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              audioPlayer.pause();
                            },
                            child: const Icon(Icons.pause_outlined,
                                color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                              primary: Colors.blue, // <-- Button color
                              onPrimary: Colors.red, // <-- Splash color
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              audioPlayer.stop();
                            },
                            child: const Icon(Icons.stop, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                              primary: Colors.blue, // <-- Button color
                              onPrimary: Colors.red, // <-- Splash color
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: videoPlayerController.value.size.height,
                        width: videoPlayerController.value.size.width,
                        child: Chewie(
                          controller: chewieController,
                        ),
                      )),
        SizedBox(
          height: 15.h,
        ),
        SizedBox(
          width: double.infinity,
          height: 75.h,
          child: ElevatedButton(
              style: cevap,
              onPressed: () {
                //_dogru = !_dogru;
                //_yanlis1 = !_yanlis1;
                //_yanlis2 = !_yanlis2;
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    backgroundColor:
                        (cevaplar[0][0] == dogru) ? Colors.green : Colors.red,
                    title: (cevaplar[0][0] == dogru)
                        ? const Text('Tebrikler Do??ru Bildiniz',
                            style: TextStyle(
                              color: Colors.white,
                            ))
                        : const Text('??zg??n??m Yanl???? Bildiniz',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                    content: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 95.0,
                      ),
                      child: Column(
                        children: [
                          (cevaplar[0][0] == dogru)
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.white,
                                  size: 48,
                                )
                              : const FaIcon(
                                  FontAwesomeIcons.solidTimesCircle,
                                  color: Colors.white,
                                  size: 48,
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          Flexible(
                            child: Text(
                              'Do??ru Cevap : ' + dogru,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          if (cevaplar[0][0] == dogru) {
                            await truelist();
                          } else {
                            await falselist();
                          }
                          Navigator.pop(context, 'S??rada ki soru');

                          nextrecursive(index);
                        },
                        child: (index != _listTestler.length - 1)
                            ? const Text('S??rada ki soru',
                                style: TextStyle(
                                  color: Colors.white,
                                ))
                            : const Text('Bitti',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                      ),
                    ],
                  ),
                );
              },
              child: Text(cevaplar[0][0])),
        ),
        ///////////
        SizedBox(
          height: 15.h,
        ),
        ///////////
        SizedBox(
          height: 75.h,
          width: double.infinity,
          child: ElevatedButton(
              style: cevap,
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    backgroundColor:
                        (cevaplar[1][0] == dogru) ? Colors.green : Colors.red,
                    title: (cevaplar[1][0] == dogru)
                        ? const Text('Tebrikler Do??ru Bildiniz',
                            style: TextStyle(
                              color: Colors.white,
                            ))
                        : const Text('??zg??n??m Yanl???? Bildiniz',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                    content: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 95.0,
                      ),
                      child: Column(
                        children: [
                          (cevaplar[1][0] == dogru)
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.white,
                                  size: 48,
                                )
                              : const FaIcon(
                                  FontAwesomeIcons.solidTimesCircle,
                                  color: Colors.white,
                                  size: 48,
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          Flexible(
                            child: Text(
                              'Do??ru Cevap : ' + dogru,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          if (cevaplar[1][0] == dogru) {
                            await truelist();
                          } else {
                            await falselist();
                          }
                          Navigator.pop(context, 'S??rada ki soru');

                          nextrecursive(index);
                          //debugPrint((_listTestler.length-2).toString());
                        },
                        child: (index != _listTestler.length - 1)
                            ? const Text('S??rada ki soru',
                                style: TextStyle(
                                  color: Colors.white,
                                ))
                            : const Text('Bitti',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                      ),
                    ],
                  ),
                );
              },
              child: Text(cevaplar[1][0])),
        ),
        ///////////
        SizedBox(
          height: 15.h,
        ),
        ///////////
        SizedBox(
          height: 75.h,
          width: double.infinity,
          child: ElevatedButton(
              style: cevap,
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    backgroundColor:
                        (cevaplar[2][0] == dogru) ? Colors.green : Colors.red,
                    title: (cevaplar[2][0] == dogru)
                        ? const Text('Tebrikler Do??ru Bildiniz',
                            style: TextStyle(
                              color: Colors.white,
                            ))
                        : const Text('??zg??n??m Yanl???? Bildiniz',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                    content: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 95.0,
                      ),
                      child: Column(
                        children: [
                          (cevaplar[2][0] == dogru)
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.white,
                                  size: 48,
                                )
                              : const FaIcon(
                                  FontAwesomeIcons.solidTimesCircle,
                                  color: Colors.white,
                                  size: 48,
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          Flexible(
                            child: Text(
                              'Do??ru Cevap : ' + dogru,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          if (cevaplar[2][0] == dogru) {
                            await truelist();
                          } else {
                            await falselist();
                          }
                          Navigator.pop(context, 'S??rada ki soru');

                          nextrecursive(index);
                        },
                        child: (index != _listTestler.length - 1)
                            ? const Text('S??rada ki soru',
                                style: TextStyle(
                                  color: Colors.white,
                                ))
                            : const Text('Bitti',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                      ),
                    ],
                  ),
                );
              },
              child: Text(cevaplar[2][0])),
        ),
        ///////////
        SizedBox(
          height: 25.h,
        ),

        ///////////
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                child: const Icon(Icons.arrow_back, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                  primary: Colors.blue, // <-- Button color
                  onPrimary: Colors.red, // <-- Splash color
                ),
                onPressed: () {
                  //debugPrint((_listTestler.length-1).toString());

                  if (index != 0) {
                    if (index <= (_listTestler.length - 1)) {
                      backrecursive(index);

                      //debugPrint((index).toString());
                    } else {
                      index = 0;
                    }
                  }
                },
              ),
              ElevatedButton(
                child: const Icon(Icons.arrow_forward, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                  primary: Colors.blue, // <-- Button color
                  onPrimary: Colors.red, // <-- Splash color
                ),
                onPressed: () async {
                  if (index == _listTestler.length - 1) {
                    await checkindexing();
                    setState(() {
                      
                    });
                  } else {
                    nextrecursive(index);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> falselist() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    yanlisList.add(index.toString());
    if (widget.test == 'Kelime Testi') {
      sharedPreferences.setStringList("kelime2", yanlisList);
    } else if (widget.test == 'Dinleme Testi') {
      sharedPreferences.setStringList("dinleme2", yanlisList);
    } else if (widget.test == '??zleme Testi') {
      sharedPreferences.setStringList("izleme2", yanlisList);
    } else if (widget.test == 'C??mle Testi') {
      sharedPreferences.setStringList("c??mle2", yanlisList);
    }
  }

  Future<void> truelist() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    dogruList.add(index.toString());
    if (widget.test == 'Kelime Testi') {
      sharedPreferences.setStringList("kelime", dogruList);
    } else if (widget.test == 'Dinleme Testi') {
      sharedPreferences.setStringList("dinleme", dogruList);
    } else if (widget.test == '??zleme Testi') {
      sharedPreferences.setStringList("izleme", dogruList);
    } else if (widget.test == 'C??mle Testi') {
      sharedPreferences.setStringList("c??mle", dogruList);
    }
  }

  void backrecursive(int degercik) {
    bool gecebilir = true;
    var clist = dogruList + yanlisList;
    for (final list in clist) {
      if ((degercik - 1).toString() == list || degercik == 0) {
        gecebilir = false;
        break;
      } else {
        gecebilir = true;
      }
    }
    if (gecebilir) {
      saveData2(degercik - 1);
      setState(() {
        if (widget.test == 'Dinleme Testi') {
          audioPlayer.stop();
        }
        if (widget.test == '??zleme Testi') {
          videoPlayerController.dispose();
          chewieController.dispose();
          chewieController.pause();
        }
      });
    } else {
      if (degercik > 0 || degercik != 0) {
        backrecursive(degercik - 1);
      }
    }
  }

  Future<void> nextrecursive(int degercik) async {
    String tur = "";
    int sinir;
    widget.test == 'Kelime Testi' ? sinir = 14 : sinir = 1;
    userIsPremium().then((String result) {
      if (result == 'Standart') {
        tur = 'Standart';
      } else {
        tur = 'Abone';
      }
    });
    bool gecebilir = true;
    var clist = dogruList + yanlisList;
    for (final list in clist) {
      if ((degercik + 1).toString() == list || degercik == _listlenght - 1) {
        gecebilir = false;
        break;
      } else {
        gecebilir = true;
      }
    }
    if (gecebilir && (degercik < sinir || user == 'Abone')) {
      saveData(degercik + 1);
      setState(() {
        if (widget.test == 'Dinleme Testi') {
          audioPlayer.stop();
        }
        if (widget.test == '??zleme Testi') {
          videoPlayerController.dispose();
          chewieController.dispose();
          chewieController.pause();
        }
      });
    } else if ((degercik < sinir || user == 'Abone')) {
      if (degercik < _listlenght - 1) {
        nextrecursive(degercik + 1);
      } else {
        await checkindexing();

        setState(() {});
      }
    } else {
      Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PremiumPage()))
          .then((value) {
        setState(() {
          // refresh state
        });
      });
    }
  }
}

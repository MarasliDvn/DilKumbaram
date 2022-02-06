import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:dil_kumbaram/models/testler_models.dart';
import 'package:dil_kumbaram/services/Shuffle.dart';
import 'package:dil_kumbaram/services/testler_api.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
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

  AudioPlayer audioPlayer = AudioPlayer();
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  Future<void> readySharedPreferences() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    index = sharedPreferences.getInt("sayac") ?? 0;
    setState(() {});
  }

  Future<void> readySharedPreferences2() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    index = sharedPreferences.getInt("sayac2") ?? 0;
    setState(() {});
  }

  Future<void> readySharedPreferences3() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    index = sharedPreferences.getInt("sayac3") ?? 0;
    setState(() {});
  }

  Future<void> readySharedPreferences4() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    index = sharedPreferences.getInt("sayac4") ?? 0;
    setState(() {});
  }

  Future<void> saveData() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    index += 1;

    if (widget.test == 'Kelime Testi') {
      sharedPreferences.setInt("sayac", index);
    } else if (widget.test == 'Dinleme Testi') {
      sharedPreferences.setInt("sayac2", index);
    } else if (widget.test == 'İzleme Testi') {
      sharedPreferences.setInt("sayac3", index);
    } else if (widget.test == 'Cümle Testi') {
      sharedPreferences.setInt("sayac4", index);
    }
  }

  Future<void> saveData2() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    index -= 1;
    if (widget.test == 'Kelime Testi') {
      sharedPreferences.setInt("sayac", index);
    } else if (widget.test == 'Dinleme Testi') {
      sharedPreferences.setInt("sayac2", index);
    } else if (widget.test == 'İzleme Testi') {
      sharedPreferences.setInt("sayac3", index);
    } else if (widget.test == 'Cümle Testi') {
      sharedPreferences.setInt("sayac4", index);
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.test == 'Kelime Testi') {
      _testlerList = TestlerApi.getKelimeTesti(widget.dil);
      readySharedPreferences();
    } else if (widget.test == 'Dinleme Testi') {
      _testlerList = TestlerApi.getDinlemeTesti(widget.dil);
      readySharedPreferences2();
    } else if (widget.test == 'İzleme Testi') {
      _testlerList = TestlerApi.getIzlemeTesti(widget.dil);
      readySharedPreferences3();
    } else if (widget.test == 'Cümle Testi') {
      _testlerList = TestlerApi.getCumleTesti(widget.dil);
      readySharedPreferences4();
    }
  }

  @override
  void dispose() {
    if (widget.test == 'İzleme Testi') {
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

    return Scaffold(
      backgroundColor: HexColor("#E5E5E5"),
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
      body: SizedBox(
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
                veriler(cevap1, cevap2, cevap),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<TestlerModel>> veriler(
      ButtonStyle cevap1, ButtonStyle cevap2, ButtonStyle cevap) {
    return FutureBuilder<List<TestlerModel>>(
      future: _testlerList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> cevaplar;
          List<TestlerModel> _listTestler = snapshot.data!;

          String _url = 'https://kumbaram.dilkumbaram.com/' +
              _listTestler[index].glink.toString();
          String dogru = _listTestler[index].dogru.toString();
          String yanlis1 = _listTestler[index].yanlis1.toString();
          String yanlis2 = _listTestler[index].yanlis2.toString();

          cevaplar =
              Listshufle.shufflelist(dogru, yanlis1, yanlis2, cevap1, cevap2);

          if (widget.test == 'İzleme Testi') {
            videoPlayerController = VideoPlayerController.network(_url);
            videoPlayerController.initialize();
            chewieController = ChewieController(
                videoPlayerController: videoPlayerController,
                autoPlay: false,
                looping: false,
                allowFullScreen: false);
          }

          return Column(
            children: [
              SizedBox(
                  height: 250.h,
                  width: 350.w,
                  child: (widget.test == 'Kelime Testi' ||
                          widget.test == 'Cümle Testi')
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
                                  child: const Icon(Icons.stop,
                                      color: Colors.white),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          backgroundColor: (cevaplar[0][0] == dogru)
                              ? Colors.green
                              : Colors.red,
                          title: (cevaplar[0][0] == dogru)
                              ? const Text('Tebrikler Doğru Bildiniz',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ))
                              : const Text('Üzgünüm Yanlış Bildiniz',
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
                                    'Doğru Cevap : ' + dogru,
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
                              onPressed: () {
                                Navigator.pop(context, 'Sırada ki soru');
                                if (index != (_listTestler.length - 1)) {
                                  if (index <= (_listTestler.length - 1)) {
                                    saveData();
                                    //debugPrint((_listTestler.length-2).toString());
                                    debugPrint((index).toString());
                                  } else {
                                    index = index;
                                  }
                                  setState(() {
                                    if (widget.test == 'Dinleme Testi') {
                                      audioPlayer.stop();
                                    }
                                    if (widget.test == 'İzleme Testi') {
                                      videoPlayerController.dispose();
                                      chewieController.dispose();
                                      chewieController.pause();
                                    }
                                  });
                                }
                              },
                              child: (index != _listTestler.length - 1)
                                  ? const Text('Sırada ki soru',
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          backgroundColor: (cevaplar[1][0] == dogru)
                              ? Colors.green
                              : Colors.red,
                          title: (cevaplar[1][0] == dogru)
                              ? const Text('Tebrikler Doğru Bildiniz',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ))
                              : const Text('Üzgünüm Yanlış Bildiniz',
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
                                    'Doğru Cevap : ' + dogru,
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
                              onPressed: () {
                                Navigator.pop(context, 'Sırada ki soru');
                                if (index != (_listTestler.length - 1)) {
                                  if (index <= (_listTestler.length - 1)) {
                                    saveData();
                                    //debugPrint((_listTestler.length-2).toString());
                                    debugPrint((index).toString());
                                  } else {
                                    index = index;
                                  }
                                  setState(() {
                                    if (widget.test == 'Dinleme Testi') {
                                      audioPlayer.stop();
                                    }
                                    if (widget.test == 'İzleme Testi') {
                                      videoPlayerController.dispose();
                                      chewieController.dispose();
                                      chewieController.pause();
                                    }
                                  });
                                }
                              },
                              child: (index != _listTestler.length - 1)
                                  ? const Text('Sırada ki soru',
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          backgroundColor: (cevaplar[2][0] == dogru)
                              ? Colors.green
                              : Colors.red,
                          title: (cevaplar[2][0] == dogru)
                              ? const Text('Tebrikler Doğru Bildiniz',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ))
                              : const Text('Üzgünüm Yanlış Bildiniz',
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
                                    'Doğru Cevap : ' + dogru,
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
                              onPressed: () {
                                Navigator.pop(context, 'Sırada ki soru');
                                if (index != (_listTestler.length - 1)) {
                                  if (index <= (_listTestler.length - 1)) {
                                    saveData();
                                    //debugPrint((_listTestler.length-2).toString());
                                    debugPrint((index).toString());
                                  } else {
                                    index = index;
                                  }
                                  setState(() {
                                    if (widget.test == 'Dinleme Testi') {
                                      audioPlayer.stop();
                                    }
                                    if (widget.test == 'İzleme Testi') {
                                      videoPlayerController.dispose();
                                      chewieController.dispose();
                                      chewieController.pause();
                                    }
                                  });
                                }
                              },
                              child: (index != _listTestler.length - 1)
                                  ? const Text('Sırada ki soru',
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
                            saveData2();
                            debugPrint((index).toString());
                          } else {
                            index = 0;
                          }
                          setState(() {
                            if (widget.test == 'Dinleme Testi') {
                              audioPlayer.stop();
                            }
                            if (widget.test == 'İzleme Testi') {
                              videoPlayerController.dispose();
                              chewieController.dispose();
                              chewieController.pause();
                            }
                          });
                        }
                      },
                    ),
                    ElevatedButton(
                      child:
                          const Icon(Icons.arrow_forward, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        primary: Colors.blue, // <-- Button color
                        onPrimary: Colors.red, // <-- Splash color
                      ),
                      onPressed: () {
                        if (index != (_listTestler.length - 1)) {
                          if (index <= (_listTestler.length - 1)) {
                            saveData();
                            //debugPrint((_listTestler.length-2).toString());

                          } else {
                            index = index;
                          }
                          debugPrint((index).toString());
                          setState(() {
                            if (widget.test == 'Dinleme Testi') {
                              audioPlayer.stop();
                            }
                            if (widget.test == 'İzleme Testi') {
                              videoPlayerController.dispose();
                              chewieController.dispose();
                              chewieController.pause();
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
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
}

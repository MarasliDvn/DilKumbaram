import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dil_kumbaram/models/kg_models.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:math' as math;

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

int deger = 0;
int result = 0;
ScrollController controller = ScrollController();
AudioPlayer audioPlayer = AudioPlayer();

class KgDetails extends StatefulWidget {
  final Future<List<KgModel>> kgList;
  const KgDetails({Key? key, required this.kgList}) : super(key: key);

  @override
  _KgDetailsState createState() => _KgDetailsState();
}

class _KgDetailsState extends State<KgDetails> {
  @override
  void initState() {
    super.initState();
    debugPrint(result.toString());
  }

  @override
  void dispose() {
    super.dispose();
    deger = 0;
    if (result == 1) {
      result = 0;
      audioPlayer.release();
      debugPrint('girdi');
    }
  }

  play(String url) async {
    int play = await audioPlayer.play(url);
    if (play == 1) {
      result = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
       leading:  IconButton(
        icon:  Icon(Icons.arrow_back_ios_new,color: HexColor("#5D5FEF"),),
        onPressed: () => {
         Navigator.pop(context),
        },
      ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: items(width)),
    );
  }

  FutureBuilder<List<KgModel>> items(double width) {
    final ItemScrollController itemScrollController = ItemScrollController();
    final ItemPositionsListener itemPositionsListener =
        ItemPositionsListener.create();
    return FutureBuilder<List<KgModel>>(
        future: widget.kgList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<KgModel> _kgList = snapshot.data!;
            return ScrollablePositionedList.builder(
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                physics:
                    const NeverScrollableScrollPhysics(), // this is what you are looking for
                scrollDirection: Axis.horizontal,
                itemCount: _kgList.length,
                itemBuilder: (context, index) {
                  var item = _kgList[index];
                  int count = _kgList.length - 1;
                  var yanlami = item.yanlami.toString();
                  var tanlami = item.tanlami.toString();
                  String url = 'https://kumbaram.dilkumbaram.com' +
                      item.slink.toString();

                  return Container(
                    color: HexColor('#FFFFFF'),
                    width: width,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: FlipCard(
                              fill: Fill
                                  .fillBack, // Fill the back side of the card to make in the same size as the front.
                              direction: FlipDirection.HORIZONTAL, // default
                              front: flipcard(yanlami),
                              back: flipcard(tanlami),
                            ),
                          ),
                           SizedBox(
                            height: 150.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  //audioPlayer.play(url);

                                  debugPrint(deger.toString() +
                                      '  ' +
                                      count.toString());
                                  if (deger != 0) {
                                    audioPlayer.release();
                                    deger--;
                                    itemScrollController.jumpTo(index: deger);
                                  }
                                },
                                child: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  primary:
                                      HexColor('#6B48FF'), // <-- Button color
                                  onPrimary: Colors.red, // <-- Splash color
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  play(url);
                                },
                                child: const Icon(Icons.play_arrow,
                                    color: Colors.white),
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  primary:
                                      HexColor('#6B48FF'), // <-- Button color
                                  onPrimary: Colors.red, // <-- Splash color
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  //audioPlayer.play(url);

                                  debugPrint(deger.toString() +
                                      "    " +
                                      count.toString());
                                  if (deger != count) {
                                    audioPlayer.release();
                                    deger++;
                                    itemScrollController.jumpTo(index: deger);
                                  }
                                },
                                child: const Icon(Icons.arrow_forward,
                                    color: Colors.white),
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  primary:
                                      HexColor('#6B48FF'), // <-- Button color
                                  onPrimary: Colors.red, // <-- Splash color
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
                  );
                });
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Veri Gelmedi'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Stack flipcard(String yanlami) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: math.pi / 60,
          child: Container(
            decoration: BoxDecoration(
                color: HexColor("#E7E0E0"),
                border: Border.all(color: HexColor("#E7E0E0")),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            width: double.infinity,
            height: 250.h,
          ),
        ),
        Transform.rotate(
          angle: -math.pi / 60,
          child: Container(
            decoration: BoxDecoration(
                color: HexColor("#F3EFEF"),
                border: Border.all(color: HexColor("#F3EFEF")),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            width: double.infinity,
            height: 250.h,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AutoSizeText(
            yanlami,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36.sp,
                color: HexColor('#676666')),
            maxLines: 4,
          ),
        ),
        Positioned(
            bottom: 15,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Çevir',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12.sp,
                      color: HexColor('#676666')),
                )))
      ],
    );
  }
}

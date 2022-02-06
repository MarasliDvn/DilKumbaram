import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dil_kumbaram/models/kg_models.dart';
import 'package:dil_kumbaram/pages/SubMenu/kg_details.dart';
import 'package:dil_kumbaram/services/kg_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

AudioPlayer audioPlayer = AudioPlayer();
late bool play = false;
final ButtonStyle cevap = ElevatedButton.styleFrom(
  textStyle:  TextStyle(fontSize: 24.sp, color: Colors.black),
  primary: HexColor('#6B48FF'),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
final ButtonStyle cevap2 = ElevatedButton.styleFrom(
  textStyle:  TextStyle(fontSize: 24.sp, color: Colors.black),
  primary: HexColor('#34A400'),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
final ButtonStyle cevap3 = ElevatedButton.styleFrom(
  textStyle:  TextStyle(fontSize: 24.sp, color: Colors.black),
  primary: HexColor('#D0F0C1'),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

class KgCategory extends StatefulWidget {
  final String category, url;
  final String dil;
  const KgCategory(
      {Key? key, required this.category, required this.dil, required this.url})
      : super(key: key);

  @override
  _KgCategoryState createState() => _KgCategoryState();
}

class _KgCategoryState extends State<KgCategory> {
  late Future<List<KgModel>> _kgList;
  dynamic durum;

  Future<void> readySharedPreferences() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    durum = sharedPreferences.getInt(widget.dil+widget.category) ?? 0;
    setState(() {});
  }

  Future<void> saveData() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    durum = 1;

    sharedPreferences.setInt(widget.dil+widget.category, durum);
  }

  Future<void> saveData2() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    durum = 0;

    sharedPreferences.setInt(widget.dil+widget.category, durum);
  }

  @override
  void initState() {
    super.initState();
    readySharedPreferences();
    if (widget.dil == 'İngilizce') {
      _kgList = KgApi.getKgisti3(widget.category);
    }
    if (widget.dil == 'Almanca') {
      _kgList = KgApi.getKgasti3(widget.category);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.category,
                      style:  TextStyle(fontSize: 24.sp))),
               SizedBox(
                height: 35.sp,
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () {
                          saveData2();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KgDetails(
                                        kgList: _kgList,
                                      ))).then((value) {
                            setState(() {
                              // refresh state
                            });
                          });
                        },
                        child: const AutoSizeText('Başlat'),
                        style: cevap,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () {
                          if (durum == 0) {
                            saveData();
                            Navigator.pop(context);
                          }
                        },
                        child: const AutoSizeText('Bitir'),
                        style: durum == 0 ? cevap2 : cevap3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              Expanded(
                child: FutureBuilder<List<KgModel>>(
                    future: _kgList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<KgModel> _kgList = snapshot.data!;
                        return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: _kgList.length,
                            itemBuilder: (context, index) {
                              var item = _kgList[index];
                              return InkWell(
                                onTap: () {},
                                child: Card(
                                  elevation: 6,
                                  margin: const EdgeInsets.all(3),
                                  child: ListTile(
                                    leading: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.network(
                                          widget.url,
                                          width: 24.w,
                                          height: 24.h,
                                        ),
                                      ],
                                    ),
                                    title: AutoSizeText(
                                      item.yanlami.toString(),
                                      maxLines: 3,
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                    subtitle: AutoSizeText(
                                      item.tanlami.toString(),
                                      maxLines: 3,
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  ),
                                ),
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
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

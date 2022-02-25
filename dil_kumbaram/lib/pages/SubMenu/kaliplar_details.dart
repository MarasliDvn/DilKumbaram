import 'package:dil_kumbaram/models/kaliplar_models.dart';
import 'package:dil_kumbaram/services/kaliplar_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class KaliplarDetails extends StatefulWidget {
  final String langue;
  final String kategori;
  const KaliplarDetails(
      {Key? key, required this.langue, required this.kategori})
      : super(key: key);

  @override
  _KaliplarDetailsState createState() => _KaliplarDetailsState();
}

class _KaliplarDetailsState extends State<KaliplarDetails> {
  late Future<List<KaliplarModel>> _kaliplarList;
  @override
  void initState() {
    super.initState();
    if (widget.langue == 'İngilizce') {
      _kaliplarList = KaliplarApi.getKalipIngData(widget.kategori);
    } else if (widget.langue == 'Almanca') {
      _kaliplarList = KaliplarApi.getKalipAlmnData(widget.kategori);
    }
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
        backgroundColor:HexColor('#f4f4f4'),
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
          child: Column(
            children: [
             Align(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.kategori,
                      style: TextStyle(
                          fontSize: 32.sp, fontWeight: FontWeight.bold))),
               SizedBox(
                height: 35.h,
              ),
              //Align(alignment: Alignment.centerLeft, child: Text('Seviye',style: TextStyle(fontSize: 18))),
              FutureBuilder<List<KaliplarModel>>(
                  future: _kaliplarList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<KaliplarModel> _listKalip = snapshot.data!;
                      return Expanded(
                        child: SizedBox(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: _listKalip.length,
                              itemBuilder: (context, index) {
                                var yanlami = _listKalip[index].yanlami;
                                var tanlami = _listKalip[index].tanlami;
                      
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  elevation: 3,
                                  color: Colors.grey.shade100,
                                  shadowColor: Colors.grey,
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                           SizedBox(
                                            height: 10.h,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(bottom: 13),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                yanlami.toString(),
                                                style:  TextStyle(
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                           SizedBox(
                                            height: 10.h,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              tanlami.toString(),
                                              style:  TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Colors.black),
                                            ),
                                          ), SizedBox(
                                            height: 10.h,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
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
                  })
            ],
          ),
        ),
      ),
    );
  }
}

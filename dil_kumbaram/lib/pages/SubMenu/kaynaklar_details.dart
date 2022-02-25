import 'package:dil_kumbaram/models/kaynaklar_models.dart';
import 'package:dil_kumbaram/services/kaynaklar_api.dart';
import 'package:dil_kumbaram/widgets/pdf_read.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class KaynaklarDetails extends StatefulWidget {
  final String langue;
  final String kategori;
  const KaynaklarDetails(
      {Key? key, required this.langue, required this.kategori})
      : super(key: key);

  @override
  _KaynaklarDetailsState createState() => _KaynaklarDetailsState();
}

class _KaynaklarDetailsState extends State<KaynaklarDetails> {
  late Future<List<KaynaklarModel>> _kaynaklarList;
  @override
  void initState() {
    super.initState();

    _kaynaklarList =
        KaynaklarApi.getKaynakDetailsData(widget.kategori, widget.langue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: HexColor('#f4f4f4'),
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
              FutureBuilder<List<KaynaklarModel>>(
                  future: _kaynaklarList,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<KaynaklarModel> _kaynaklarList = snapshot.data!;
                      String url = 'https://kumbaram.dilkumbaram.com' +
                          _kaynaklarList[0].pdf.toString();
                      return Expanded(child: PdfOku(url: url));
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

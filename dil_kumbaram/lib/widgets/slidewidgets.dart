import 'package:carousel_slider/carousel_slider.dart';
import 'package:dil_kumbaram/contants/contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SliderFirstPage extends StatefulWidget {
  const SliderFirstPage({Key? key}) : super(key: key);

  @override
  _SliderFirstPageState createState() => _SliderFirstPageState();
}

class _SliderFirstPageState extends State<SliderFirstPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
            options: CarouselOptions(
              height: 300.h,
              viewportFraction: 1,
              autoPlay: true,
            ),
            items: [
              'assets/images/slide1.png',
              'assets/images/slide2.png',
              'assets/images/slide3.png'
            ].map((i) {
              return Builder(builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    children: [
                      Image.asset(
                        i,
                        fit: BoxFit.cover,
                        height: 200.h,
                        width: 200.w,
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      if (i == 'assets/images/slide1.png')
                        const Slidertitle(
                          title: 'Testleri Çöz',
                          subtitle: 'Kart desteleriyle hızlıca öğren.',
                        ),
                      if (i == 'assets/images/slide2.png')
                        const Slidertitle(
                          title: 'Online Ders Al',
                          subtitle: 'Özgürce speaking yap, kendini geliştir.',
                        ),
                      if (i == 'assets/images/slide3.png')
                        const Slidertitle(
                          title: 'Öğrenmek istediğin dili seç',
                          subtitle: 'Eğlenerek öğrenmenin tadını çıkar.',
                        ),
                    ],
                  ),
                );
              });
            }).toList()),
        Image.asset(
          'assets/images/icons/swipe.png',
          width: 64.w,
          height: 64.h,
        )
      ],
    );
  }
}

class Slidertitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const Slidertitle({Key? key, required this.title, required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Constants.getTitleStyle(),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          subtitle,
          style: Constants.getSubTitleStyle(),
        ),
      ],
    );
  }
}

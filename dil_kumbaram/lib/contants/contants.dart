import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Constants {
  Constants._();

  static TextStyle getTitleStyle() {
    return  TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24.sp);
  }

  static TextStyle getSubTitleStyle() {
    return  TextStyle(
        color: Colors.black, fontWeight: FontWeight.normal, fontSize: 14.sp);
  }

  
}

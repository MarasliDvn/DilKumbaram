import 'package:dil_kumbaram/models/kaliplar_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class KaliplarApi {
  static const String _url2 =
      'https://dilkumbaram.com/admin/api/kaliplar.php?kategori=2';
  static const String _url3 =
      'https://dilkumbaram.com/admin/api/kaliplar.php?kategori=3';

  static Future<List<KaliplarModel>> getKalipData() async {
    List<KaliplarModel> _list = [];
    const String _url =
          'https://dilkumbaram.com/admin/api/kaliplar.php?kategori=4';
      var result = await Dio().get(_url);
      var pokelist = result.data;

      if (pokelist is List) {
        _list = pokelist.map((e) => KaliplarModel.fromJson(e)).toList();
      } else {
        return [];
      }

      return _list;
  }

  static Future<List<KaliplarModel>> getKalipIngData(String kategori) async {
    List<KaliplarModel> _list = [];

    var result = await Dio().get(_url2 + "&kategori1='" + kategori + "'");
    var pokelist = result.data;

    if (pokelist is List) {
      _list = pokelist.map((e) => KaliplarModel.fromJson(e)).toList();
    } else {
      return [];
    }

    return _list;
  }

  static Future<List<KaliplarModel>> getKalipAlmnData(String kategori) async {
    List<KaliplarModel> _list = [];

    var result = await Dio().get(_url3 + "&kategori1='" + kategori + "'");
    var pokelist = result.data;

    if (pokelist is List) {
      _list = pokelist.map((e) => KaliplarModel.fromJson(e)).toList();
    } else {
      return [];
    }

    debugPrint('Almanca');
    return _list;
  }
}

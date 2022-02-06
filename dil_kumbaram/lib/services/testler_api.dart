import 'package:dil_kumbaram/models/testler_models.dart';
import 'package:dio/dio.dart';

class TestlerApi {
  static const String _kelimeTesti =
      "https://dilkumbaram.com/admin/api/testler.php?test=Kelime Testi";
  static const String _dinlemeTesti =
      "https://dilkumbaram.com/admin/api/testler.php?test=1";
  static const String _izlemeTesti =
      "https://dilkumbaram.com/admin/api/testler.php?test=2";
  static const String _cumleTesti =
      "https://dilkumbaram.com/admin/api/testler.php?test=3";

  static Future<List<TestlerModel>> getKelimeTesti(String dil) async {
    List<TestlerModel> _list = [];

    var result = await Dio().get(_kelimeTesti + "&dil='" + dil + "'");
    
    var pokelist = result.data;

    if (pokelist is List) {
      _list = pokelist.map((e) => TestlerModel.fromJson(e)).toList();
    } else {
      return [];
    }
    
    return _list;
  }

  static Future<List<TestlerModel>> getDinlemeTesti(String dil) async {
    List<TestlerModel> _list = [];

    var result = await Dio().get(_dinlemeTesti + "&dil='" + dil + "'");
    var pokelist = result.data;

    if (pokelist is List) {
      _list = pokelist.map((e) => TestlerModel.fromJson(e)).toList();
    } else {
      return [];
    }

    return _list;
  }

  static Future<List<TestlerModel>> getIzlemeTesti(String dil) async {
    List<TestlerModel> _list = [];

    var result = await Dio().get(_izlemeTesti + "&dil='" + dil + "'");
    var pokelist = result.data;

    if (pokelist is List) {
      _list = pokelist.map((e) => TestlerModel.fromJson(e)).toList();
    } else {
      return [];
    }

    return _list;
  }

  static Future<List<TestlerModel>> getCumleTesti(String dil) async {
    List<TestlerModel> _list = [];

    var result = await Dio().get(_cumleTesti + "&dil='" + dil + "'");
    var pokelist = result.data;

    if (pokelist is List) {
      _list = pokelist.map((e) => TestlerModel.fromJson(e)).toList();
    } else {
      return [];
    }

    return _list;
  }
}

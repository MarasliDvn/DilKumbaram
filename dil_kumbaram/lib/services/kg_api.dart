import 'package:dil_kumbaram/models/kg_models.dart';
import 'package:dio/dio.dart';


class KgApi {
  static const String _kgi2 =
      "https://dilkumbaram.com/admin/api/kgi.php?kategori=2";
  static const String _kgi3 =
      "https://dilkumbaram.com/admin/api/kgi.php?kategori=3&category=";

  static const String _kga2 =
      "https://dilkumbaram.com/admin/api/kga.php?kategori=2";
  static const String _kga3 =
      "https://dilkumbaram.com/admin/api/kga.php?kategori=3&category=";

  static Future<List<KgModel>> getKgisti() async {
    List<KgModel> _list = [];
     const String _kgi =
          "https://dilkumbaram.com/admin/api/kgi.php?kategori=4";
      var result = await Dio().get(_kgi);
      var pokelist = result.data;

      if (pokelist is List) {
        _list = pokelist.map((e) => KgModel.fromJson(e)).toList();
      } else {
        return [];
      }
      return _list;
  }

  static Future<List<KgModel>> getKgisti2() async {
    List<KgModel> _list = [];

    var result = await Dio().get(_kgi2);
    var pokelist = result.data;

    if (pokelist is List) {
      _list = pokelist.map((e) => KgModel.fromJson(e)).toList();
    } else {
      return [];
    }
    return _list;
  }

  static Future<List<KgModel>> getKgisti3(String kategori) async {
    List<KgModel> _list = [];

    var result = await Dio().get(_kgi3 + kategori);
    var pokelist = result.data;

    if (pokelist is List) {
      _list = pokelist.map((e) => KgModel.fromJson(e)).toList();
    } else {
      return [];
    }
    return _list;
  }

///////////////////////////////////////////////////////////////////////////
  static Future<List<KgModel>> getKgasti() async {
    List<KgModel> _list = [];
     const String _kga =
          "https://dilkumbaram.com/admin/api/kga.php?kategori=4";
      var result = await Dio().get(_kga);
      var pokelist = result.data;

      if (pokelist is List) {
        _list = pokelist.map((e) => KgModel.fromJson(e)).toList();
      } else {
        return [];
      }
      return _list;
  }

  static Future<List<KgModel>> getKgasti2() async {
    List<KgModel> _list = [];

    var result = await Dio().get(_kga2);
    var pokelist = result.data;

    if (pokelist is List) {
      _list = pokelist.map((e) => KgModel.fromJson(e)).toList();
    } else {
      return [];
    }
    return _list;
  }

  static Future<List<KgModel>> getKgasti3(String kategori) async {
    List<KgModel> _list = [];

    var result = await Dio().get(_kga3 + kategori);
    var pokelist = result.data;

    if (pokelist is List) {
      _list = pokelist.map((e) => KgModel.fromJson(e)).toList();
    } else {
      return [];
    }
    return _list;
  }
}

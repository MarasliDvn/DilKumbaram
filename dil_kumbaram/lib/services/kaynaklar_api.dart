import 'package:dil_kumbaram/models/kaynaklar_models.dart';
import 'package:dio/dio.dart';

class KaynaklarApi {
  static const String _url2 =
      'https://dilkumbaram.com/admin/api/kaynaklar.php?kategori=2';

  static Future<List<KaynaklarModel>> getKaynakData(String langue) async {
    List<KaynaklarModel> _list = [];
     const String _url =
          'https://dilkumbaram.com/admin/api/kaynaklar.php?kategori=3';
      var result = await Dio().get(_url + "&dil='" + langue + "'");
      var pokelist = result.data;

      if (pokelist is List) {
        _list = pokelist.map((e) => KaynaklarModel.fromJson(e)).toList();
      } else {
        return [];
      }

      return _list;
  }

  static Future<List<KaynaklarModel>> getKaynakDetailsData(
      String kategori, String dil) async {
    List<KaynaklarModel> _list = [];

    var result = await Dio()
        .get(_url2 + "&dil='" + dil + "'&kategori1='" + kategori + "'");
    var pokelist = result.data;

    if (pokelist is List) {
      _list = pokelist.map((e) => KaynaklarModel.fromJson(e)).toList();
    } else {
      return [];
    }

    return _list;
  }
}

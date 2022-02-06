
// ignore_for_file: file_names

class Listshufle {
  static List<dynamic> shufflelist(a, b,c,e,f) {
    List<dynamic> _list = [];
    _list=[
      [a,e],
      [b,f],
      [c,f]
    ];
    _list.shuffle();
    return _list;
  }
}

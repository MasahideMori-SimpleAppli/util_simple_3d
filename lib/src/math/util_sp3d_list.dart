import 'package:simple_3d/simple_3d.dart';

/// (en)A utility for easily manipulating lists when working with the simple_3d package.
///
/// (ja)simple_3dパッケージを扱う際にリストを簡単に操作するためのユーティリティです。
///
/// Author Masahide Mori
///
/// First edition creation date 2023-09-10 14:40:09
class UtilSp3dList {
  /// (en)Creates and returns a list of list indexes.
  ///
  /// (ja)リストのインデックスのリストを作成して返します。
  ///
  /// * [baseIndex] : The value to add to the index.
  static List<int> getIndexes(List<dynamic> l, int baseIndex) {
    List<int> r = [];
    for (int i = 0; i < l.length; i++) {
      r.add(i + baseIndex);
    }
    return r;
  }

  /// (en) Return Serialize list.
  ///
  /// (ja) 直列化したリストを返します。
  static List<Sp3dV3D> serialize(List<List<Sp3dV3D>> l) {
    List<Sp3dV3D> r = [];
    for (List<Sp3dV3D> i in l) {
      r.addAll(i);
    }
    return r;
  }
}

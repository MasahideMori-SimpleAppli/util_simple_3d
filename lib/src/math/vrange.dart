import 'dart:math';

/// (en)A class that defines a range of values and makes it convenient to use.
///
/// (ja)一定の値の範囲を定義し、便利に利用できるようにするためのクラスです。
///
/// Author Masahide Mori
///
/// First edition creation date 2023-09-10 14:31:24
class VRange {
  final double min;
  final double max;

  /// * [min] : The minimum value.
  /// * [max] : The maximum value.
  const VRange({required this.min, required this.max});

  /// (en) Returns a random value within a defined range.
  ///
  /// (ja) 定義した範囲内のランダムな値を返します。
  double getRandomInRange() {
    final double additionalSize = Random().nextDouble() * (max - min);
    return min + additionalSize;
  }

  /// (en) Returns the middle value of the defined range.
  ///
  /// (ja) 定義した範囲の中間の値を返します。
  double getCenterValue() {
    return min + ((max - min) / 2);
  }
}

import 'dart:math';

/// (en)A class that defines a range of values and makes it convenient to use.
///
/// (ja)一定の値の範囲を定義し、便利に利用できるようにするためのクラスです。
///
/// Author Masahide Mori
///
/// First edition creation date 2023-11-08 17:08:48
class IntVRange {
  final int min;
  final int max;

  /// * [min] : The minimum value.
  /// * [max] : The maximum value.
  const IntVRange({required this.min, required this.max});

  /// (en) Returns a random value within a defined range.
  ///
  /// (ja) 定義した範囲内のランダムな値を返します。
  int getRandomInRange() {
    return min + Random().nextInt(max - min + 1);
  }

  /// (en) Returns the middle value of the defined range.
  ///
  /// (ja) 定義した範囲の中間の値を返します。
  double getCenterValue() {
    return min + ((max - min) / 2);
  }

  /// (en) Returns true if the specified value is within this range.
  ///
  /// (ja) 指定した値がこの範囲の中ならtrueを返します。
  ///
  /// * [v] : The target value.
  ///
  /// returns : min <= v && v <= max.
  bool isInRange(int v) {
    return min <= v && v <= max;
  }

  /// (en) Returns true if the specified range even partially overlaps this range.
  ///
  /// (ja) 指定した範囲がこの範囲と一部でも重なる場合はtrueを返します。
  ///
  /// * [other] : The target range.
  bool isOverlapping(IntVRange other) {
    // If the target range [v] is completely before or after this range,
    // then they do not overlap.
    if (other.max < min || max < other.min) {
      return false;
    }
    // Otherwise, the ranges overlap.
    return true;
  }
}

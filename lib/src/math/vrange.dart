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

  /// (en) Returns true if the specified value is within this range.
  ///
  /// (ja) 指定した値がこの範囲の中ならtrueを返します。
  ///
  /// * [v] : The target value.
  ///
  /// returns : min <= v && v <= max.
  bool isInRange(double v) {
    return min <= v && v <= max;
  }

  /// (en) Returns true if the specified range even partially overlaps this range.
  ///
  /// (ja) 指定した範囲がこの範囲と一部でも重なる場合はtrueを返します。
  ///
  /// * [other] : The target range.
  bool isOverlapping(VRange other) {
    // If the target range [v] is completely before or after this range,
    // then they do not overlap.
    if (other.max < min || max < other.min) {
      return false;
    }
    // Otherwise, the ranges overlap.
    return true;
  }

  /// (en) Creates a list within this range with specified steps.
  /// The returned value has min rounded to ceil and max to floor.
  ///
  /// (ja) この範囲内で、指定されたステップでリストを作成します。
  /// 戻り値はminがceilで丸められ、maxはfloorで切り捨てられます。
  ///
  /// * [step] : The list will be created with this number of steps.
  /// Step must be greater than or equal to 1.
  List<int> generateList(int step) {
    if (step <= 0) {
      throw Exception('Step must be greater than or equal to 1.');
    }
    List<int> r = [];
    for (int i = min.ceil(); i <= max.floor(); i += step) {
      r.add(i);
    }
    return r;
  }

  /// (en) Creates a list within this range with specified steps.
  /// The returned value has min rounded to ceil and max to floor.
  ///
  /// (ja) この範囲内で、指定されたステップでリストを作成します。
  /// 戻り値はminがceilで丸められ、maxはfloorで切り捨てられます。
  ///
  /// * [step] : The list will be created with this number of steps.
  /// Step must be greater than or equal to 1.
  List<double> generateDoubleList(int step) {
    List<int> iList = generateList(step);
    List<double> r = [];
    for (int i in iList) {
      r.add(i.toDouble());
    }
    return r;
  }

  /// (en) Creates a list within this range with specified steps.
  ///
  /// (ja) この範囲内で、指定されたステップでリストを作成します。
  ///
  /// * [step] : The list will be created with this number of steps.
  /// Step must be greater than 0.
  /// * [isContainsMax] : If true, In the returned list,
  /// the max value will be added if the increment step would cause the value
  /// to exceed the max value,
  /// if False the max value will not be added if the increment step would
  /// cause the value to exceed the max value.
  ///
  /// Returns : [min, min + (step * 1), min + (step * 2),
  /// ... max or min + (step * X)].
  List<double> generateDoubleStepDoubleList(double step, bool isContainsMax) {
    List<double> r = [min];
    double now = min;
    while (now < max) {
      now += step;
      if (now <= max) {
        // This prevents the rare case in certain versions where
        // variable references may be broken when compiling to JavaScript.
        final double nowV = now;
        r.add(nowV);
      } else {
        if (isContainsMax) {
          final double nowV = max;
          r.add(nowV);
        }
      }
    }
    return r;
  }
}

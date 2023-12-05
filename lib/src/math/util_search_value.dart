/// (en)This is a utility for finding values close to a specified value.
///
/// (ja)指定した値に近い値を探すためのユーティリティです。
///
/// Author Masahide Mori
///
/// First edition creation date 2023-12-05 18:10:52
class UtilSearchValue {
  /// (en) Finds and returns the value closest to the specified value in
  /// the list using the dichotomous method.
  ///
  /// (ja) リスト中から、指定した値と最も近い値を二分法で探して返します。
  ///
  /// * [target] : Search target. Please note that sorting will occur.
  /// * [v] : Search value.
  static int findClosestValue(List<int> target, int v) {
    if (target.isEmpty) {
      throw Exception('Target list is empty.');
    }
    target.sort();
    int r = target.first;
    int low = 0;
    int high = target.length - 1;
    while (low <= high) {
      int mid = (low + high) ~/ 2;
      int cV = target[mid];
      if (cV == v) {
        return cV;
      } else if (cV < v) {
        low = mid + 1;
      } else {
        high = mid - 1;
      }
      if ((cV - v).abs() < (r - v).abs()) {
        r = cV;
      }
    }
    return r;
  }

  /// (en) Finds and returns the value closest to the specified value in
  /// the list using the dichotomous method.
  ///
  /// (ja) リスト中から、指定した値と最も近い値を二分法で探して返します。
  ///
  /// * [target] : Search target. Please note that sorting will occur.
  /// * [v] : Search value.
  static double findClosestValueForDouble(List<double> target, double v) {
    if (target.isEmpty) {
      throw Exception('Target list is empty.');
    }
    target.sort();
    double r = target.first;
    int low = 0;
    int high = target.length - 1;
    while (low <= high) {
      int mid = (low + high) ~/ 2;
      double cV = target[mid];
      if (cV == v) {
        return cV;
      } else if (cV < v) {
        low = mid + 1;
      } else {
        high = mid - 1;
      }
      if ((cV - v).abs() < (r - v).abs()) {
        r = cV;
      }
    }
    return r;
  }
}

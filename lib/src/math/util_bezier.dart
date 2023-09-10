import 'dart:math';

import 'package:simple_3d/simple_3d.dart';

/// (en)A utility for calculating Bezier curves.
///
/// (ja)ベジェ曲線の計算に関するユーティリティです。
///
/// Author Masahide Mori
///
/// First edition creation date 2023-09-10 14:37:05
class UtilBezier {
  /// (en) Calculates the control point from the given midpoint [center].
  ///
  /// (ja) 与えられた中間点[center]から制御点を逆算します。
  static Sp3dV3D _calculateControlPoint(
      Sp3dV3D start, Sp3dV3D center, Sp3dV3D end) {
    return (center * 2) - (start * 0.5) - (end * 0.5);
  }

  /// (en) Methods for calculating Bezier curves.
  /// This method assumes that a, b, and c are at the same z coordinate.
  /// Increasing [pointsCount] will result in a smoother approximation.
  ///
  /// (ja)ベジェ曲線を計算するためのメソッドです。
  /// a, b, cはそれぞれ同じz座標にあると考えて計算されます。
  /// [pointsCount]を増やすとより滑らかな近似になります。
  ///
  /// * [start] : The start point.
  /// * [center] : The center point.
  /// This point is calculated as an approximation and may not be passed through.
  /// * [end] : The end point.
  /// * [pointsCount] : Number of points used for approximation.
  ///
  /// Returns : Sp3dV3D points.
  static List<Sp3dV3D> bezierCurve(
      Sp3dV3D start, Sp3dV3D center, Sp3dV3D end, int count) {
    List<Sp3dV3D> r = [];
    final Sp3dV3D ctrlPoint = _calculateControlPoint(start, center, end);
    for (int i = 0; i < count; i++) {
      double t = i / (count - 1);
      double x = pow(1 - t, 2) * start.x +
          2 * (1 - t) * t * ctrlPoint.x +
          pow(t, 2) * end.x;
      double y = pow(1 - t, 2) * start.y +
          2 * (1 - t) * t * ctrlPoint.y +
          pow(t, 2) * end.y;
      r.add(Sp3dV3D(x, y, start.z));
    }
    return r;
  }
}

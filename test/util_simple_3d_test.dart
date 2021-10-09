import 'package:flutter_test/flutter_test.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/util_sp3d_geometry.dart';

void main() {
  test('create geometry', () {
    final Sp3dObj obj = Util_Sp3dGeometry.capsule(50, 250);
  });
}

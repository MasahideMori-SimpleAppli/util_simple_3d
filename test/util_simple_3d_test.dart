import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/f_sp3d_material.dart';
import 'package:util_simple_3d/util_sp3d_geometry.dart';

void main() {
  test('create geometry', () {
    Sp3dObj obj = UtilSp3dGeometry.capsule(50, 250);
    obj = UtilSp3dGeometry.cube(200, 200, 200, 4, 4, 4);
    obj.materials.add(FSp3dMaterial.green.deepCopy());
    obj.fragments[0].faces[0].materialIndex = 1;

    obj = UtilSp3dGeometry.tile(200, 200, 4, 4);
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = Color.fromARGB(255, 0, 255, 0);

    obj = UtilSp3dGeometry.cube(200, 200, 200, 4, 4, 4);
    obj.materials.add(FSp3dMaterial.green.deepCopy());
    obj.fragments[0].faces[0].materialIndex = 1;
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = Color.fromARGB(255, 0, 0, 255);
    obj.rotate(Sp3dV3D(1, 1, 0).nor(), 30 * 3.14 / 180);

    obj = UtilSp3dGeometry.circle(100, fragments: 20);
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = Color.fromARGB(255, 0, 255, 0);

    obj = UtilSp3dGeometry.cone(100, 200);
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = Color.fromARGB(255, 0, 255, 0);
    obj.rotate(Sp3dV3D(1, 0, 0), -100 * 3.14 / 180);
    obj.move(Sp3dV3D(0, -100, 0));

    obj = UtilSp3dGeometry.pillar(50, 50, 200);
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = Color.fromARGB(255, 0, 255, 0);
    obj.rotate(Sp3dV3D(1, 0, 0), -120 * 3.14 / 180);
    obj.move(Sp3dV3D(0, -100, 0));

    obj = UtilSp3dGeometry.sphere(100);
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = Color.fromARGB(255, 0, 255, 0);

    obj = UtilSp3dGeometry.capsule(50, 200);
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = Color.fromARGB(255, 0, 255, 0);
    obj.move(Sp3dV3D(0, 100, 0));

    obj = UtilSp3dGeometry.cube(200, 200, 200, 4, 4, 4);
    obj.materials.add(FSp3dMaterial.greenWire.deepCopy());
    obj.fragments[0].faces[0].materialIndex = 1;
    obj.materials[0] = FSp3dMaterial.blueWire.deepCopy();
    obj.rotate(Sp3dV3D(-0.2, 0.5, 0).nor(), 15 * 3.14 / 180);
  });
}

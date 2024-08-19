import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/util_simple_3d.dart';

void main() {
  test('create geometry', () {
    Sp3dObj obj = UtilSp3dGeometry.capsule(50, 250);
    obj = UtilSp3dGeometry.cube(200, 200, 200, 4, 4, 4);
    obj.materials.add(FSp3dMaterial.green.deepCopy());
    obj.fragments[0].faces[0].materialIndex = 1;

    obj = UtilSp3dGeometry.tile(200, 200, 4, 4);
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 255, 0);

    obj = UtilSp3dGeometry.cube(200, 200, 200, 4, 4, 4);
    obj.materials.add(FSp3dMaterial.green.deepCopy());
    obj.fragments[0].faces[0].materialIndex = 1;
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    obj.rotate(Sp3dV3D(1, 1, 0).nor(), 30 * 3.14 / 180);

    obj = UtilSp3dGeometry.circle(100, fragments: 20);
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 255, 0);

    obj = UtilSp3dGeometry.cone(100, 200);
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 255, 0);
    obj.rotate(Sp3dV3D(1, 0, 0), -100 * 3.14 / 180);
    obj.move(Sp3dV3D(0, -100, 0));

    obj = UtilSp3dGeometry.pillar(50, 50, 200);
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 255, 0);
    obj.rotate(Sp3dV3D(1, 0, 0), -120 * 3.14 / 180);
    obj.move(Sp3dV3D(0, -100, 0));

    obj = UtilSp3dGeometry.sphere(100);
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 255, 0);

    obj = UtilSp3dGeometry.capsule(50, 200);
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 255, 0);
    obj.move(Sp3dV3D(0, 100, 0));

    obj = UtilSp3dGeometry.cube(200, 200, 200, 4, 4, 4);
    obj.materials.add(FSp3dMaterial.greenWire.deepCopy());
    obj.fragments[0].faces[0].materialIndex = 1;
    obj.materials[0] = FSp3dMaterial.blueWire.deepCopy();
    obj.rotate(Sp3dV3D(-0.2, 0.5, 0).nor(), 15 * 3.14 / 180);
  });

  test('create common parts', () {
    List<Sp3dObj> objs = UtilSp3dCommonParts.coordinateArrows(255);
    objs.addAll(UtilSp3dCommonParts.worldMeshes(255));
  });

  test('calculate bezier', () {
    List<Sp3dV3D> v = UtilBezier.bezierCurve(
        Sp3dV3D(0, 0, 0), Sp3dV3D(1, 1, 0), Sp3dV3D(2, 0, 0), 1000);
    expect(v[0].equals(Sp3dV3D(0, 0, 0), 0.01), true);
    print("The approximate calculation result");
    print(v[499].toString());
    expect(v[499].equals(Sp3dV3D(1, 1, 0), 0.01), true);
    expect(v[999].equals(Sp3dV3D(2, 0, 0), 0.01), true);
  });

  test('isInRange', () {
    VRange range = const VRange(min: 1, max: 5);
    expect(range.isInRange(0), false);
    expect(range.isInRange(1), true);
    expect(range.isInRange(3), true);
    expect(range.isInRange(5), true);
    expect(range.isInRange(6), false);
  });

  test('isOverlapping', () {
    VRange range1 = const VRange(min: 1, max: 5);
    VRange range2 = const VRange(min: 1, max: 1);
    VRange range3 = const VRange(min: 0, max: 1);
    VRange range4 = const VRange(min: 0, max: 0);
    VRange range5 = const VRange(min: 5, max: 5);
    VRange range6 = const VRange(min: 5, max: 6);
    VRange range7 = const VRange(min: 6, max: 6);
    VRange range8 = const VRange(min: 2, max: 3);
    expect(range1.isOverlapping(range1), true);
    expect(range1.isOverlapping(range2), true);
    expect(range1.isOverlapping(range3), true);
    expect(range1.isOverlapping(range4), false);
    expect(range1.isOverlapping(range5), true);
    expect(range1.isOverlapping(range6), true);
    expect(range1.isOverlapping(range7), false);
    expect(range1.isOverlapping(range8), true);
  });

  test('generateList', () {
    VRange range1 = const VRange(min: 0.1, max: 9.5);
    IntVRange range2 = const IntVRange(min: 0, max: 8);
    List<int> gl1 = range1.generateList(2);
    List<int> gl2 = range2.generateList(3);
    expect(gl1.length == 5, true);
    expect(gl1.first == 1, true);
    expect(gl1[1] == 3, true);
    expect(gl1.last == 9, true);
    expect(gl2.length == 3, true);
    expect(gl2.first == 0, true);
    expect(gl2[1] == 3, true);
    expect(gl2.last == 6, true);
  });

  test('findClosestValue', () {
    IntVRange range = const IntVRange(min: 0, max: 8);
    expect(
        UtilSearchValue.findClosestValueForDouble([0.1, 2, 3, 3.5, 5], 3.2) ==
            3,
        true);
    expect(
        UtilSearchValue.findClosestValue(range.generateList(1), 5) == 5, true);
  });

  test('generateDoubleList', () {
    VRange range = const VRange(min: 0, max: 8);
    List<double> dList = range.generateDoubleList(2);
    expect(dList[0] == 0, true);
    expect(dList[1] == 2, true);
    expect(dList[2] == 4, true);
    expect(dList[3] == 6, true);
    expect(dList[4] == 8, true);
  });

  test('generateDoubleStepDoubleList', () {
    VRange range = const VRange(min: 0, max: 8.2);
    List<double> dList1 = range.generateDoubleStepDoubleList(0.5, false);
    expect(dList1[0] == 0, true);
    expect(dList1[1] == 0.5, true);
    expect(dList1[2] == 1, true);
    expect(dList1[16] == 8, true);
    expect(dList1.length == 17, true);
    List<double> dList2 = range.generateDoubleStepDoubleList(0.5, true);
    expect(dList2[0] == 0, true);
    expect(dList2[1] == 0.5, true);
    expect(dList2[2] == 1, true);
    expect(dList2[16] == 8, true);
    expect(dList2[17] == 8.2, true);
    expect(dList2.length == 18, true);
  });
}

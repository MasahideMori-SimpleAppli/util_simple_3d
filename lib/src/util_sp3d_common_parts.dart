import 'package:simple_3d/simple_3d.dart';
import '../util_simple_3d.dart';

/// (en)A utility to generate common parts using sp3d.
/// (ja)sp3dを使った一般的なパーツを生成するユーティリティです。
///
/// Author Masahide Mori
///
/// First edition creation date 2023-01-01 21:10:36
///
class UtilSp3dCommonParts {
  /// (en)Generates arrows representing x,y,z coordinates.
  ///
  /// (ja)x、y、z 座標を表す矢印を生成します。
  ///
  /// * [h] : The pillar height.
  /// * [r] : The pillar radius.
  /// * [materialX] : The material of x axis. Default is red color.
  /// * [materialY] : The material of y axis. Default is green color.
  /// * [materialZ] : The material of z axis. Default is blue color.
  /// * [isCube] : If true, The pillars become squares, which reduces the rendering cost a bit.
  /// * [useArrowHead] : If true, If true, add a cone to the tip of the pillar.　Note that the pillar is longer by the arrowhead.
  /// * [arrowHeadR] : The arrow head radius.
  /// * [arrowHeadH] : The arrow head height.
  /// * [layerNum] : Draw order of objects. If the renderer supports it,
  /// rendering from smaller this value.
  ///
  /// Returns Sp3dObj list.
  /// If useArrowHead is true, [xAxisPillar, yAxisPillar, zAxisPillar, xAxisArrow, yAxisArrow, zAxisArrow].
  /// If useArrowHead is false, [xAxisPillar, yAxisPillar, zAxisPillar].
  static List<Sp3dObj> coordinateArrows(double h,
      {double r = 2,
      Sp3dMaterial? materialX,
      Sp3dMaterial? materialY,
      Sp3dMaterial? materialZ,
      bool isCube = false,
      bool useArrowHead = true,
      double arrowHeadR = 4,
      double arrowHeadH = 16,
      int layerNum = -1}) {
    List<Sp3dObj> objList = [];
    // 柱
    if (isCube) {
      Sp3dObj xAxisPillar = UtilSp3dGeometry.cube(r * 2, r * 2, h, 1, 1, 1,
          material: materialX ?? FSp3dMaterial.redNonWire.deepCopy());
      xAxisPillar.rotate(Sp3dV3D(0, 1, 0), 90 * Sp3dConstantValues.toRadian);
      Sp3dObj yAxisPillar = UtilSp3dGeometry.cube(r * 2, r * 2, h, 1, 1, 1,
          material: materialY ?? FSp3dMaterial.greenNonWire.deepCopy());
      yAxisPillar.rotate(Sp3dV3D(1, 0, 0), -90 * Sp3dConstantValues.toRadian);
      Sp3dObj zAxisPillar = UtilSp3dGeometry.cube(r * 2, r * 2, h, 1, 1, 1,
          material: materialZ ?? FSp3dMaterial.blueNonWire.deepCopy());
      objList.add(xAxisPillar);
      objList.add(yAxisPillar);
      objList.add(zAxisPillar);
    } else {
      Sp3dObj xAxisPillar = UtilSp3dGeometry.pillar(r, r, h,
          material: materialX ?? FSp3dMaterial.redNonWire.deepCopy());
      xAxisPillar.rotate(Sp3dV3D(0, 1, 0), 90 * Sp3dConstantValues.toRadian);
      Sp3dObj yAxisPillar = UtilSp3dGeometry.pillar(r, r, h,
          material: materialY ?? FSp3dMaterial.greenNonWire.deepCopy());
      yAxisPillar.rotate(Sp3dV3D(1, 0, 0), -90 * Sp3dConstantValues.toRadian);
      Sp3dObj zAxisPillar = UtilSp3dGeometry.pillar(r, r, h,
          material: materialZ ?? FSp3dMaterial.blueNonWire.deepCopy());
      objList.add(xAxisPillar);
      objList.add(yAxisPillar);
      objList.add(zAxisPillar);
    }
    // 軸先端のとがった部分
    if (useArrowHead) {
      Sp3dObj xAxisArrow = UtilSp3dGeometry.cone(arrowHeadR, arrowHeadH,
          material: materialX ?? FSp3dMaterial.redNonWire.deepCopy());
      xAxisArrow.rotate(Sp3dV3D(0, 1, 0), 90 * Sp3dConstantValues.toRadian);
      xAxisArrow.move(Sp3dV3D(h, 0, 0));
      Sp3dObj yAxisArrow = UtilSp3dGeometry.cone(arrowHeadR, arrowHeadH,
          material: materialY ?? FSp3dMaterial.greenNonWire.deepCopy());
      yAxisArrow.rotate(Sp3dV3D(1, 0, 0), -90 * Sp3dConstantValues.toRadian);
      yAxisArrow.move(Sp3dV3D(0, h, 0));
      Sp3dObj zAxisArrow = UtilSp3dGeometry.cone(arrowHeadR, arrowHeadH,
          material: materialZ ?? FSp3dMaterial.blueNonWire.deepCopy());
      zAxisArrow.move(Sp3dV3D(0, 0, h));
      objList.add(xAxisArrow);
      objList.add(yAxisArrow);
      objList.add(zAxisArrow);
    }
    // 全てのオブジェクトの描画優先度を変更する
    for (Sp3dObj i in objList) {
      i.layerNum = layerNum;
      // 背景用なのでタッチ計算の対象外にする。
      i.setIsTouchableFlags(false);
    }
    return objList;
  }

  /// (en)Generates square meshes such as the floor of the world.
  ///
  /// (ja)ワールドの床などの正方形のメッシュを生成します。
  ///
  /// * [size] : The length of one side of a square.
  /// * [material] : The mesh material.
  /// * [split] : The number of vertical and horizontal divisions of the mesh.
  /// * [isTwoSides] :If true, generate a two-sided mesh.
  /// However, if you want to reduce the drawing load,
  /// it may be better to generate a one-sided mesh and set the camera's isAllDrawn parameter to true.
  /// * [layerNum] : Draw order of objects. If the renderer supports it,
  /// rendering from smaller this value.
  ///
  /// Returns Sp3dObj list.
  /// If isTwoSides is true, [gridBackFront, gridFloorFront, gridLeftFront, gridBackBack, gridFloorBack, gridLeftBack].
  /// If isTwoSides is false, [gridBackFront, gridFloorFront, gridLeftFront].
  static List<Sp3dObj> worldMeshes(double size,
      {Sp3dMaterial? material,
      int split = 5,
      bool isTwoSides = true,
      int layerNum = -2}) {
    List<Sp3dObj> objList = [];
    // 表面
    Sp3dObj gridBackFront = UtilSp3dGeometry.tile(size, size, split, split,
        material: material ?? FSp3dMaterial.whiteWire.deepCopy());
    gridBackFront.move(Sp3dV3D(size / 2, size / 2, 0));
    Sp3dObj gridFloorFront = gridBackFront
        .deepCopy()
        .rotate(Sp3dV3D(1, 0, 0), 90 * Sp3dConstantValues.toRadian)
        .reversed();
    Sp3dObj gridLeftFront = gridBackFront
        .deepCopy()
        .rotate(Sp3dV3D(0, 1, 0), -90 * Sp3dConstantValues.toRadian)
        .reversed();
    objList.add(gridBackFront);
    objList.add(gridFloorFront);
    objList.add(gridLeftFront);
    // 裏面
    if (isTwoSides) {
      objList.add(gridBackFront.reversed());
      objList.add(gridFloorFront.reversed());
      objList.add(gridLeftFront.reversed());
    }
    // 全てのオブジェクトの描画優先度を変更する
    for (Sp3dObj i in objList) {
      i.layerNum = layerNum;
      // 背景用なのでタッチ計算の対象外にする。
      i.setIsTouchableFlags(false);
    }
    return objList;
  }
}

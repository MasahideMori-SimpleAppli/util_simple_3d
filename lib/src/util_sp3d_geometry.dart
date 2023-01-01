import 'package:simple_3d/simple_3d.dart';
import 'dart:math';
import 'f_sp3d_material.dart';

/// (en)It is a utility related to the three-dimensional structure using sp3d.
/// (ja)sp3dを使った立体構造に関するユーティリティです。
///
/// Author Masahide Mori
///
/// First edition creation date 2021-09-2 20:07:21
///
class UtilSp3dGeometry {
  static const double _toRadian = pi / 180;

  /// (en)Creates and returns a list of list indexes.
  ///
  /// (ja)リストのインデックスのリストを作成して返します。
  ///
  /// * [baseIndex] : The value to add to the index.
  static List<int> _getIndexes(List<dynamic> l, int baseIndex) {
    List<int> r = [];
    for (int i = 0; i < l.length; i++) {
      r.add(i + baseIndex);
    }
    return r;
  }

  /// (en) Return Serialize list.
  ///
  /// (ja)直列化したリストを返します。
  static List<Sp3dV3D> _serialize(List<List<Sp3dV3D>> l) {
    List<Sp3dV3D> r = [];
    for (List<Sp3dV3D> i in l) {
      r.addAll(i);
    }
    return r;
  }

  /// (en)Generates the coordinates of a quadrilateral tile with the (0,0,0) point as the center.
  ///
  /// (ja)(0,0,0)点を中心とした四角形タイルの座標を生成します。
  ///
  /// * [w] : width.
  /// * [h] : height.
  /// * [wSplit] : Number of divisions in the width direction. Must be 1 or more.
  /// * [hSplit] : Number of divisions in the height direction. Must be 1 or more.
  ///
  /// Returns 3d tile vertices. [[tiles of horizontal...] tiles of vertical...].
  static List<List<Sp3dV3D>> _tileV3d(
      double w, double h, int wSplit, int hSplit) {
    final double start = -w / 2;
    final double bottom = -h / 2;
    final double wAdd = w / wSplit;
    final double endBase = start + wAdd;
    final double hAdd = h / hSplit;
    final double topBase = bottom + hAdd;
    List<double> startList = [];
    List<double> endList = [];
    List<double> topList = [];
    List<double> bottomList = [];
    for (int i = 0; i < wSplit; i++) {
      double p = i * wAdd;
      startList.add(start + p);
      endList.add(endBase + p);
    }
    for (int i = 0; i < hSplit; i++) {
      double p = i * hAdd;
      bottomList.add(bottom + p);
      topList.add(topBase + p);
    }
    List<List<Sp3dV3D>> r = [];
    for (int i = 0; i < hSplit; i++) {
      for (int j = 0; j < wSplit; j++) {
        r.add([
          Sp3dV3D(startList[j], topList[i], 0), // lt
          Sp3dV3D(startList[j], bottomList[i], 0), // lb
          Sp3dV3D(endList[j], bottomList[i], 0), // rb
          Sp3dV3D(endList[j], topList[i], 0) // rt
        ]);
      }
    }
    return r;
  }

  /// (en)Generates the quadrilateral tile obj with the (0,0,0) point as the center.
  /// When divided, fragments for the number of divisions are included.
  ///
  /// (ja)(0,0,0)点を中心とした四角形タイルのオブジェクトを生成します。
  /// 分割した場合は分割数分のフラグメントを内包します。
  ///
  /// * [w] : width.
  /// * [h] : height.
  /// * [wSplit] : Number of divisions in the width direction. Must be 1 or more.
  /// * [hSplit] : Number of divisions in the height direction. Must be 1 or more.
  /// * [material] : face material
  ///
  /// Returns 3d tile obj.
  static Sp3dObj tile(double w, double h, int wSplit, int hSplit,
      {Sp3dMaterial? material}) {
    List<List<Sp3dV3D>> tile = _tileV3d(w, h, wSplit, hSplit);
    List<Sp3dV3D> serialized = _serialize(tile);
    List<Sp3dFragment> fragments = [];
    int count = 0;
    for (List<Sp3dV3D> face in tile) {
      fragments.add(Sp3dFragment([Sp3dFace(_getIndexes(face, count), 0)]));
      count += face.length;
    }
    return Sp3dObj(serialized, fragments, [
      material ?? FSp3dMaterial.grey,
    ], []);
  }

  /// (en)Generates the coordinates of a rectangular parallelepiped extending in the z direction with respect the (0,0,0) point.
  ///
  /// (ja)(0,0,0)点を底面の中心とした直方体の座標を生成します。
  ///
  /// * [w] : width.
  /// * [h] : height.
  /// * [d] : depth.
  /// * [wSplit] : Number of divisions in the width direction. Must be 1 or more.
  /// * [hSplit] : Number of divisions in the height direction. Must be 1 or more.
  /// * [dSplit] : Number of divisions in the depth direction. Must be 1 or more.
  ///
  /// Returns 3d cube vertices. [[horizontal of front1,2,3,4,back1,2,3,4] vertical of ...].
  static List<List<Sp3dV3D>> _cubeV3d(
      double w, double h, double d, int wSplit, int hSplit, int dSplit) {
    List<List<Sp3dV3D>> r = [];
    List<List<Sp3dV3D>> frontTile = _tileV3d(w, h, wSplit, hSplit);
    Sp3dV3D toFrontV = Sp3dV3D(0, 0, d);
    for (List<Sp3dV3D> i in frontTile) {
      for (Sp3dV3D j in i) {
        j.add(toFrontV);
      }
    }
    // 刻み幅
    Sp3dV3D splitDist = Sp3dV3D(0, 0, -d / dSplit);
    // z軸で手前から奥へ向けてマッピング。
    for (int z = 0; z < dSplit; z++) {
      for (List<Sp3dV3D> tile in frontTile) {
        List<Sp3dV3D> cubeV = [];
        // front 4 vertex
        for (Sp3dV3D t in tile) {
          cubeV.add(t + (splitDist * z));
        }
        // back 4 vertex
        for (Sp3dV3D t in tile.reversed) {
          cubeV.add(t + (splitDist * (z + 1)));
        }
        r.add(cubeV);
      }
    }
    return r;
  }

  /// (en)Generates the object of a rectangular parallelepiped extending in the z direction with respect the (0,0,0) point.
  ///
  /// (ja)(0,0,0)点を中心として、z方向に伸びた直方体を生成します。
  ///
  /// * [w] : width.
  /// * [h] : height.
  /// * [d] : depth.
  /// * [wSplit] : Number of divisions in the width direction. Must be 1 or more.
  /// * [hSplit] : Number of divisions in the height direction. Must be 1 or more.
  /// * [dSplit] : Number of divisions in the depth direction. Must be 1 or more.
  /// * [material] : face material
  ///
  /// Returns 3d cube obj.
  static Sp3dObj cube(
      double w, double h, double d, int wSplit, int hSplit, int dSplit,
      {Sp3dMaterial? material}) {
    List<List<Sp3dV3D>> c = _cubeV3d(w, h, d, wSplit, hSplit, dSplit);
    List<Sp3dV3D> serialized = _serialize(c);
    List<Sp3dFragment> fragments = [];
    int count = 0;
    for (List<Sp3dV3D> v in c) {
      List<int> i = _getIndexes(v, count);
      List<Sp3dFace> faces = [
        Sp3dFace([i[0], i[1], i[2], i[3]], 0), // front
        Sp3dFace([i[4], i[5], i[6], i[7]], 0), // back
        Sp3dFace([i[7], i[0], i[3], i[4]], 0), // top
        Sp3dFace([i[7], i[6], i[1], i[0]], 0), // left
        Sp3dFace([i[5], i[2], i[1], i[6]], 0), // bottom
        Sp3dFace([i[3], i[2], i[5], i[4]], 0), // right
      ];
      fragments.add(Sp3dFragment(faces));
      count += i.length;
    }
    return Sp3dObj(serialized, fragments, [
      material ?? FSp3dMaterial.grey,
    ], []);
  }

  /// (en)Generates the coordinates of a circle centered on the (0,0,0) point.
  /// The center point is added at the end.
  ///
  /// (ja)(0,0,0)点を中心とした円の座標を生成します。
  /// 中心の点は最後に追加されています。
  ///
  /// * [r] : radius.
  /// * [fragments] : The number of triangles that make up a circle. The more it is, the smoother it becomes.
  /// Divide the area for the angle specified by theta by this number of triangles.
  /// * [theta] : 360 for a circle. 180 for a semicircle. The range is 1-360 degrees.
  ///
  /// Returns 3d circle vertices.
  static List<Sp3dV3D> _circleV3d(double r, int fragments,
      {double theta = 360}) {
    // 回転角（逆時計周り）
    final double radian = theta / fragments * _toRadian;
    // 始点から終点への軸ベクトルを考える。
    Sp3dV3D norAxis = Sp3dV3D(0, 0, 1);
    // 半径rの回転ベクトル
    List<Sp3dV3D> c = [Sp3dV3D(r, 0, 0)];
    for (int i = 0; i < fragments; i++) {
      c.add(c.last.rotated(norAxis, radian));
    }
    c.add(Sp3dV3D(0, 0, 0));
    return c;
  }

  /// (en)Generates a circle centered on the (0,0,0) point.
  /// This approximates a circle with a triangle, not a true circle.
  /// Even at 360 degrees, the start and end points of the circumference are not connected.
  /// If you want to rotate this, use the function of Sp3dObj.
  ///
  /// (ja)(0,0,0)点を中心とした円を生成します。
  /// これは真の円ではなく、三角形で円を近似します。
  /// 360度の場合でも、円周の始点と終点はつながっていません。
  /// 回転したい場合はSp3dObjの機能を使用してください。
  ///
  /// * [r] : radius.
  /// * [fragments] : The number of triangles that make up a circle. The more it is, the smoother it becomes.
  /// Divide the area for the angle specified by theta by this number of triangles.
  /// * [theta] : 360 for a circle. 180 for a semicircle. The range is 1-360 degrees.
  /// * [material] : face material
  ///
  /// Returns 3d circle obj.
  static Sp3dObj circle(double r,
      {int fragments = 8, double theta = 360, Sp3dMaterial? material}) {
    List<Sp3dV3D> serialized = _circleV3d(r, fragments, theta: theta);
    List<int> indexes = _getIndexes(serialized, 0);
    List<Sp3dFragment> mFragments = [];
    final int lastIndex = indexes.length - 1;
    for (int i = 0; i < fragments; i++) {
      List<Sp3dFace> faces = [
        Sp3dFace([indexes[lastIndex], indexes[i], indexes[(i + 1)]], 0)
      ];
      mFragments.add(Sp3dFragment(faces));
    }
    return Sp3dObj(serialized, mFragments, [
      material ?? FSp3dMaterial.grey,
    ], []);
  }

  /// (en)Generates a cone extending in the z direction with respect the (0,0,0) point.
  /// This approximates a circle with a triangle, not a true circle.
  /// Even at 360 degrees, the start and end points of the circumference are not connected.
  /// If you want to rotate this, use the function of Sp3dObj.
  ///
  /// (ja)(0,0,0)点を中心として、z方向に伸びた円錐を生成します。
  /// これは真の円ではなく、三角形で円を近似します。
  /// 360度の場合でも、円周の始点と終点はつながっていません。
  /// 回転したい場合はSp3dObjの機能を使用してください。
  ///
  /// * [r] : radius.
  /// * [h] : height.
  /// * [fragments] : The number of triangles that make up a circle. The more it is, the smoother it becomes.
  /// Divide the area for the angle specified by theta by this number of triangles.
  /// * [theta] : 360 for a circle. 180 for a semicircle. The range is 1-360 degrees.
  /// * [isClosedBottom] : If true, close bottom. otherwise open.
  /// * [isClosedSide] : If true, close the side on the start point side and the side on the end point side. otherwise open.
  /// * [material] : face material
  ///
  /// Returns 3d cone obj.
  static Sp3dObj cone(double r, double h,
      {int fragments = 8,
      double theta = 360,
      bool isClosedBottom = true,
      bool isClosedSide = true,
      Sp3dMaterial? material}) {
    List<Sp3dV3D> serialized = _circleV3d(r, fragments, theta: theta);
    List<int> indexes = _getIndexes(serialized, 0);
    // 頂点を追加（底面は追加済み）
    serialized.add(Sp3dV3D(0, 0, h));
    List<Sp3dFragment> mFragments = [];
    final int bottomIndex = serialized.length - 2;
    final int topIndex = serialized.length - 1;
    indexes.add(topIndex);
    for (int i = 0; i < fragments; i++) {
      // 底面
      if (isClosedBottom) {
        List<Sp3dFace> bottomFaces = [
          Sp3dFace([indexes[bottomIndex], indexes[(i + 1)], indexes[i]], 0)
        ];
        mFragments.add(Sp3dFragment(bottomFaces));
      }
      // 頂点
      List<Sp3dFace> topFaces = [
        Sp3dFace([indexes[topIndex], indexes[i], indexes[(i + 1)]], 0)
      ];
      mFragments.add(Sp3dFragment(topFaces));
    }
    // 始点側と終点側の側面を閉じる。
    if (isClosedSide) {
      List<Sp3dFace> spFaces = [
        Sp3dFace([indexes[topIndex], indexes[bottomIndex], indexes[0]], 0)
      ];
      mFragments.add(Sp3dFragment(spFaces));
      List<Sp3dFace> epFaces = [
        Sp3dFace(
            [indexes[topIndex], indexes[bottomIndex - 1], indexes[bottomIndex]],
            0)
      ];
      mFragments.add(Sp3dFragment(epFaces));
    }
    return Sp3dObj(serialized, mFragments, [
      material ?? FSp3dMaterial.grey,
    ], []);
  }

  /// (en)Generates a pillar extending in the z direction with respect the (0,0,0) point.
  /// This approximates a circle with a triangle, not a true circle.
  /// Even at 360 degrees, the start and end points of the circumference are not connected.
  /// If you want to rotate this, use the function of Sp3dObj.
  ///
  /// (ja)(0,0,0)点を中心として、z方向に伸びた円柱を生成します。
  /// これは真の円ではなく、三角形で円を近似します。
  /// 360度の場合でも、円周の始点と終点はつながっていません。
  /// 回転したい場合はSp3dObjの機能を使用してください。
  ///
  /// * [rTop] : top circle radius.
  /// * [rBottom] : bottom circle radius.
  /// * [h] : height.
  /// * [fragments] : The number of triangles that make up a circle. The more it is, the smoother it becomes.
  /// Divide the area for the angle specified by theta by this number of triangles.
  /// * [theta] : 360 for a circle. 180 for a semicircle. The range is 1-360 degrees.
  /// * [isClosedBottom] : If true, close bottom. otherwise open.
  /// * [isClosedTop] : If true, close top. otherwise open.
  /// * [isClosedSide] : If true, close the side on the start point side and the side on the end point side. otherwise open.
  /// * [material] : face material
  ///
  /// Returns 3d pillar obj.
  static Sp3dObj pillar(double rTop, double rBottom, double h,
      {int fragments = 8,
      double theta = 360,
      bool isClosedBottom = true,
      bool isClosedTop = true,
      bool isClosedSide = true,
      Sp3dMaterial? material}) {
    List<Sp3dV3D> btm = _circleV3d(rBottom, fragments, theta: theta);
    final int bottomIndex = btm.length - 1;
    final int topStart = btm.length;
    List<Sp3dV3D> top = _circleV3d(rTop, fragments, theta: theta);
    Sp3dV3D addH = Sp3dV3D(0, 0, h);
    for (Sp3dV3D i in top) {
      i.add(addH);
    }
    btm.addAll(top);
    List<int> indexes = _getIndexes(btm, 0);
    int topIndex = indexes.length - 1;
    List<Sp3dFragment> mFragments = [];
    for (int i = 0; i < fragments; i++) {
      // 底面
      if (isClosedBottom) {
        List<Sp3dFace> bottomFaces = [
          Sp3dFace([indexes[bottomIndex], indexes[(i + 1)], indexes[i]], 0)
        ];
        mFragments.add(Sp3dFragment(bottomFaces));
      }
      // 壁面
      int topI = i + topStart;
      List<Sp3dFace> wallFaces = [
        Sp3dFace(
            [indexes[topI], indexes[i], indexes[(i + 1)], indexes[(topI + 1)]],
            0)
      ];
      mFragments.add(Sp3dFragment(wallFaces));
      // 頂点
      if (isClosedTop) {
        List<Sp3dFace> topFaces = [
          Sp3dFace([indexes[topIndex], indexes[topI], indexes[(topI + 1)]], 0)
        ];
        mFragments.add(Sp3dFragment(topFaces));
      }
    }
    // 始点側と終点側の側面を閉じる。
    if (isClosedSide) {
      List<Sp3dFace> spFaces = [
        Sp3dFace([
          indexes[topIndex],
          indexes[bottomIndex],
          indexes[0],
          indexes[topStart]
        ], 0)
      ];
      mFragments.add(Sp3dFragment(spFaces));
      List<Sp3dFace> epFaces = [
        Sp3dFace([
          indexes[topIndex],
          indexes[indexes.length - 2],
          indexes[bottomIndex - 1],
          indexes[bottomIndex]
        ], 0)
      ];
      mFragments.add(Sp3dFragment(epFaces));
    }
    return Sp3dObj(btm, mFragments, [
      material ?? FSp3dMaterial.grey,
    ], []);
  }

  /// (en)Generates a sphere centered on the (0,0,0) point.
  /// This approximates a circle with a triangle, not a true circle.
  /// If you want to rotate this, use the function of Sp3dObj.
  ///
  /// (ja)(0,0,0)点を中心とした球を生成します。
  /// これは真の円ではなく、三角形で円を近似します。
  /// 回転したい場合はSp3dObjの機能を使用してください。
  ///
  /// * [r] : radius.
  /// * [xFragments] : split of sphere surface x axis.
  /// * [yFragments] : split of sphere surface y axis.
  /// * [wTheta] : The angle of how much to generate in the latitude direction. It is a sphere at 360. The range is 1-360 degrees.
  /// * [hTheta] : The angle of how far to generate in the longitude direction. It is a sphere at 180. The range is 1-180 degrees.
  ///
  /// Returns 3d sphere vertex. e.g. The coordinates are [lon1*lat1, lon1*lat2, lon2*lat1..., top, bottom].
  static List<Sp3dV3D> _sphereV3d(
      double r, int xFragments, int yFragments, double wTheta, double hTheta) {
    final Sp3dV3D bottom = Sp3dV3D(0, -r, 0);
    final Sp3dV3D top = Sp3dV3D(0, r, 0);
    List<Sp3dV3D> vertices = [];
    // 回転軸
    final Sp3dV3D longitudeAxis = Sp3dV3D(1, 0, 0);
    final Sp3dV3D latitudeAxis = Sp3dV3D(0, -1, 0);
    // 回転角
    final double rotateH = (hTheta / yFragments) * _toRadian;
    final double rotateW = (wTheta / xFragments) * _toRadian * -1;
    for (int i = 1; i < yFragments; i++) {
      Sp3dV3D p = top.deepCopy();
      p.rotate(longitudeAxis, rotateH * i);
      for (int j = 0; j <= xFragments; j++) {
        vertices.add(p.rotated(latitudeAxis, rotateW * j));
      }
    }
    vertices.add(top);
    vertices.add(bottom);
    return vertices;
  }

  /// (en)Generates a sphere centered on the (0,0,0) point.
  /// This approximates a circle with a triangle, not a true circle.
  /// Even at 360 degrees, the start and end points of the circumference are not connected.
  /// If you want to rotate this, use the function of Sp3dObj.
  ///
  /// (ja)(0,0,0)点を中心とした球を生成します。
  /// これは真の円ではなく、三角形で円を近似します。
  /// 360度の場合でも、円周の始点と終点はつながっていません。
  /// 回転したい場合はSp3dObjの機能を使用してください。
  ///
  /// * [r] : radius.
  /// * [xFragments] : split of sphere surface x axis.
  /// * [yFragments] : split of sphere surface y axis.
  /// * [wTheta] : The angle of how much to generate in the latitude direction. It is a sphere at 360. The range is 1-360 degrees.
  /// * [hTheta] : The angle of how far to generate in the longitude direction. It is a sphere at 180. The range is 1-180 degrees. When lowered, it becomes a shape close to a cone.
  /// * [isClosed] : If true, close the side. otherwise open.
  /// * [material] : face material
  ///
  /// Returns 3d sphere obj. e.g. The coordinates are [top, lon1*lat1, lon1*lat2, lon2*lat1..., bottom].
  /// When closing, the vertices of the divided lines passing through the center are added.
  static Sp3dObj sphere(double r,
      {int xFragments = 8,
      int yFragments = 8,
      double wTheta = 360,
      double hTheta = 180,
      bool isClosed = true,
      Sp3dMaterial? material}) {
    final List<Sp3dV3D> vertices =
        _sphereV3d(r, xFragments, yFragments, wTheta, hTheta);
    final List<int> indexes = _getIndexes(vertices, 0);
    List<Sp3dFragment> frags = [];
    // 上の頂点
    List<Sp3dFace> faces = [];
    int topIndex = indexes[indexes.length - 2];
    for (int j = 0; j < xFragments; j++) {
      faces.add(Sp3dFace([topIndex, indexes[j], indexes[(j + 1)]], 0));
    }
    // 中間のFace
    // 点の間がx個で、点は+1個ある。
    int dot = xFragments + 1;
    for (int i = 0; i < yFragments - 2; i++) {
      int hIndex = i * dot;
      int hnIndex = (i + 1) * dot;
      for (int j = 0; j < xFragments; j++) {
        int lt = hIndex + j;
        int lb = hnIndex + j;
        int rb = lb + 1;
        int rt = lt + 1;
        faces.add(Sp3dFace([
          indexes[lt],
          indexes[lb],
          indexes[rb],
          indexes[rt],
        ], 0));
      }
    }
    // 下の頂点
    int bottomIndex = indexes[indexes.length - 1];
    int bottomBase = indexes.length - 3 - xFragments;
    for (int j = 0; j < xFragments; j++) {
      int now = bottomBase + j;
      faces.add(Sp3dFace([bottomIndex, indexes[now + 1], indexes[now]], 0));
    }
    // 閉じる場合
    if (isClosed) {
      // 中心を通る線を引く
      // 追加分のインデックス
      List<int> appended = [];
      for (int i = 0; i < yFragments - 1; i++) {
        vertices.add(vertices[i * dot].deepCopy()
          ..x = 0
          ..z = 0);
        indexes.add(vertices.length - 1);
        appended.add(indexes.last);
      }
      // 垂直方向毎に2面ずつ閉じる必要がある。また、上下の頂点部分のみ三角形。
      // 上
      faces.add(Sp3dFace([indexes[topIndex], appended[0], indexes[0]], 0));
      faces
          .add(Sp3dFace([indexes[topIndex], indexes[dot - 1], appended[0]], 0));
      // 中間
      for (int i = 0; i < yFragments - 2; i++) {
        int nowS = i * dot;
        int nextS = (i + 1) * dot;
        int nextLast = (i + 2) * dot - 1;
        faces.add(Sp3dFace(
            [appended[i], appended[i + 1], indexes[nextS], indexes[nowS]], 0));
        faces.add(Sp3dFace([
          appended[i],
          indexes[nextS - 1],
          indexes[nextLast],
          appended[i + 1]
        ], 0));
      }
      // 下
      faces.add(Sp3dFace([
        indexes[bottomIndex],
        indexes[dot * (yFragments - 2)],
        appended.last
      ], 0));
      faces.add(Sp3dFace([
        indexes[bottomIndex],
        appended.last,
        indexes[dot * (yFragments - 1) - 1]
      ], 0));
    }
    frags.add(Sp3dFragment(faces));
    return Sp3dObj(vertices, frags, [
      material ?? FSp3dMaterial.grey,
    ], []);
  }

  /// (en)Generates the coordinates of a capsule extending in the -y direction with respect to the (0,0,0) point.
  /// This approximates a circle with a triangle, not a true circle.
  /// If you want to rotate this, use the function of Sp3dObj.
  ///
  /// (ja)(0,0,0)点から-y方向に伸びたカプセルを生成します。
  /// これは真の円ではなく、三角形で円を近似します。
  /// 360度の場合でも、円周の始点と終点はつながっていません。
  ///
  /// * [r] : radius.
  /// * [length] : capsule length.
  /// * [xFragments] : split of sphere surface x axis.
  /// * [yFragments] : split of sphere surface y axis.
  /// * [wTheta] : The angle of how much to generate in the latitude direction. It is a sphere at 360. The range is 1-360 degrees.
  ///
  /// Returns 3d capsule vertex. e.g. The coordinates are [top of[lon1*lat1, lon1*lat2, lon2*lat1..., edge], end of[...]].
  static List<List<Sp3dV3D>> _capsuleV3d(
      double r, double length, int xFragments, int yFragments, double wTheta) {
    final Sp3dV3D top = Sp3dV3D(0, r, 0);
    List<Sp3dV3D> topVertices = [];
    // 回転軸
    final Sp3dV3D longitudeAxis = Sp3dV3D(1, 0, 0);
    final Sp3dV3D latitudeAxis = Sp3dV3D(0, -1, 0);
    // 回転角
    final double rotateH = (90 / yFragments) * _toRadian;
    final double rotateW = (wTheta / xFragments) * _toRadian * -1;
    for (int i = 1; i < yFragments; i++) {
      Sp3dV3D p = top.deepCopy();
      p.rotate(longitudeAxis, rotateH * i);
      for (int j = 0; j <= xFragments; j++) {
        topVertices.add(p.rotated(latitudeAxis, rotateW * j));
      }
    }
    topVertices.add(top);
    final Sp3dV3D rLongitudeAxis = Sp3dV3D(-1, 0, 0);
    final Sp3dV3D bottom = Sp3dV3D(0, -r, 0);
    List<Sp3dV3D> bottomVertices = [];
    for (int i = 1; i < yFragments; i++) {
      Sp3dV3D p = bottom.deepCopy();
      p.rotate(rLongitudeAxis, rotateH * i);
      for (int j = 0; j <= xFragments; j++) {
        bottomVertices.add(p.rotated(latitudeAxis, rotateW * j));
      }
    }
    bottomVertices.add(bottom);
    // 反転して指定距離分遠くにもう片方の半球を生成する
    final Sp3dV3D shiftZero = Sp3dV3D(0, -r, 0);
    final Sp3dV3D shiftLen = Sp3dV3D(0, r - length, 0);
    for (Sp3dV3D i in topVertices) {
      i.add(shiftZero);
    }
    for (Sp3dV3D i in bottomVertices) {
      i.add(shiftLen);
    }
    return [topVertices, bottomVertices];
  }

  /// (en)Generates a capsule extending in the z direction with respect the (0,0,0) point.
  /// This approximates a circle with a triangle, not a true circle.
  /// Even at 360 degrees, the start and end points of the circumference are not connected.
  ///
  /// (ja)(0,0,0)点を中心としてz方向に伸びたカプセルを生成します。
  /// これは真の円ではなく、三角形で円を近似します。
  /// 360度の場合でも、円周の始点と終点はつながっていません。
  ///
  /// * [r] : edge sphere radius.
  /// * [length] : capsule length.
  /// * [xFragments] : split of sphere surface x axis.
  /// * [yFragments] : split of sphere surface y axis.
  /// * [wTheta] : The angle of how much to generate in the latitude direction. It is a sphere at 360. The range is 1-360 degrees.
  /// * [isClosed] : If true, close the side. otherwise open.
  /// * [material] : face material
  ///
  /// Returns 3d capsule obj.
  /// When closing, the vertices of the divided lines passing through the center are added.
  static Sp3dObj capsule(double r, double length,
      {int xFragments = 8,
      int yFragments = 4,
      double wTheta = 360,
      bool isClosed = true,
      Sp3dMaterial? material}) {
    final List<List<Sp3dV3D>> edges =
        _capsuleV3d(r, length, xFragments, yFragments, wTheta);
    final List<Sp3dV3D> vertices = _serialize(edges);
    final List<int> indexes = _getIndexes(vertices, 0);
    final List<int> topIndexes = _getIndexes(edges[0], 0);
    final List<int> endIndexes = _getIndexes(edges[1], topIndexes.length);
    List<Sp3dFragment> frags = [];
    // 上の頂点
    List<Sp3dFace> faces = [];
    int topIndex = topIndexes[topIndexes.length - 1];
    for (int j = 0; j < xFragments; j++) {
      faces.add(Sp3dFace([topIndex, topIndexes[j], topIndexes[(j + 1)]], 0));
    }
    // 上のエッジFace
    // 点の間がx個で、点は+1個ある。
    int dot = xFragments + 1;
    for (int i = 0; i < yFragments - 2; i++) {
      int hIndex = i * dot;
      int hnIndex = (i + 1) * dot;
      for (int j = 0; j < xFragments; j++) {
        int lt = hIndex + j;
        int lb = hnIndex + j;
        int rb = lb + 1;
        int rt = lt + 1;
        faces.add(Sp3dFace([
          topIndexes[lt],
          topIndexes[lb],
          topIndexes[rb],
          topIndexes[rt],
        ], 0));
      }
    }
    // 下の頂点
    int endIndex = endIndexes[endIndexes.length - 1];
    for (int j = 0; j < xFragments; j++) {
      faces.add(Sp3dFace([endIndex, endIndexes[(j + 1)], endIndexes[j]], 0));
    }
    // 下のエッジFace
    for (int i = 0; i < yFragments - 2; i++) {
      int hIndex = i * dot;
      int hnIndex = (i + 1) * dot;
      for (int j = 0; j < xFragments; j++) {
        int lt = hIndex + j;
        int lb = hnIndex + j;
        int rb = lb + 1;
        int rt = lt + 1;
        faces.add(Sp3dFace([
          endIndexes[rt],
          endIndexes[rb],
          endIndexes[lb],
          endIndexes[lt],
        ], 0));
      }
    }
    // 下と上のエッジを繋ぐ
    int hnIndex = (yFragments - 2) * dot;
    for (int j = 0; j < xFragments; j++) {
      int lb = hnIndex + j;
      int rb = lb + 1;
      faces.add(Sp3dFace([
        topIndexes[lb],
        endIndexes[lb],
        endIndexes[rb],
        topIndexes[rb],
      ], 0));
    }
    // 閉じる場合
    if (isClosed) {
      // 中心を通る線を引く
      // 追加分のインデックス
      List<int> topAppended = [];
      List<int> endAppended = [];
      for (int i = 0; i < yFragments - 1; i++) {
        vertices.add(vertices[topIndexes[i * dot]].deepCopy()
          ..x = 0
          ..z = 0);
        topIndexes.add(vertices.length - 1);
        indexes.add(topIndexes.last);
        topAppended.add(indexes.last);
      }
      for (int i = 0; i < yFragments - 1; i++) {
        vertices.add(vertices[endIndexes[i * dot]].deepCopy()
          ..x = 0
          ..z = 0);
        topIndexes.add(vertices.length - 1);
        indexes.add(topIndexes.last);
        endAppended.add(indexes.last);
      }
      // 垂直方向毎に2面ずつ閉じる必要がある。また、上下の頂点部分のみ三角形。
      // 上
      faces
          .add(Sp3dFace([indexes[topIndex], topAppended[0], topIndexes[0]], 0));
      faces.add(Sp3dFace(
          [indexes[topIndex], topIndexes[dot - 1], topAppended[0]], 0));
      for (int i = 0; i < yFragments - 2; i++) {
        int nowS = i * dot;
        int nextS = (i + 1) * dot;
        int nextLast = (i + 2) * dot - 1;
        faces.add(Sp3dFace([
          topAppended[i],
          topAppended[i + 1],
          topIndexes[nextS],
          topIndexes[nowS]
        ], 0));
        faces.add(Sp3dFace([
          topAppended[i],
          topIndexes[nextS - 1],
          topIndexes[nextLast],
          topAppended[i + 1]
        ], 0));
      }
      // 下
      faces
          .add(Sp3dFace([indexes[endIndex], endIndexes[0], endAppended[0]], 0));
      faces.add(Sp3dFace(
          [indexes[endIndex], endAppended[0], endIndexes[dot - 1]], 0));
      for (int i = 0; i < yFragments - 2; i++) {
        int nowS = i * dot;
        int nextS = (i + 1) * dot;
        int nextLast = (i + 2) * dot - 1;
        faces.add(Sp3dFace([
          endIndexes[nowS],
          endIndexes[nextS],
          endAppended[i + 1],
          endAppended[i]
        ], 0));
        faces.add(Sp3dFace([
          endAppended[i + 1],
          endIndexes[nextLast],
          endIndexes[nextS - 1],
          endAppended[i],
        ], 0));
      }
      // 下と上の接続部分
      faces.add(Sp3dFace([
        topAppended.last,
        endAppended.last,
        endIndexes[endIndexes.length - 1 - dot],
        topIndexes[(yFragments - 2) * dot],
      ], 0));
      faces.add(Sp3dFace([
        topAppended.last,
        topIndexes[(yFragments - 1) * dot - 1],
        endIndexes[(yFragments - 1) * dot - 1],
        endAppended.last,
      ], 0));
    }
    frags.add(Sp3dFragment(faces));
    return Sp3dObj(vertices, frags, [
      material ?? FSp3dMaterial.grey,
    ], []);
  }
}

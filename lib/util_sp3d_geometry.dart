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
class Util_Sp3dGeometry {
  static final double _to_radian = pi / 180;

  /// (en)Creates and returns a list of list indexes.
  ///
  /// (ja)リストのインデックスのリストを作成して返します。
  ///
  /// * [base_index] : The value to add to the index.
  static List<int> _get_indexes(List<dynamic> l, int base_index) {
    List<int> r = [];
    for (int i = 0; i < l.length; i++) {
      r.add(i + base_index);
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
  /// * [w_split] : Number of divisions in the width direction. Must be 1 or more.
  /// * [h_split] : Number of divisions in the height direction. Must be 1 or more.
  ///
  /// Returns 3d tile vertices. [[tiles of horizontal...] tiles of vertical...].
  static List<List<Sp3dV3D>> _tile_v3d(
      double w, double h, int w_split, int h_split) {
    final double start = -w / 2;
    final double bottom = -h / 2;
    final double w_add = w / w_split;
    final double end_base = start + w_add;
    final double h_add = h / h_split;
    final double top_base = bottom + h_add;
    List<double> start_list = [];
    List<double> end_list = [];
    List<double> top_list = [];
    List<double> bottom_list = [];
    for (int i = 0; i < w_split; i++) {
      double p = i * w_add;
      start_list.add(start + p);
      end_list.add(end_base + p);
    }
    for (int i = 0; i < h_split; i++) {
      double p = i * h_add;
      bottom_list.add(bottom + p);
      top_list.add(top_base + p);
    }
    List<List<Sp3dV3D>> r = [];
    for (int i = 0; i < h_split; i++) {
      for (int j = 0; j < w_split; j++) {
        r.add([
          Sp3dV3D(start_list[j], top_list[i], 0), // lt
          Sp3dV3D(start_list[j], bottom_list[i], 0), // lb
          Sp3dV3D(end_list[j], bottom_list[i], 0), // rb
          Sp3dV3D(end_list[j], top_list[i], 0) // rt
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
  /// * [w_split] : Number of divisions in the width direction. Must be 1 or more.
  /// * [h_split] : Number of divisions in the height direction. Must be 1 or more.
  /// * [material] : face material
  ///
  /// Returns 3d tile obj.
  static Sp3dObj tile(
      double w, double h, int w_split, int h_split, {Sp3dMaterial? material}) {
    List<List<Sp3dV3D>> tile = _tile_v3d(w, h, w_split, h_split);
    List<Sp3dV3D> serialized = _serialize(tile);
    List<Sp3dFragment> fragments = [];
    int count = 0;
    for (List<Sp3dV3D> face in tile) {
      fragments.add(Sp3dFragment(
          false, [Sp3dFace(_get_indexes(face, count), 0)], 0, null));
      count += face.length;
    }
    return Sp3dObj(
        "none",
        "none",
        serialized,
        fragments,
        [
          material != null ? material : F_Sp3dMaterial.grey,
        ],
        [],
        null);
  }

  /// (en)Generates the coordinates of a rectangular parallelepiped extending in the z direction with respect the (0,0,0) point.
  ///
  /// (ja)(0,0,0)点を底面の中心とした直方体の座標を生成します。
  ///
  /// * [w] : width.
  /// * [h] : height.
  /// * [d] : depth.
  /// * [w_split] : Number of divisions in the width direction. Must be 1 or more.
  /// * [h_split] : Number of divisions in the height direction. Must be 1 or more.
  /// * [d_split] : Number of divisions in the depth direction. Must be 1 or more.
  ///
  /// Returns 3d cube vertices. [[horizontal of front1,2,3,4,back1,2,3,4] vertical of ...].
  static List<List<Sp3dV3D>> _cube_v3d(
      double w, double h, double d, int w_split, int h_split, int d_split) {
    List<List<Sp3dV3D>> r = [];
    List<List<Sp3dV3D>> front_tile = _tile_v3d(w, h, w_split, h_split);
    Sp3dV3D to_front = Sp3dV3D(0, 0, d);
    for (List<Sp3dV3D> i in front_tile) {
      for (Sp3dV3D j in i) {
        j.add(to_front);
      }
    }
    // 刻み幅
    Sp3dV3D splited_d = Sp3dV3D(0, 0, -d / d_split);
    // z軸で手前から奥へ向けてマッピング。
    for (int z = 0; z < d_split; z++) {
      for (List<Sp3dV3D> tile in front_tile) {
        List<Sp3dV3D> cube_v = [];
        // front 4 vertex
        for (Sp3dV3D t in tile) {
          cube_v.add(t + (splited_d * z));
        }
        // back 4 vertex
        for (Sp3dV3D t in tile.reversed) {
          cube_v.add(t + (splited_d * (z + 1)));
        }
        r.add(cube_v);
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
  /// * [w_split] : Number of divisions in the width direction. Must be 1 or more.
  /// * [h_split] : Number of divisions in the height direction. Must be 1 or more.
  /// * [d_split] : Number of divisions in the depth direction. Must be 1 or more.
  /// * [material] : face material
  ///
  /// Returns 3d cube obj.
  static Sp3dObj cube(double w, double h, double d, int w_split, int h_split,
      int d_split, {Sp3dMaterial? material}) {
    List<List<Sp3dV3D>> c = _cube_v3d(w, h, d, w_split, h_split, d_split);
    List<Sp3dV3D> serialized = _serialize(c);
    List<Sp3dFragment> fragments = [];
    int count = 0;
    for (List<Sp3dV3D> v in c) {
      List<int> i = _get_indexes(v, count);
      List<Sp3dFace> faces = [
        Sp3dFace([i[0], i[1], i[2], i[3]], 0), // front
        Sp3dFace([i[4], i[5], i[6], i[7]], 0), // back
        Sp3dFace([i[7], i[0], i[3], i[4]], 0), // top
        Sp3dFace([i[7], i[6], i[1], i[0]], 0), // left
        Sp3dFace([i[5], i[2], i[1], i[6]], 0), // bottom
        Sp3dFace([i[3], i[2], i[5], i[4]], 0), // right
      ];
      fragments.add(Sp3dFragment(false, faces, 0, null));
      count += i.length;
    }
    return Sp3dObj(
        "none",
        "none",
        serialized,
        fragments,
        [
          material != null ? material : F_Sp3dMaterial.grey,
        ],
        [],
        null);
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
  static List<Sp3dV3D> _circle_v3d(double r, int fragments,
      {double theta = 360}) {
    // 回転角（逆時計周り）
    final double radian = theta / fragments * _to_radian;
    // 始点から終点への軸ベクトルを考える。
    Sp3dV3D nor_axis = Sp3dV3D(0, 0, 1);
    // 半径rの回転ベクトル
    List<Sp3dV3D> c = [Sp3dV3D(r, 0, 0)];
    for (int i = 0; i < fragments; i++) {
      c.add(c.last.rotated(nor_axis, radian));
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
    List<Sp3dV3D> serialized = _circle_v3d(r, fragments, theta: theta);
    List<int> indexes = _get_indexes(serialized, 0);
    List<Sp3dFragment> mfragments = [];
    final int last_index = indexes.length - 1;
    for (int i = 0; i < fragments; i++) {
      List<Sp3dFace> faces = [
        Sp3dFace([indexes[last_index], indexes[i], indexes[(i + 1)]], 0)
      ];
      mfragments.add(Sp3dFragment(false, faces, 0, null));
    }
    return Sp3dObj(
        "none",
        "none",
        serialized,
        mfragments,
        [
          material != null ? material : F_Sp3dMaterial.grey,
        ],
        [],
        null);
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
  /// * [is_closed_bottom] : If true, close bottom. otherwise open.
  /// * [is_closed_side] : If true, close the side on the start point side and the side on the end point side. otherwise open.
  /// * [material] : face material
  ///
  /// Returns 3d cone obj.
  static Sp3dObj cone(double r, double h,
      {int fragments = 8,
        double theta = 360,
        bool is_closed_bottom = true,
        bool is_closed_side = true,
        Sp3dMaterial? material}) {
    List<Sp3dV3D> serialized = _circle_v3d(r, fragments, theta: theta);
    List<int> indexes = _get_indexes(serialized, 0);
    // 頂点を追加（底面は追加済み）
    serialized.add(Sp3dV3D(0, 0, h));
    List<Sp3dFragment> mfragments = [];
    final int bottom_index = serialized.length - 2;
    final int top_index = serialized.length - 1;
    indexes.add(top_index);
    for (int i = 0; i < fragments; i++) {
      // 底面
      if (is_closed_bottom) {
        List<Sp3dFace> bottom_faces = [
          Sp3dFace([indexes[bottom_index], indexes[(i + 1)], indexes[i]], 0)
        ];
        mfragments.add(Sp3dFragment(false, bottom_faces, 0, null));
      }
      // 頂点
      List<Sp3dFace> top_faces = [
        Sp3dFace([indexes[top_index], indexes[i], indexes[(i + 1)]], 0)
      ];
      mfragments.add(Sp3dFragment(false, top_faces, 0, null));
    }
    // 始点側と終点側の側面を閉じる。
    if (is_closed_side) {
      List<Sp3dFace> sp_faces = [
        Sp3dFace([indexes[top_index], indexes[bottom_index], indexes[0]], 0)
      ];
      mfragments.add(Sp3dFragment(false, sp_faces, 0, null));
      List<Sp3dFace> ep_faces = [
        Sp3dFace([
          indexes[top_index],
          indexes[bottom_index - 1],
          indexes[bottom_index]
        ], 0)
      ];
      mfragments.add(Sp3dFragment(false, ep_faces, 0, null));
    }
    return Sp3dObj(
        "none",
        "none",
        serialized,
        mfragments,
        [
          material != null ? material : F_Sp3dMaterial.grey,
        ],
        [],
        null);
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
  /// * [top_r] : top circle radius.
  /// * [bottom_r] : bottom circle radius.
  /// * [h] : height.
  /// * [fragments] : The number of triangles that make up a circle. The more it is, the smoother it becomes.
  /// Divide the area for the angle specified by theta by this number of triangles.
  /// * [theta] : 360 for a circle. 180 for a semicircle. The range is 1-360 degrees.
  /// * [is_closed_bottom] : If true, close bottom. otherwise open.
  /// * [is_closed_top] : If true, close top. otherwise open.
  /// * [is_closed_side] : If true, close the side on the start point side and the side on the end point side. otherwise open.
  /// * [material] : face material
  ///
  /// Returns 3d pillar obj.
  static Sp3dObj pillar(
      double top_r, double bottom_r, double h,
      {int fragments = 8,
        double theta = 360,
        bool is_closed_bottom = true,
        bool is_closed_top = true,
        bool is_closed_side = true,
        Sp3dMaterial? material}) {
    List<Sp3dV3D> btm = _circle_v3d(bottom_r, fragments, theta: theta);
    final int bottom_index = btm.length - 1;
    final int top_start = btm.length;
    List<Sp3dV3D> top = _circle_v3d(top_r, fragments, theta: theta);
    Sp3dV3D add_h = Sp3dV3D(0, 0, h);
    for (Sp3dV3D i in top) {
      i.add(add_h);
    }
    btm.addAll(top);
    List<int> indexes = _get_indexes(btm, 0);
    int top_index = indexes.length - 1;
    List<Sp3dFragment> mfragments = [];
    for (int i = 0; i < fragments; i++) {
      // 底面
      if (is_closed_bottom) {
        List<Sp3dFace> bottom_faces = [
          Sp3dFace([indexes[bottom_index], indexes[(i + 1)], indexes[i]], 0)
        ];
        mfragments.add(Sp3dFragment(false, bottom_faces, 0, null));
      }
      // 壁面
      int top_i = i + top_start;
      List<Sp3dFace> wall_faces = [
        Sp3dFace([
          indexes[top_i],
          indexes[i],
          indexes[(i + 1)],
          indexes[(top_i + 1)]
        ], 0)
      ];
      mfragments.add(Sp3dFragment(false, wall_faces, 0, null));
      // 頂点
      if (is_closed_top) {
        List<Sp3dFace> top_faces = [
          Sp3dFace(
              [indexes[top_index], indexes[top_i], indexes[(top_i + 1)]], 0)
        ];
        mfragments.add(Sp3dFragment(false, top_faces, 0, null));
      }
    }
    // 始点側と終点側の側面を閉じる。
    if (is_closed_side) {
      List<Sp3dFace> sp_faces = [
        Sp3dFace([
          indexes[top_index],
          indexes[bottom_index],
          indexes[0],
          indexes[top_start]
        ], 0)
      ];
      mfragments.add(Sp3dFragment(false, sp_faces, 0, null));
      List<Sp3dFace> ep_faces = [
        Sp3dFace([
          indexes[top_index],
          indexes[indexes.length - 2],
          indexes[bottom_index - 1],
          indexes[bottom_index]
        ], 0)
      ];
      mfragments.add(Sp3dFragment(false, ep_faces, 0, null));
    }
    return Sp3dObj(
        "none",
        "none",
        btm,
        mfragments,
        [
          material != null ? material : F_Sp3dMaterial.grey,
        ],
        [],
        null);
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
  /// * [x_fragments] : split of sphere surface x axis.
  /// * [y_fragments] : split of sphere surface y axis.
  /// * [w_theta] : The angle of how much to generate in the latitude direction. It is a sphere at 360. The range is 1-360 degrees.
  /// * [h_theta] : The angle of how far to generate in the longitude direction. It is a sphere at 180. The range is 1-180 degrees.
  ///
  /// Returns 3d sphere vertex. e.g. The coordinates are [lon1*lat1, lon1*lat2, lon2*lat1..., top, bottom].
  static List<Sp3dV3D> _sphere_v3d(double r, int x_fragments, int y_fragments,
      double w_theta, double h_theta) {
    final Sp3dV3D bottom = Sp3dV3D(0, -r, 0);
    final Sp3dV3D top = Sp3dV3D(0, r, 0);
    List<Sp3dV3D> vertices = [];
    // 回転軸
    final Sp3dV3D longitude_axis = Sp3dV3D(1, 0, 0);
    final Sp3dV3D latitude_axis = Sp3dV3D(0, -1, 0);
    // 回転角
    final double rotate_h = (h_theta / y_fragments) * _to_radian;
    final double rotate_w = (w_theta / x_fragments) * _to_radian * -1;
    for (int i = 1; i < y_fragments; i++) {
      Sp3dV3D p = top.deep_copy();
      p.rotate(longitude_axis, rotate_h * i);
      for (int j = 0; j <= x_fragments; j++) {
        vertices.add(p.rotated(latitude_axis, rotate_w * j));
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
  /// * [x_fragments] : split of sphere surface x axis.
  /// * [y_fragments] : split of sphere surface y axis.
  /// * [w_theta] : The angle of how much to generate in the latitude direction. It is a sphere at 360. The range is 1-360 degrees.
  /// * [h_theta] : The angle of how far to generate in the longitude direction. It is a sphere at 180. The range is 1-180 degrees. When lowered, it becomes a shape close to a cone.
  /// * [is_closed] : If true, close the side. otherwise open.
  /// * [material] : face material
  ///
  /// Returns 3d sphere obj. e.g. The coordinates are [top, lon1*lat1, lon1*lat2, lon2*lat1..., bottom].
  /// When closing, the vertices of the divided lines passing through the center are added.
  static Sp3dObj sphere(double r,
      {int x_fragments = 8,
        int y_fragments = 8,
        double w_theta = 360,
        double h_theta = 180,
        bool is_closed = true,
        Sp3dMaterial? material}) {
    final List<Sp3dV3D> vertices =
    _sphere_v3d(r, x_fragments, y_fragments, w_theta, h_theta);
    final List<int> indexes = _get_indexes(vertices, 0);
    List<Sp3dFragment> frags = [];
    // 上の頂点
    List<Sp3dFace> faces = [];
    int top_index = indexes[indexes.length - 2];
    for (int j = 0; j < x_fragments; j++) {
      faces.add(Sp3dFace([top_index, indexes[j], indexes[(j + 1)]], 0));
    }
    // 中間のFace
    // 点の間がx個で、点は+1個ある。
    int dot = x_fragments + 1;
    for (int i = 0; i < y_fragments - 2; i++) {
      int h_index = i * dot;
      int hn_index = (i + 1) * dot;
      for (int j = 0; j < x_fragments; j++) {
        int lt = h_index + j;
        int lb = hn_index + j;
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
    int bottom_index = indexes[indexes.length - 1];
    int bottom_base = indexes.length - 3 - x_fragments;
    for (int j = 0; j < x_fragments; j++) {
      int now = bottom_base + j;
      faces.add(Sp3dFace([bottom_index, indexes[now + 1], indexes[now]], 0));
    }
    // 閉じる場合
    if (is_closed) {
      // 中心を通る線を引く
      // 追加分のインデックス
      List<int> appended = [];
      for (int i = 0; i < y_fragments - 1; i++) {
        vertices.add(vertices[i * dot].deep_copy()
          ..x = 0
          ..z = 0);
        indexes.add(vertices.length - 1);
        appended.add(indexes.last);
      }
      // 垂直方向毎に2面ずつ閉じる必要がある。また、上下の頂点部分のみ三角形。
      // 上
      faces.add(Sp3dFace([indexes[top_index], appended[0], indexes[0]], 0));
      faces.add(
          Sp3dFace([indexes[top_index], indexes[dot - 1], appended[0]], 0));
      // 中間
      for (int i = 0; i < y_fragments - 2; i++) {
        int now_s = i * dot;
        int next_s = (i + 1) * dot;
        int next_last = (i + 2) * dot - 1;
        faces.add(Sp3dFace(
            [appended[i], appended[i + 1], indexes[next_s], indexes[now_s]],
            0));
        faces.add(Sp3dFace([
          appended[i],
          indexes[next_s - 1],
          indexes[next_last],
          appended[i + 1]
        ], 0));
      }
      // 下
      faces.add(Sp3dFace([
        indexes[bottom_index],
        indexes[dot * (y_fragments - 2)],
        appended.last
      ], 0));
      faces.add(Sp3dFace([
        indexes[bottom_index],
        appended.last,
        indexes[dot * (y_fragments - 1) - 1]
      ], 0));
    }
    frags.add(Sp3dFragment(false, faces, 0, null));
    return Sp3dObj(
        "none",
        "none",
        vertices,
        frags,
        [
          material != null ? material : F_Sp3dMaterial.grey,
        ],
        [],
        null);
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
  /// * [x_fragments] : split of sphere surface x axis.
  /// * [y_fragments] : split of sphere surface y axis.
  /// * [w_theta] : The angle of how much to generate in the latitude direction. It is a sphere at 360. The range is 1-360 degrees.
  ///
  /// Returns 3d capsule vertex. e.g. The coordinates are [top of[lon1*lat1, lon1*lat2, lon2*lat1..., edge], end of[...]].
  static List<List<Sp3dV3D>> _capsule_v3d(double r, double length,
      int x_fragments, int y_fragments, double w_theta) {
    final Sp3dV3D top = Sp3dV3D(0, r, 0);
    List<Sp3dV3D> top_vertices = [];
    // 回転軸
    final Sp3dV3D longitude_axis = Sp3dV3D(1, 0, 0);
    final Sp3dV3D latitude_axis = Sp3dV3D(0, -1, 0);
    // 回転角
    final double rotate_h = (90 / y_fragments) * _to_radian;
    final double rotate_w = (w_theta / x_fragments) * _to_radian * -1;
    for (int i = 1; i < y_fragments; i++) {
      Sp3dV3D p = top.deep_copy();
      p.rotate(longitude_axis, rotate_h * i);
      for (int j = 0; j <= x_fragments; j++) {
        top_vertices.add(p.rotated(latitude_axis, rotate_w * j));
      }
    }
    top_vertices.add(top);
    final Sp3dV3D r_longitude_axis = Sp3dV3D(-1, 0, 0);
    final Sp3dV3D bottom = Sp3dV3D(0, -r, 0);
    List<Sp3dV3D> bottom_vertices = [];
    for (int i = 1; i < y_fragments; i++) {
      Sp3dV3D p = bottom.deep_copy();
      p.rotate(r_longitude_axis, rotate_h * i);
      for (int j = 0; j <= x_fragments; j++) {
        bottom_vertices.add(p.rotated(latitude_axis, rotate_w * j));
      }
    }
    bottom_vertices.add(bottom);
    // 反転して指定距離分遠くにもう片方の半球を生成する
    final Sp3dV3D shift_zero = Sp3dV3D(0, -r, 0);
    final Sp3dV3D shift_len = Sp3dV3D(0, r - length, 0);
    for (Sp3dV3D i in top_vertices) {
      i.add(shift_zero);
    }
    for (Sp3dV3D i in bottom_vertices) {
      i.add(shift_len);
    }
    return [top_vertices, bottom_vertices];
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
  /// * [x_fragments] : split of sphere surface x axis.
  /// * [y_fragments] : split of sphere surface y axis.
  /// * [w_theta] : The angle of how much to generate in the latitude direction. It is a sphere at 360. The range is 1-360 degrees.
  /// * [is_closed] : If true, close the side. otherwise open.
  /// * [material] : face material
  ///
  /// Returns 3d capsule obj.
  /// When closing, the vertices of the divided lines passing through the center are added.
  static Sp3dObj capsule(double r, double length,
      {int x_fragments = 8,
        int y_fragments = 4,
        double w_theta = 360,
        bool is_closed = true,
        Sp3dMaterial? material}) {
    final List<List<Sp3dV3D>> edges =
    _capsule_v3d(r, length, x_fragments, y_fragments, w_theta);
    final List<Sp3dV3D> vertices = _serialize(edges);
    final List<int> indexes = _get_indexes(vertices, 0);
    final List<int> top_indexes = _get_indexes(edges[0], 0);
    final List<int> end_indexes = _get_indexes(edges[1], top_indexes.length);
    List<Sp3dFragment> frags = [];
    // 上の頂点
    List<Sp3dFace> faces = [];
    int top_index = top_indexes[top_indexes.length - 1];
    for (int j = 0; j < x_fragments; j++) {
      faces.add(Sp3dFace([top_index, top_indexes[j], top_indexes[(j + 1)]], 0));
    }
    // 上のエッジFace
    // 点の間がx個で、点は+1個ある。
    int dot = x_fragments + 1;
    for (int i = 0; i < y_fragments - 2; i++) {
      int h_index = i * dot;
      int hn_index = (i + 1) * dot;
      for (int j = 0; j < x_fragments; j++) {
        int lt = h_index + j;
        int lb = hn_index + j;
        int rb = lb + 1;
        int rt = lt + 1;
        faces.add(Sp3dFace([
          top_indexes[lt],
          top_indexes[lb],
          top_indexes[rb],
          top_indexes[rt],
        ], 0));
      }
    }
    // 下の頂点
    int end_index = end_indexes[end_indexes.length - 1];
    for (int j = 0; j < x_fragments; j++) {
      faces.add(Sp3dFace([end_index, end_indexes[(j + 1)], end_indexes[j]], 0));
    }
    // 下のエッジFace
    for (int i = 0; i < y_fragments - 2; i++) {
      int h_index = i * dot;
      int hn_index = (i + 1) * dot;
      for (int j = 0; j < x_fragments; j++) {
        int lt = h_index + j;
        int lb = hn_index + j;
        int rb = lb + 1;
        int rt = lt + 1;
        faces.add(Sp3dFace([
          end_indexes[rt],
          end_indexes[rb],
          end_indexes[lb],
          end_indexes[lt],
        ], 0));
      }
    }
    // 下と上のエッジを繋ぐ
    int hn_index = (y_fragments - 2) * dot;
    for (int j = 0; j < x_fragments; j++) {
      int lb = hn_index + j;
      int rb = lb + 1;
      faces.add(Sp3dFace([
        top_indexes[lb],
        end_indexes[lb],
        end_indexes[rb],
        top_indexes[rb],
      ], 0));
    }
    // 閉じる場合
    if (is_closed) {
      // 中心を通る線を引く
      // 追加分のインデックス
      List<int> top_appended = [];
      List<int> end_appended = [];
      for (int i = 0; i < y_fragments - 1; i++) {
        vertices.add(vertices[top_indexes[i * dot]].deep_copy()
          ..x = 0
          ..z = 0);
        top_indexes.add(vertices.length - 1);
        indexes.add(top_indexes.last);
        top_appended.add(indexes.last);
      }
      for (int i = 0; i < y_fragments - 1; i++) {
        vertices.add(vertices[end_indexes[i * dot]].deep_copy()
          ..x = 0
          ..z = 0);
        top_indexes.add(vertices.length - 1);
        indexes.add(top_indexes.last);
        end_appended.add(indexes.last);
      }
      // 垂直方向毎に2面ずつ閉じる必要がある。また、上下の頂点部分のみ三角形。
      // 上
      faces.add(
          Sp3dFace([indexes[top_index], top_appended[0], top_indexes[0]], 0));
      faces.add(Sp3dFace(
          [indexes[top_index], top_indexes[dot - 1], top_appended[0]], 0));
      for (int i = 0; i < y_fragments - 2; i++) {
        int now_s = i * dot;
        int next_s = (i + 1) * dot;
        int next_last = (i + 2) * dot - 1;
        faces.add(Sp3dFace([
          top_appended[i],
          top_appended[i + 1],
          top_indexes[next_s],
          top_indexes[now_s]
        ], 0));
        faces.add(Sp3dFace([
          top_appended[i],
          top_indexes[next_s - 1],
          top_indexes[next_last],
          top_appended[i + 1]
        ], 0));
      }
      // 下
      faces.add(
          Sp3dFace([indexes[end_index], end_indexes[0], end_appended[0]], 0));
      faces.add(Sp3dFace(
          [indexes[end_index], end_appended[0], end_indexes[dot - 1]], 0));
      for (int i = 0; i < y_fragments - 2; i++) {
        int now_s = i * dot;
        int next_s = (i + 1) * dot;
        int next_last = (i + 2) * dot - 1;
        faces.add(Sp3dFace([
          end_indexes[now_s],
          end_indexes[next_s],
          end_appended[i + 1],
          end_appended[i]
        ], 0));
        faces.add(Sp3dFace([
          end_appended[i + 1],
          end_indexes[next_last],
          end_indexes[next_s - 1],
          end_appended[i],
        ], 0));
      }
      // 下と上の接続部分
      faces.add(Sp3dFace([
        top_appended.last,
        end_appended.last,
        end_indexes[end_indexes.length - 1 - dot],
        top_indexes[(y_fragments - 2) * dot],
      ], 0));
      faces.add(Sp3dFace([
        top_appended.last,
        top_indexes[(y_fragments - 1) * dot - 1],
        end_indexes[(y_fragments - 1) * dot - 1],
        end_appended.last,
      ], 0));
    }
    frags.add(Sp3dFragment(false, faces, 0, null));
    return Sp3dObj(
        "none",
        "none",
        vertices,
        frags,
        [
          material != null ? material : F_Sp3dMaterial.grey,
        ],
        [],
        null);
  }

}

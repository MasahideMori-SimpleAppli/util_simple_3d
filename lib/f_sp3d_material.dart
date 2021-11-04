import 'dart:ui';
import 'package:simple_3d/simple_3d.dart';


/// (en)This class statically stores the default set of Sp3dMaterial that is often used.
/// (ja)Sp3dMaterialのよく使うデフォルトセットを静的に格納したクラスです。
///
/// Author Masahide Mori
///
/// First edition creation date 2021-09-04 19:46:20
///
class F_Sp3dMaterial {

  static final Sp3dMaterial red = Sp3dMaterial(Color.fromARGB(255, 255, 0, 0), true, 1,
      Color.fromARGB(255, 255, 0, 0));

  static final Sp3dMaterial red_wire = Sp3dMaterial(Color.fromARGB(255, 255, 0, 0), false, 1,
      Color.fromARGB(255, 255, 0, 0));

  static final Sp3dMaterial green = Sp3dMaterial(Color.fromARGB(255, 0, 255, 0), true, 1,
      Color.fromARGB(255, 0, 255, 0));

  static final Sp3dMaterial green_wire = Sp3dMaterial(Color.fromARGB(255, 0, 255, 0), false, 1,
      Color.fromARGB(255, 0, 255, 0));

  static final Sp3dMaterial blue = Sp3dMaterial(Color.fromARGB(255, 0, 0, 255), true, 1,
      Color.fromARGB(255, 0, 0, 255));

  static final Sp3dMaterial blue_wire = Sp3dMaterial(Color.fromARGB(255, 0, 0, 255), false, 1,
      Color.fromARGB(255, 0, 0, 255));

  static final Sp3dMaterial grey = Sp3dMaterial(Color.fromARGB(255, 224, 224, 224), true, 1,
      Color.fromARGB(255, 224, 224, 224));

  static final Sp3dMaterial grey_wire = Sp3dMaterial(Color.fromARGB(255, 224, 224, 224), false, 1,
      Color.fromARGB(255, 224, 224, 224));

  static final Sp3dMaterial white = Sp3dMaterial(Color.fromARGB(255, 255, 255, 255), true, 1,
      Color.fromARGB(255, 255, 255, 255));

  static final Sp3dMaterial white_wire = Sp3dMaterial(Color.fromARGB(255, 255, 255, 255), false, 1,
      Color.fromARGB(255, 255, 255, 255));

  static final Sp3dMaterial black = Sp3dMaterial(Color.fromARGB(255, 0, 0, 0), true, 1,
      Color.fromARGB(255, 0, 0, 0));

  static final Sp3dMaterial black_wire = Sp3dMaterial(Color.fromARGB(255, 0, 0, 0), false, 1,
      Color.fromARGB(255, 0, 0, 0));

}

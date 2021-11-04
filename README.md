# util_simple_3d

(en)The explanation is in English and Japanese.  
(ja)日本語版は(ja)として記載してあります。

## Overview
(en)This package is a set of utilities for Sp3dObj (simple_3d package).
It currently includes utilities that make it easy to generate geometry and a simple set of materials.

(ja)このパッケージはSp3dObj（simple_3d package）用のユーティリティのセットです。  
現在、簡単にジオメトリを生成出来るユーティリティや、マテリアルの簡易的なセットが含まれています。

[simple_3d package](https://pub.dev/packages/simple_3d)

## Usage
### Create Geometry
```dart
import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/util_sp3d_geometry.dart';

Sp3dObj obj = Util_Sp3dGeometry.capsule(50, 250);
```

### Use Default Material
```dart
import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/f_sp3d_material.dart';

Sp3dObj obj = Util_Sp3dGeometry.cube(200,200,200,4,4,4);
obj.materials.add(F_Sp3dMaterial.green);
obj.fragments[0].faces[0].material_index=1;
```

## Geometry type
### Tile
```dart
Sp3dObj obj = Util_Sp3dGeometry.tile(200, 200, 4, 4);
obj.materials[0] = F_Sp3dMaterial.grey.deep_copy()..stroke_color=Color.fromARGB(255, 0, 255, 0);
```
![Tile](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/Util_Sp3dGeometry/tile_sample1.png "Tile")
### Cube
```dart
Sp3dObj obj = Util_Sp3dGeometry.cube(200,200,200,4,4,4);
obj.materials.add(F_Sp3dMaterial.green);
obj.fragments[0].faces[0].material_index=1;
obj.materials[0] = F_Sp3dMaterial.grey.deep_copy()..stroke_color=Color.fromARGB(255, 0, 0, 255);
obj.rotate(Sp3dV3D(1,1,0).nor(), 30*3.14/180);
```
![Cube](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/Util_Sp3dGeometry/cube_sample1.png "Cube")
### Circle
```dart
Sp3dObj obj = Util_Sp3dGeometry.circle(100, fragments: 20);
obj.materials[0] = F_Sp3dMaterial.grey.deep_copy()..stroke_color=Color.fromARGB(255, 0, 255, 0);
```
![Circle](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/Util_Sp3dGeometry/circle_sample1.png "Circle")
### Cone
```dart
Sp3dObj obj = Util_Sp3dGeometry.cone(100, 200);
obj.materials[0] = F_Sp3dMaterial.grey.deep_copy()..stroke_color=Color.fromARGB(255, 0, 255, 0);
obj.rotate(Sp3dV3D(1, 0, 0), -100*3.14/180);
obj.move(Sp3dV3D(0, -100, 0));
```
![Cone](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/Util_Sp3dGeometry/cone_sample1.png "Cone")
### Pillar
```dart
Sp3dObj obj = Util_Sp3dGeometry.pillar(50, 50, 200);
obj.materials[0] = F_Sp3dMaterial.grey.deep_copy()..stroke_color=Color.fromARGB(255, 0, 255, 0);
obj.rotate(Sp3dV3D(1, 0, 0), -120*3.14/180);
obj.move(Sp3dV3D(0, -100, 0));
```
![Pillar](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/Util_Sp3dGeometry/pillar_sample1.png "Pillar")
### Sphere
```dart
Sp3dObj obj = Util_Sp3dGeometry.sphere(100);
obj.materials[0] = F_Sp3dMaterial.grey.deep_copy()..stroke_color=Color.fromARGB(255, 0, 255, 0);
```
![Sphere](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/Util_Sp3dGeometry/sphere_sample1.png "Sphere")
### Capsule
```dart
Sp3dObj obj = Util_Sp3dGeometry.capsule(50,200);
obj.materials[0] = F_Sp3dMaterial.grey.deep_copy()..stroke_color=Color.fromARGB(255, 0, 255, 0);
obj.move(Sp3dV3D(0, 100, 0));
```
![Capsule](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/Util_Sp3dGeometry/capsule_sample1.png "Capsule")
### Wire frame
```dart
Sp3dObj obj = Util_Sp3dGeometry.cube(200,200,200,4,4,4);
obj.materials.add(F_Sp3dMaterial.green_wire);
obj.fragments[0].faces[0].material_index=1;
obj.materials[0] = F_Sp3dMaterial.blue_wire;
obj.rotate(Sp3dV3D(-0.2,0.5,0).nor(), 15*3.14/180);
```
![Wire frame](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/Util_Sp3dGeometry/wire_frame_sample1.png "Wire frame")

## Support
(en)If you need paid support, please contact my company.  
[SimpleAppli Inc.](https://simpleappli.com/en/index_en.html)  
(ja)もし何らかの理由で有償のサポートが必要な場合は私の会社に問い合わせてください。  
このパッケージは私が個人で開発していますが、会社経由でサポートできる場合があります。  
[合同会社シンプルアプリ](https://simpleappli.com/index.html)  

## About future development
(en)Some geometry may be added in the future.  
(ja)今後、いくつかのジオメトリが追加される可能性があります。

## About Naming rule in this package
(en)Utilities are prefixed with "Util_".  
Static field definition files are prefixed with "F_".  
These are set up for easy calling from the IDE.  
(ja)ユーティリティは接頭語に"Util_"がつきます。  
静的なフィールド定義ファイルは接頭語に"F_"がつきます。  
これらはIDEから簡単に呼び出すために設定されています。

## About version control
(en)The C part will be changed at the time of version upgrade.
- Changes such as adding variables, structure change that cause problems when reading previous files.
    - C.X.X
- Adding methods, etc.
    - X.C.X
- Minor changes and bug fixes.
    - X.X.C

(ja)それぞれ、Cの部分が変更されます。
- 変数の追加など、以前のファイルの読み込み時に問題が起こったり、ファイルの構造が変わるような変更
    - C.X.X
- メソッドの追加など
    - X.C.X
- 軽微な変更やバグ修正
    - X.X.C

## License
(en)This software is released under the MIT License, see LICENSE file.  
(ja)このソフトウェアはMITライセンスの元配布されます。LICENSEファイルの内容をご覧ください。

## Copyright notice
The “Dart” name and “Flutter” name are trademarks of Google LLC.  
*The developer of this package is not Google LLC.
# util_simple_3d

日本語版の解説です。

## 概要
このパッケージはSp3dObj（simple_3d package）用のユーティリティのセットです。  
現在、簡単にジオメトリを生成出来るユーティリティや、マテリアルの簡易的なセットが含まれています。

[simple_3d package](https://pub.dev/packages/simple_3d)

## 使い方
### ジオメトリの作成
```dart
import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/util_sp3d_geometry.dart';

Sp3dObj obj = UtilSp3dGeometry.capsule(50, 250);
```

### 標準マテリアルの適用方法
```dart
import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/f_sp3d_material.dart';

Sp3dObj obj = UtilSp3dGeometry.cube(200,200,200,4,4,4);
obj.materials.add(FSp3dMaterial.green.deepCopy());
obj.fragments[0].faces[0].materialIndex=1;
```

## 利用出来るジオメトリのタイプ
### Tile
```dart
Sp3dObj obj = UtilSp3dGeometry.tile(200, 200, 4, 4);
obj.materials[0] = FSp3dMaterial.grey.deepCopy()..strokeColor=Color.fromARGB(255, 0, 255, 0);
```
![Tile](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/UtilSp3dGeometry/tile_sample1.png "Tile")
### Cube
```dart
Sp3dObj obj = UtilSp3dGeometry.cube(200,200,200,4,4,4);
obj.materials.add(FSp3dMaterial.green.deepCopy());
obj.fragments[0].faces[0].materialIndex=1;
obj.materials[0] = FSp3dMaterial.grey.deepCopy()..strokeColor=Color.fromARGB(255, 0, 0, 255);
obj.rotate(Sp3dV3D(1,1,0).nor(), 30*3.14/180);
```
![Cube](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/UtilSp3dGeometry/cube_sample1.png "Cube")
### Circle
```dart
Sp3dObj obj = UtilSp3dGeometry.circle(100, fragments: 20);
obj.materials[0] = FSp3dMaterial.grey.deepCopy()..strokeColor=Color.fromARGB(255, 0, 255, 0);
```
![Circle](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/UtilSp3dGeometry/circle_sample1.png "Circle")
### Cone
```dart
Sp3dObj obj = UtilSp3dGeometry.cone(100, 200);
obj.materials[0] = FSp3dMaterial.grey.deepCopy()..strokeColor=Color.fromARGB(255, 0, 255, 0);
obj.rotate(Sp3dV3D(1, 0, 0), -100*3.14/180);
obj.move(Sp3dV3D(0, -100, 0));
```
![Cone](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/UtilSp3dGeometry/cone_sample1.png "Cone")
### Pillar
```dart
Sp3dObj obj = UtilSp3dGeometry.pillar(50, 50, 200);
obj.materials[0] = FSp3dMaterial.grey.deepCopy()..strokeColor=Color.fromARGB(255, 0, 255, 0);
obj.rotate(Sp3dV3D(1, 0, 0), -120*3.14/180);
obj.move(Sp3dV3D(0, -100, 0));
```
![Pillar](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/UtilSp3dGeometry/pillar_sample1.png "Pillar")
### Sphere
```dart
Sp3dObj obj = UtilSp3dGeometry.sphere(100);
obj.materials[0] = FSp3dMaterial.grey.deepCopy()..strokeColor=Color.fromARGB(255, 0, 255, 0);
```
![Sphere](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/UtilSp3dGeometry/sphere_sample1.png "Sphere")
### Capsule
```dart
Sp3dObj obj = UtilSp3dGeometry.capsule(50,200);
obj.materials[0] = FSp3dMaterial.grey.deepCopy()..strokeColor=Color.fromARGB(255, 0, 255, 0);
obj.move(Sp3dV3D(0, 100, 0));
```
![Capsule](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/UtilSp3dGeometry/capsule_sample1.png "Capsule")
### Wire frame
```dart
Sp3dObj obj = UtilSp3dGeometry.cube(200,200,200,4,4,4);
obj.materials.add(FSp3dMaterial.greenWire.deepCopy());
obj.fragments[0].faces[0].materialIndex = 1;
obj.materials[0] = FSp3dMaterial.blueWire.deepCopy();
obj.rotate(Sp3dV3D(-0.2,0.5,0).nor(), 15*3.14/180);
```
![Wire frame](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/UtilSp3dGeometry/wire_frame_sample1.png "Wire frame")

## サポート
もし何らかの理由で有償のサポートが必要な場合は私の会社に問い合わせてください。  
このパッケージは私が個人で開発していますが、会社経由でサポートできる場合があります。  
[合同会社シンプルアプリ](https://simpleappli.com/index.html)  

## 今後のアップデートなどについて
今後、いくつかのジオメトリが追加される可能性があります。

## このパッケージ特有のネーミングルールについて
ユーティリティは接頭語に"Util"がつきます。  
静的なフィールド定義ファイルは接頭語に"F"がつきます。  
これらはIDEから簡単に呼び出すために設定されています。

## バージョン管理について
それぞれ、Cの部分が変更されます。
- 変数の追加など、以前のファイルの読み込み時に問題が起こったり、ファイルの構造が変わるような変更
    - C.X.X
- メソッドの追加など
    - X.C.X
- 軽微な変更やバグ修正
    - X.X.C

## ライセンス
(en)This software is released under the MIT License, see LICENSE file.  
(ja)このソフトウェアはMITライセンスの元配布されます。LICENSEファイルの内容をご覧ください。

## 著作権表示
The “Dart” name and “Flutter” name are trademarks of Google LLC.  
*The developer of this package is not Google LLC.
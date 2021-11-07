# util_simple_3d

(en)Japanese ver is [here](https://github.com/MasahideMori-SimpleAppli/util_simple_3d/blob/main/README_JA.md).  
(ja)日本語版は[ここ](https://github.com/MasahideMori-SimpleAppli/util_simple_3d/blob/main/README_JA.md)にあります。

## Overview
This package is a set of utilities for Sp3dObj (simple_3d package).
It currently includes utilities that make it easy to generate geometry and a simple set of materials.

[simple_3d package](https://pub.dev/packages/simple_3d)

## Usage
### Create Geometry
```dart
import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/util_sp3d_geometry.dart';

Sp3dObj obj = UtilSp3dGeometry.capsule(50, 250);
```

### Use Default Material
```dart
import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/f_sp3d_material.dart';

Sp3dObj obj = UtilSp3dGeometry.cube(200,200,200,4,4,4);
obj.materials.add(FSp3dMaterial.green.deepCopy());
obj.fragments[0].faces[0].materialIndex=1;
```

## Geometry type
### Tile
```dart
Sp3dObj obj = UtilSp3dGeometry.tile(200, 200, 4, 4);
obj.materials[0] = FSp3dMaterial.grey.deepCopy()..strokeColor=Color.fromARGB(255, 0, 255, 0);
```
![Tile](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/Util_Sp3dGeometry/tile_sample1.png "Tile")
### Cube
```dart
Sp3dObj obj = UtilSp3dGeometry.cube(200,200,200,4,4,4);
obj.materials.add(FSp3dMaterial.green.deepCopy());
obj.fragments[0].faces[0].materialIndex=1;
obj.materials[0] = FSp3dMaterial.grey.deepCopy()..strokeColor=Color.fromARGB(255, 0, 0, 255);
obj.rotate(Sp3dV3D(1,1,0).nor(), 30*3.14/180);
```
![Cube](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/Util_Sp3dGeometry/cube_sample1.png "Cube")
### Circle
```dart
Sp3dObj obj = UtilSp3dGeometry.circle(100, fragments: 20);
obj.materials[0] = FSp3dMaterial.grey.deepCopy()..strokeColor=Color.fromARGB(255, 0, 255, 0);
```
![Circle](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/Util_Sp3dGeometry/circle_sample1.png "Circle")
### Cone
```dart
Sp3dObj obj = UtilSp3dGeometry.cone(100, 200);
obj.materials[0] = FSp3dMaterial.grey.deepCopy()..strokeColor=Color.fromARGB(255, 0, 255, 0);
obj.rotate(Sp3dV3D(1, 0, 0), -100*3.14/180);
obj.move(Sp3dV3D(0, -100, 0));
```
![Cone](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/Util_Sp3dGeometry/cone_sample1.png "Cone")
### Pillar
```dart
Sp3dObj obj = UtilSp3dGeometry.pillar(50, 50, 200);
obj.materials[0] = FSp3dMaterial.grey.deepCopy()..strokeColor=Color.fromARGB(255, 0, 255, 0);
obj.rotate(Sp3dV3D(1, 0, 0), -120*3.14/180);
obj.move(Sp3dV3D(0, -100, 0));
```
![Pillar](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/Util_Sp3dGeometry/pillar_sample1.png "Pillar")
### Sphere
```dart
Sp3dObj obj = UtilSp3dGeometry.sphere(100);
obj.materials[0] = FSp3dMaterial.grey.deepCopy()..strokeColor=Color.fromARGB(255, 0, 255, 0);
```
![Sphere](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/Util_Sp3dGeometry/sphere_sample1.png "Sphere")
### Capsule
```dart
Sp3dObj obj = UtilSp3dGeometry.capsule(50,200);
obj.materials[0] = FSp3dMaterial.grey.deepCopy()..strokeColor=Color.fromARGB(255, 0, 255, 0);
obj.move(Sp3dV3D(0, 100, 0));
```
![Capsule](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/Util_Sp3dGeometry/capsule_sample1.png "Capsule")
### Wire frame
```dart
Sp3dObj obj = UtilSp3dGeometry.cube(200,200,200,4,4,4);
obj.materials.add(FSp3dMaterial.greenWire.deepCopy());
obj.fragments[0].faces[0].materialIndex = 1;
obj.materials[0] = FSp3dMaterial.blueWire.deepCopy();
obj.rotate(Sp3dV3D(-0.2,0.5,0).nor(), 15*3.14/180);
```
![Wire frame](https://raw.githubusercontent.com/MasahideMori1111/simple_3d_images/main/Util_Sp3dGeometry/wire_frame_sample1.png "Wire frame")

## Support
If you need paid support, please contact my company.  
[SimpleAppli Inc.](https://simpleappli.com/en/index_en.html)

## About future development
Some geometry may be added in the future.

## About Naming rule in this package
Utilities are prefixed with "Util".  
Static field definition files are prefixed with "F".  
These are set up for easy calling from the IDE.

## About version control
The C part will be changed at the time of version upgrade.
- Changes such as adding variables, structure change that cause problems when reading previous files.
    - C.X.X
- Adding methods, etc.
    - X.C.X
- Minor changes and bug fixes.
    - X.X.C

## License
This software is released under the MIT License, see LICENSE file.

## Copyright notice
The “Dart” name and “Flutter” name are trademarks of Google LLC.  
*The developer of this package is not Google LLC.
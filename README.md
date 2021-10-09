# util_simple_3d

(en)The explanation is in English and Japanese.  
(ja)日本語版は(ja)として記載してあります。

## Overview
(en)This package is a set of utilities using Sp3dObj (simple_3d package).
It currently includes utilities that make it easy to generate geometry and a simple set of materials.

(ja)このパッケージはSp3dObj（simple_3d package）を使ったユーティリティのセットです。  
現在、簡単にジオメトリを生成出来るユーティリティや、マテリアルの簡易的なセットが含まれています。

[simple_3d package](https://pub.dev/packages/simple_3d)

## Usage
### Create Geometry
```dart
Sp3dObj obj = Util_Sp3dGeometry.capsule(50, 250);
```

## About Naming rule in this package
(en)Utilities are prefixed with "Util_".  
Static field definition files are prefixed with "F_".  
These are set up for easy calling from the IDE.  
(ja)ユーティリティは接頭語に"Util_"がつきます。  
静的なフィールド定義ファイルは接頭語に"F_"がつきます。  
これらはIDEから簡単に呼び出すために設定されています。  

## About future development
(en)I will publish a package containing a render view for screen display later. Please wait.  
(ja)画面表示用のレンダービューを含むパッケージを後で公開します。現在公開の準備をしています。

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
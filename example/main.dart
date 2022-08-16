import 'package:flutter/material.dart';
import 'package:util_simple_3d/util_simple_3d.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final sp3dObj = UtilSp3dGeometry.cube(100, 100, 100, 1, 1, 1);
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Cube Structure.'),
      ),
      body: Center(
        child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  sp3dObj.toDict().toString(),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            )),
      ),
    );
  }
}

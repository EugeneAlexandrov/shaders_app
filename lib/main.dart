import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Shader Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> with TickerProviderStateMixin {
  var updateTime = 0.0;
  double _value = 0.0;

  @override
  void initState() {
    super.initState();
    createTicker((elapsed) {
      updateTime = elapsed.inMilliseconds / 1000;
      setState(() {});
    }).start();
  }

  @override
  Widget build(BuildContext context) {
    var pixRatio = MediaQuery.of(context).devicePixelRatio;
    log('ширина ${MediaQuery.of(context).size.width * pixRatio}');
    log('высота ${MediaQuery.of(context).size.height * pixRatio}');
    return Scaffold(
      body: Stack(
        children: [
          ShaderBuilder(
            assetKey: 'assets/shaders/my_shader.frag',
            (context, shader, child) => CustomPaint(
              size: MediaQuery.of(context).size,
              painter: MyPainter(
                  shader: shader, updateTime: updateTime, value: _value),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Positioned(bottom: 16,
          left: 16,right: 16,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Slider(
                onChanged: (value) {
                  log(value.toString());
                  setState(() {
                    _value = value;
                  });
                },
                value: _value,
                max: 20,
                label: _value.round().toString(),
              ),
            ),
          ),
        ],
      ),
      // CustomPaint(
      //   painter: MyPainter(
      //     Colors.green,
      //     shader: fragmentProgram.fragmentShader()
      //       ..setFloat(0, updateTime)
      //       ..setFloat(1, MediaQuery.of(context).size.width*pixRatio)
      //       ..setFloat(2, MediaQuery.of(context).size.height*pixRatio),
      //   ),
      // ),
    );
  }
}

class MyPainter extends CustomPainter {
  MyPainter({
    required this.shader,
    required this.updateTime,
    required this.value,
  });

  double updateTime;
  ui.FragmentShader shader;
  double value;

  @override
  void paint(Canvas canvas, Size size) {
    // shader.setFloat(0, updateTime);
    // shader.setFloat(1, value);
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, updateTime);
    shader.setFloat(3, value);

    // shader.setFloat(0, color.red.toDouble() / 255);
    // shader.setFloat(1, color.green.toDouble() / 255);
    // shader.setFloat(2, color.blue.toDouble() / 255);
    // shader.setFloat(3, color.alpha.toDouble() / 255);
    canvas.drawRect(
      Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) => true;
}

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Scroller',
      home: MyHomePage(),
      theme: ThemeData.dark(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  String _label1 = 'Flutter Training';
  String _label2 = 'Flutter Education';
  final Curve _animationCurve = Interval(
    0.3,
    0.7,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _switchLabels();
          _animationController.forward(from: 0.0);
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _switchLabels() {
    if (_label1 == 'Flutter Education') {
      _label1 = 'Flutter Training';
      _label2 = 'Flutter Education';
    } else {
      _label1 = 'Flutter Education';
      _label2 = 'Flutter Training';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Column(
            children: <Widget>[
              Text('Text Scroller'),
              CustomPaint(
                size: Size(double.infinity, 32),
                painter: TextScrollPainter(
                  label1: _label1,
                  label2: _label2,
                  scrollPosition:
                  _animationCurve.transform(_animationController.value),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomPaint(
            size: Size(double.infinity, 32),
            painter: TextScrollPainter(
              label1: _label1,
              label2: _label2,
              scrollPosition:
              _animationCurve.transform(_animationController.value),
            ),
          ),
        ],
      )
    );
  }
}

class TextScrollPainter extends CustomPainter {
  TextScrollPainter({
    @required this.label1,
    @required this.label2,
    this.scrollPosition = 0.0,
  }) : fadeGradient = LinearGradient(
          colors: [
            Colors.white.withOpacity(0.0),
            Colors.white,
            Colors.white,
            Colors.white.withOpacity(0.0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.05, 0.3, 0.7, 0.95],
        );

  final String label1;
  final String label2;

  final double scrollPosition;
  final LinearGradient fadeGradient;

  @override
  void paint(Canvas canvas, Size size) {
    Shader fadeShader =
    fadeGradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Paint fadePaint = Paint()..shader = fadeShader;

    final ui.Paragraph paragraph1 = _buildParagraph(label1, size, fadePaint);

    final double lineHeight = paragraph1.height;

    final Offset label1Position = Offset(
      0,
      ((size.height - lineHeight) / 2) + (size.height * scrollPosition),
    );
    canvas.drawParagraph(paragraph1, label1Position);

    final ui.Paragraph paragraph2 = _buildParagraph(label2, size, fadePaint);
    final Offset label2Position = label1Position.translate(0, -size.height);
    canvas.drawParagraph(paragraph2, label2Position);
  }

  ui.Paragraph _buildParagraph(String label, Size availableSpace, Paint paint) {
    final ui.ParagraphBuilder paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
    )..pushStyle(ui.TextStyle(
      foreground: paint
    ))..addText(label);

    return paragraphBuilder.build()
      ..layout(
        ui.ParagraphConstraints(
          width: availableSpace.width,
        ),
      );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


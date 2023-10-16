import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(MaterialApp(
    home: AnimationScreen(),
  ));
}

class AnimationScreen extends StatefulWidget {
  @override
  _AnimationScreenState createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen> {
  Artboard? _artboard;
  RiveAnimationController? _controller;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                color:Color(0xFF377FD3),
                child: Center(
                  child: RiveAnimation.asset("assets/animation.riv"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

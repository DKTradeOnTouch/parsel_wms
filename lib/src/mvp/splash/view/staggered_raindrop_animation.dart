import 'package:flutter/material.dart';

class StaggeredRaindropAnimation {
  StaggeredRaindropAnimation(this.controller)
      : holeSize = Tween<double>(begin: 1.2, end: maximumHoleSize).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
          ),
        ),
        textOpacity = Tween<double>(begin: 1, end: 0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.5, 0.7, curve: Curves.easeOut),
          ),
        );
 
  final AnimationController controller;
  final Animation<double> holeSize;
  final Animation<double> textOpacity;
  static const double maximumHoleSize = 10;
}

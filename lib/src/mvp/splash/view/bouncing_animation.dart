import 'package:flutter/material.dart';

class BounceClickWidget extends StatefulWidget {
  // final VoidCallback? onTap;
  final Widget? child;
  final Duration? duration;

  const BounceClickWidget({
    Key? key,
    this.child,
    this.duration,
  }) : super(key: key);

  @override
  BounceClickWidgetState createState() => BounceClickWidgetState();
}

class BounceClickWidgetState extends State<BounceClickWidget>
    with SingleTickerProviderStateMixin {
  late double _scale;

  late AnimationController _animate;

  // VoidCallback get onTap => widget.onTap!;

  Duration get userDuration =>
      widget.duration ?? const Duration(milliseconds: 500);

  @override
  void initState() {
    _animate = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 0.25,
    )..addListener(() {
        setState(() {});
      });
    _animate.forward();

    Future.delayed(userDuration, () async {
      await _animate.reverse();

      // onTap();
    });
    super.initState();
  }

  @override
  void dispose() {
    _animate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _animate.value;
    return GestureDetector(
        onTap: _onTap,
        child: Transform.scale(
          scale: _scale,
          child: widget.child,
        ));
  }

  void _onTap() {
    _animate.forward();

    Future.delayed(userDuration, () async {
      await _animate.reverse();

      // onTap();
    });
  }
}

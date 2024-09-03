import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:parsel_flutter/src/mvp/splash/view/bouncing_animation.dart';
import 'package:parsel_flutter/src/mvp/splash/view/hole_painter.dart';
import 'package:parsel_flutter/src/mvp/splash/view/staggered_raindrop_animation.dart';

// class AnimationScreen extends StatefulWidget {
//   const AnimationScreen({Key? key, required this.color}) : super(key: key);

//   final Color color;

//   @override
//   _AnimationScreenState createState() => _AnimationScreenState();
// }

// class _AnimationScreenState extends State<AnimationScreen>
//     with SingleTickerProviderStateMixin {
//   Size size = Size.zero;
//   late AnimationController _controller;
//   late StaggeredRaindropAnimation _animation;
//   bool _visible = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
//     _animation = StaggeredRaindropAnimation(_controller);
//     _controller.forward();

//     _controller.addListener(() {
//       if (_controller.isCompleted) {
//         setState(() {
//           // Timer()
//           // _visible = true;
//         });
//       }
//     });
//   }

//   @override
//   void didChangeDependencies() {
//     setState(() {
//       size = MediaQuery.of(context).size;
//     });
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: [
//       Stack(
//         children: [
//           Container(
//               width: double.infinity,
//               height: double.infinity,
//               child: BounceClickWidget(
//                 child: CustomPaint(
//                     painter: HolePainter(
//                         color: widget.color,
//                         holeSize: _animation.holeSize.value * size.width)),
//               )),
//           // Center(
//           //     child: Column(
//           //   crossAxisAlignment: CrossAxisAlignment.center,
//           //   mainAxisAlignment: MainAxisAlignment.center,
//           //   children: [
//           //     AnimatedOpacity(
//           //         opacity: _visible ? 1.0 : 0.0,
//           //         duration: const Duration(milliseconds: 500),
//           //         child: SvgPicture.asset(AssetUtils.parselTruck)),
//           //     const SizedBox(height: 10),
//           //     const Text('Parsel Delivery Driver')
//           //   ],
//           // ))
//         ],
//       ),
//     ]);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }

class AnimationScreen extends StatefulWidget {
  AnimationScreen({required this.color});

  final Color color;

  @override
  _AnimationScreenState createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen>
    with SingleTickerProviderStateMixin {
  Size size = Size.zero;
  late AnimationController _controller;
  late StaggeredRaindropAnimation _animation;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = StaggeredRaindropAnimation(_controller);
    _controller.forward();

    _controller.addListener(() {
      setState(() {
        if (_controller.isCompleted) {
          _visible = true;
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    setState(() {
      size = MediaQuery.of(context).size;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Stack(
        children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              child: BounceClickWidget(
                child: CustomPaint(
                    painter: HolePainter(
                        color: widget.color,
                        holeSize: _animation.holeSize.value * size.width)),
              )),
          Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                      opacity: _visible ? 1.0 : 0,
                      duration: const Duration(seconds: 1),
                      child: Image.asset(
                        AssetUtils.parselTruck,
                        height: 80,
                      )),
                  const SizedBox(height: 10),
                  _visible ? BreathingTextAnimation() : const SizedBox(),
                ],
              ))
        ],
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class BreathingTextAnimation extends StatefulWidget {
  @override
  _BreathingTextAnimationState createState() => _BreathingTextAnimationState();
}

class _BreathingTextAnimationState extends State<BreathingTextAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  double _minScale = 1.0;
  double _maxScale = 1.2;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
          seconds: 1), // Adjust the duration as per your preference
    );

    _animation = Tween<double>(
      begin: _minScale,
      end: _maxScale,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut, // Adjust the curve as per your preference
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Text('Parsel Delivery Agent',
              style: FontUtilities.h18(
                  fontColor: ColorUtils.whiteColor, fontWeight: FWT.bold)),
        );
      },
    );
  }
}

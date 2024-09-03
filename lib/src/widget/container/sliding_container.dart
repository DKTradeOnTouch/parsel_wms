import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parsel_flutter/utils/utils.dart';

class SlidingContainer extends StatefulWidget {
  final String title;
  final String subTitle;
  final String heading;
  const SlidingContainer(
      {Key? key,
      required this.title,
      required this.subTitle,
      required this.heading})
      : super(key: key);

  @override
  _SlidingContainerState createState() => _SlidingContainerState();
}

class _SlidingContainerState extends State<SlidingContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _heightAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from the bottom of the screen
      end: Offset.zero,
    ).animate(curvedAnimation);

    _heightAnimation = Tween<double>(
      begin: 500,
      end: 300.0,
    ).animate(curvedAnimation);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(curvedAnimation);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: AnimatedBuilder(
          animation: _heightAnimation,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: _heightAnimation.value,
              decoration: const BoxDecoration(
                  // color: ColorUtils.blueColor,
                  image: DecorationImage(
                      image: AssetImage(AssetUtils.authBgImage),
                      fit: BoxFit.cover)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(AssetUtils.parselTruck, height: 40),
                      const SizedBox(height: 20),
                      Text(
                        widget.heading,
                        style: FontUtilities.h16(
                            fontColor: ColorUtils.colorC2CFFD),
                      ),
                      widget.heading.isEmpty
                          ? const SizedBox()
                          : const SizedBox(height: 20),
                      Text(
                        widget.title,
                        style:
                            FontUtilities.h30(fontColor: ColorUtils.whiteColor),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.subTitle,
                        maxLines: 2,
                        style: FontUtilities.h16(
                            fontColor: ColorUtils.color96ACFF),
                      ),
                      const SizedBox(height: 20),
                    ]),
              ),
            );
          },
        ),
      ),
    );
  }
}

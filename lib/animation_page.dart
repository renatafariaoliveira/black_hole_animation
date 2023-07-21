import 'package:flutter/material.dart';

import 'custom_card.dart';
import 'custom_clipper.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> with TickerProviderStateMixin {
  final double cardSize = 150;

  late final holeAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  late final cardOffsetAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  late final cardOffsetTween = Tween<double>(
    begin: 0,
    end: 2 * cardSize,
  ).chain(CurveTween(curve: Curves.easeInBack));

  late final holeSizeTween = Tween<double>(begin: 0, end: 1.5 * cardSize);
  late final cardRotationTween = Tween<double>(begin: 0, end: 0.5);
  late final cardElevationTween = Tween<double>(begin: 0, end: 20);

  double get holeSize => holeSizeTween.evaluate(holeAnimationController);
  double get cardOffset => cardOffsetTween.evaluate(cardOffsetAnimationController);
  double get cardRotation => cardRotationTween.evaluate(cardOffsetAnimationController);
  double get cardElevation => cardElevationTween.evaluate(cardOffsetAnimationController);

  @override
  void initState() {
    super.initState();
    holeAnimationController.addListener(() => setState(() {}));
    cardOffsetAnimationController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    holeAnimationController.dispose();
    cardOffsetAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.blue[200],
            onPressed: () async {
              if (!holeAnimationController.isAnimating && !cardOffsetAnimationController.isAnimating) {
                holeAnimationController.forward();
                await cardOffsetAnimationController.forward();

                await Future.delayed(const Duration(milliseconds: 100), () {
                  holeAnimationController.reverse();
                });

                await Future.delayed(const Duration(milliseconds: 1000), () {
                  holeAnimationController.reverse();
                  cardOffsetAnimationController.reverse();
                });
              }
            },
            child: const Icon(Icons.play_arrow, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          height: cardSize * 1.25,
          width: double.infinity,
          child: ClipPath(
            clipper: BlackHoleClipper(),
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: holeSize,
                  child: Image.asset(
                    'assets/images/hole.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(0, cardOffset),
                      child: Transform.rotate(
                        angle: cardRotation,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CustomCard(
                            elevation: cardElevation,
                            size: cardSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

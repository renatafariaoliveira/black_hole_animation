import 'package:flutter/material.dart';

import 'animation_page.dart';

void main() {
  runApp(const MyAnimation());
}

class MyAnimation extends StatelessWidget {
  const MyAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Black Hole Animation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const AnimationPage(),
    );
  }
}

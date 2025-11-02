import 'package:flutter/material.dart';

import './screens/intro/intro.dart';

void main() {
  runApp(const Artory());
}

class Artory extends StatelessWidget {
  const Artory({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const Intro()
    );
  }
}

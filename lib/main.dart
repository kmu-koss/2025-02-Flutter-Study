import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './screens/intro/intro.dart';

void main() {
  runApp(const Artory());
}

class Artory extends StatelessWidget {
  const Artory({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const Intro()
    );
  }
}

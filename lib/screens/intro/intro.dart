import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../exhibition/exhibition_main.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Get.to(() => const ExhibitionMain());
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/images/polygon.png'),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 50),
                Text(
                  'Art\n+\nStory',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Pretendard-Regular',
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '알토리',
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: 'Pretendard-Bold',
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '예술과 기록이 만나다',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Pretendard-Regular',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// TODO: 애니메이션 효과
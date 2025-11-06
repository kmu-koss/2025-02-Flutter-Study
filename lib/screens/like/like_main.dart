import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../exhibition/exhibition_main.dart';

class LikeMain extends StatefulWidget {
  const LikeMain({super.key});

  @override
  State<LikeMain> createState() => _LikeMainState();
}

class _LikeMainState extends State<LikeMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '내가 좋아하는 작품이에요!',
          style: TextStyle(
            fontFamily: 'Pretendard-SemiBold',
            fontSize: 20
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.off(() => ExhibitionMain());
            },
            icon: Icon(Icons.home_filled), color: Color(0xff0D9F34),
          ),
        ],
      ),
      body: Column(
        children: [
          Text('좋아요 메인 페이지')
        ],
      ),
    );
  }
}

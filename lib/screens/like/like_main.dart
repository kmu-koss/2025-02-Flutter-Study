import 'package:flutter/material.dart';

class LikeMain extends StatefulWidget {
  const LikeMain({super.key});

  @override
  State<LikeMain> createState() => _LikeMainState();
}

class _LikeMainState extends State<LikeMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('좋아요 메인 페이지')
        ],
      ),
    );
  }
}

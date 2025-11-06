import 'package:flutter/material.dart';

class ExhibitionDetail extends StatefulWidget {
  final int index;
  const ExhibitionDetail({super.key, required this.index});

  @override
  State<ExhibitionDetail> createState() => _ExhibitionDetailState();
}

class _ExhibitionDetailState extends State<ExhibitionDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('좋아요 메인 페이지')
          ],
        ),
      ),
    );
  }
}

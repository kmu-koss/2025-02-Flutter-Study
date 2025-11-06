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
      appBar: AppBar(title: Text('이경준 사진전 : 원 스텝 어웨이')),
      body: Center(
        child: Column(
          children: [
            Text('전시회 디테일 페이지')
          ],
        ),
      ),
    );
  }
}

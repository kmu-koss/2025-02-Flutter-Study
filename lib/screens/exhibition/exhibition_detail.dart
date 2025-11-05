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
      body: Column(
        children: [
          Text('작품 상세 페이지')
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'plusSchedule.dart';

List week = ['월', '화', '수', '목', '금'];
var kColumnLength = 22;
double kFirstColumnHeight = 20;
double kBoxSize = 52;

class SchedulePage extends StatelessWidget {
  const  SchedulePage({super.key});

  Widget buildTimeColumn() {
    return Expanded(
        child: Column(
          children: [
            SizedBox(
              height: kFirstColumnHeight,
            ),
            ...List.generate(
              kColumnLength,
                (index) {
                if (index % 2 == 0) {
                  return const Divider(
                    color: Colors.grey,
                    height: 0,
                  );
                }
                return SizedBox(
                  height:  kBoxSize,
                  child: Center(child: Text('${index ~/ 2 + 9}')),
                );
                },
            ),
          ],
        ),
    );
  }

  List<Widget> buildDayColumn(int index) {
    return [
      const VerticalDivider(
        color: Colors.grey,
        width: 0,
      ),
      Expanded(
        flex: 4,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                  child: Text(
                    '${week[index]}',
                  ),
                ),
                ...List.generate(
                  kColumnLength,
                    (index) {
                    if (index % 2 == 0) {
                      return const Divider(
                        color: Colors.grey,
                        height: 0,
                      );
                    }
                    return SizedBox(
                      height: kBoxSize,
                      child: Container(),
                    );
                    },
                ),
              ],
            ),
            if (index==1)
            Positioned(
              child: Container(
                color: Color(0xffB8D8E6),
              ),
              top: kFirstColumnHeight + kBoxSize / 2,
              height: kBoxSize + kBoxSize * 0.5,
              width: 100,
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFDF7EF),
        title: Row(
          children: [
            Image.asset(
              'assets/png/mainicon.png',
              height: 60,
              fit: BoxFit.contain,
            ),
          ],
        ),
        actions: [
          Transform.translate(
            offset: Offset(-20, 0),
            child: IconButton(
              icon: Icon(Icons.add_circle),
              iconSize: 35,
              onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => PlusSchedulePage()));},
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xffFDF7EF),
      body: Container(
        height: kColumnLength / 2 * kBoxSize + kColumnLength,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            buildTimeColumn(),
            ...buildDayColumn(0),
            ...buildDayColumn(1),
            ...buildDayColumn(2),
            ...buildDayColumn(3),
            ...buildDayColumn(4),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(backgroundColor: Color(0xffB8D8E6),
        selectedItemColor: Color(0xff2C3E50),
        unselectedItemColor: Color(0xff2C3E50),
        iconSize: 35,

        items: [
          BottomNavigationBarItem(
            icon: Transform.translate(
              offset: const Offset(0, 3),
              child: Icon(Icons.calendar_month),
            ),
            label: ' ',
          ),
          BottomNavigationBarItem(
            icon: Transform. translate(
              offset: const Offset(0, 3),
              child: Icon(Icons.checklist),
            ),
            label: ' ',
          ),
          BottomNavigationBarItem(
            icon: Transform. translate(
              offset: const Offset(0, 3),
              child: Icon(Icons.school),
            ),
            label: ' ',
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'calendar.dart';
import 'schedule.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '오늘 하루',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: '오늘 하루'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

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
      ),
      backgroundColor: Color(0xffFDF7EF),
      body: Column(
        children: [
          Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              height: 300,
              decoration: BoxDecoration(
                color: Color(0xffB8D8E6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children:[
                  Text(
                    '일정',
                    style: TextStyle(
                      color: Color(0xff2E2E2E),
                    ),

                  ),
                ],
              )
          ),
          const SizedBox(height: 50,),
          Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              height: 300,
              decoration: BoxDecoration(
                color: Color(0xffB8D8E6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children:[
                  Text(
                    'To do',
                    style: TextStyle(
                      color: Color(0xff2E2E2E),
                    ),
                  ),
                ],
              )
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(backgroundColor: Color(0xffB8D8E6),
          selectedItemColor: Color(0xff2C3E50),
          unselectedItemColor: Color(0xff2C3E50),
          iconSize: 35,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });

            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarPage()),
              );
            }
            else if(index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SchedulePage()),
              );
            }
          },
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
          ]
      ),
    );
  }
}
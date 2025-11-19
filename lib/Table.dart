import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  Map<DateTime, List<String>> events = {
    DateTime(2025, 11, 1): ['가족 모임'],
    DateTime(2025, 11, 13): ['학교 과제 제출'],
    DateTime(2025, 11, 25): ['운동하기', '독서 1시간'],
  };

  List<String> getEventsForDay(DateTime day) {
    return events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          focusedDay: focusedDay,
          firstDay: DateTime(1800),
          lastDay: DateTime(3000),
          selectedDayPredicate: (date) =>
          selectedDay != null &&
              date.year == selectedDay!.year &&
              date.month == selectedDay!.month &&
              date.day == selectedDay!.day,
          onDaySelected: (day, focused) {
            setState(() {
              selectedDay = day;
              focusedDay = focused;
            });
          },
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),

        SizedBox(height: 10),

        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xffFDF7EF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: selectedDay == null
                ? Center(child: Text("날짜를 선택하세요"))
                : buildEventList(),
          ),
        ),
      ],
    );
  }

  Widget buildEventList() {
    final todaysEvents = getEventsForDay(selectedDay!);

    if (todaysEvents.isEmpty) {
      return Center(child: Text("오늘은 일정이 없습니다."));
    }

    return ListView.builder(
      itemCount: todaysEvents.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Icon(Icons.check),
            title: Text(todaysEvents[index]),
          ),
        );
      },
    );
  }
}

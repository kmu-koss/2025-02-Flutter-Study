import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// 1. 데이터 모델 정의
class TransactionItem {
  final int? id;
  final String date;
  final String category;
  final int amount;

  TransactionItem({this.id, required this.date, required this.category, required this.amount});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'category': category,
      'amount': amount,
    };
  }

  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      id: map['id'] as int?,
      date: map['date'] as String,
      category: map['category'] as String,
      amount: map['amount'] as int,
    );
  }
}

// 2. 데이터베이스 관리 헬퍼 클래스
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('transactions.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE transactions (
        id $idType,
        date $textType,
        category $textType,
        amount $integerType
      )
    ''');
  }

  Future<int> createTransaction(TransactionItem item) async {
    final db = await instance.database;
    return await db.insert('transactions', item.toMap());
  }

  Future<List<TransactionItem>> getTransactionsByDate(String date) async {
    final db = await instance.database;
    final maps = await db.query(
      'transactions',
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'id ASC',
    );

    return maps.map((json) => TransactionItem.fromMap(json)).toList();
  }
}

class DailyTransactionDialog extends StatefulWidget {
  final DateTime selectedDate;

  const DailyTransactionDialog({super.key, required this.selectedDate});

  @override
  State<DailyTransactionDialog> createState() => _DailyTransactionDialogState();
}

class _DailyTransactionDialogState extends State<DailyTransactionDialog> {
  List<Map<String, dynamic>> _transactionInputs = [];
  List<TransactionItem> _loadedTransactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  @override
  void dispose() {
    for (var input in _transactionInputs) {
      input['amountController'].dispose();
    }
    super.dispose();
  }

  Future<void> _loadTransactions() async {
    final dateString = '${widget.selectedDate.year}-${widget.selectedDate.month}-${widget.selectedDate.day}';
    final transactions = await DatabaseHelper.instance.getTransactionsByDate(dateString);

    setState(() {
      _loadedTransactions = transactions;
    });
  }

  void _addTransactionInput() {
    setState(() {
      _transactionInputs.add({
        'category': '카테고리 선택',
        'amountController': TextEditingController(),
      });
    });
  }

  void _removeTransactionInput(int index) {
    setState(() {
      _transactionInputs[index]['amountController'].dispose();
      _transactionInputs.removeAt(index);
    });
  }

  Future<String?> _selectCategoryDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('카테고리 선택'),
          children: <Widget>[
            SimpleDialogOption(onPressed: () => Navigator.pop(context, '식비'), child: const Text('식비')),
            SimpleDialogOption(onPressed: () => Navigator.pop(context, '교통'), child: const Text('교통')),
            SimpleDialogOption(onPressed: () => Navigator.pop(context, '수입'), child: const Text('수입')),
          ],
        );
      },
    );
  }

  Widget _buildDisplayBox(String label, String value) {
    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow(BuildContext context, int index, String currentCategory, TextEditingController controller) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _removeTransactionInput(index),
              child: const Padding(
                padding: EdgeInsets.only(right: 6.0, top: 12),
                child: Icon(Icons.remove_circle_outline, color: Colors.red, size: 24),
              ),
            ),

            Expanded(
              child: InkWell(
                onTap: () async {
                  final newCategory = await _selectCategoryDialog(context);
                  if (newCategory != null) {
                    setState(() {
                      _transactionInputs[index]['category'] = newCategory;
                    });
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Text(currentCategory, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0055C5)))),
                ),
              ),
            ),
            const SizedBox(width: 8),

            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    hintText: '금액 입력',
                    prefixText: '₩ ',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String dateString = '${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일';

    final totalAmount = _loadedTransactions.fold(0, (sum, item) => sum + item.amount);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        width: 350,
        height: 450,
        padding: const EdgeInsets.all(16.0),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  dateString,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.black54),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: InkWell(
                    onTap: _addTransactionInput,
                    child: const Icon(
                      Icons.add,
                      color: Color(0xFF0055C5),
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 20),

            Row(
              children: [
                _buildDisplayBox('총 지출/수입', '₩ ${totalAmount.toString()}'),
                const SizedBox(width: 8),
                _buildDisplayBox('저장된 항목 수', '${_loadedTransactions.length}개'),
              ],
            ),

            const SizedBox(height: 15),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ..._transactionInputs.asMap().entries.map((entry) {
                      int index = entry.key;
                      var input = entry.value;
                      return _buildInputRow(
                        context,
                        index,
                        input['category'],
                        input['amountController'],
                      );
                    }).toList(),

                    const SizedBox(height: 10),
                    const Text('--- 이 날짜의 저장된 내역 ---', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    if (_loadedTransactions.isEmpty)
                      const Center(child: Text('저장된 내역이 없습니다.')),

                    ..._loadedTransactions.map((item) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text('${item.category}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Text('₩ ${item.amount.toString()}'),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_transactionInputs.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('새로 입력된 항목이 없습니다.')));
                  return;
                }

                int savedCount = 0;
                for (var input in _transactionInputs) {
                  final category = input['category'] as String;
                  final amountText = (input['amountController'] as TextEditingController).text;

                  if (amountText.isEmpty || category == '카테고리 선택') continue;

                  final amount = int.tryParse(amountText) ?? 0;
                  final dateString = '${widget.selectedDate.year}-${widget.selectedDate.month}-${widget.selectedDate.day}';

                  final newItem = TransactionItem(
                    date: dateString,
                    category: category,
                    amount: amount,
                  );

                  await DatabaseHelper.instance.createTransaction(newItem);
                  savedCount++;
                }

                if (savedCount > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$savedCount개 항목이 저장되었습니다. 팝업을 다시 열어 확인하세요.'))
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('유효한 입력 항목이 없습니다.')));
                }

                Navigator.of(context).pop();
              },
              child: const Text('모든 항목 저장'),
            ),
          ],
        ),
      ),
    );
  }
}


class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void _showDailyPopup(BuildContext context, DateTime selectedDate) {
    showDialog(
      context: context,
      builder: (context) => DailyTransactionDialog(selectedDate: selectedDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),

      appBar: AppBar(
        title: const Text('🗓️ My Calendar'),
        backgroundColor: const Color(0xFF0055C5),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  calendarFormat: _calendarFormat,

                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },

                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });

                    _showDailyPopup(context, selectedDay);
                  },

                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },

                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Color(0xFF0055C5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Container(
                width: screenSize.width * 0.8,
                height: screenSize.height * 0.15,

                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '여기에 반응형 도형이 들어갑니다',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final double containerWidth = screenSize.width * 0.9;
    final double containerHeight = screenSize.height * 0.15;


    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: containerWidth,
              height: containerHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF0055C5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                  )
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '[기태 은행] 잔고',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '110-XXX-XX34XX',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '273,143원',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 100),

            Container(
              width: containerWidth,
              height: containerHeight,
              decoration: BoxDecoration(
                color: const Color(0xFFFDFDFD),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                  )
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'X월 지출',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '130,000원',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    const CalendarPage(),
    const HomePageContent(),
    const Center(child: Text('📈 Chart Page', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),

      body: _widgetOptions.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFFD7D7D7),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xFF0055C5),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: "calendar"),
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart_rounded),
                label: "chart")
          ]
      ),
    );
  }
}
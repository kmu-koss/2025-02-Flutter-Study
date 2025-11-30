import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:fl_chart/fl_chart.dart';

part 'main.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(TransactionItemAdapter());

  await Hive.openBox<TransactionItem>('transactions');

  await Hive.openBox('settings');

  runApp(const MyApp());
}

@HiveType(typeId: 0)
class TransactionItem extends HiveObject {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final int amount;

  TransactionItem({required this.date, required this.category, required this.amount});
}

class DatabaseHelper {
  final Box<TransactionItem> transactionBox = Hive.box<TransactionItem>('transactions');
  final Box settingsBox = Hive.box('settings');

  Future<void> saveBalance(int amount) async {
    await settingsBox.put('currentBalance', amount);
  }

  int getBalance() {
    return settingsBox.get('currentBalance', defaultValue: 0);
  }

  Future<void> createTransaction(TransactionItem item) async {
    await transactionBox.add(item);
  }

  List<TransactionItem> getTransactionsByDate(String date) {
    return transactionBox.values.where((item) => item.date == date).toList();
  }

  List<TransactionItem> getAllTransactions() {
    return transactionBox.values.toList();
  }
}
final dbHelper = DatabaseHelper();


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

    final transactions = dbHelper.getTransactionsByDate(dateString);

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

                  await dbHelper.createTransaction(newItem);
                  savedCount++;
                }

                if (savedCount > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$savedCount개 항목이 저장되었습니다.'))
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

  Map<DateTime, List<TransactionItem>> _events = {};
  int _totalExpenditure = 0;
  Map<String, int> _categoryExpenditures = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final transactions = dbHelper.getAllTransactions();
    final Map<DateTime, List<TransactionItem>> newEvents = {};

    int calculatedTotalExpenditure = 0;
    Map<String, int> calculatedCategoryExpenditures = {};

    for (var item in transactions) {
      final dateParts = item.date.split('-');
      if (dateParts.length < 3) continue;

      final day = DateTime.utc(
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(dateParts[2])
      );

      final normalizedDay = DateTime(day.year, day.month, day.day);

      if (newEvents[normalizedDay] == null) {
        newEvents[normalizedDay] = [];
      }
      newEvents[normalizedDay]!.add(item);

      if (item.category != '수입') {
        calculatedTotalExpenditure += item.amount;

        calculatedCategoryExpenditures.update(
          item.category,
              (value) => value + item.amount,
          ifAbsent: () => item.amount,
        );
      }
    }

    setState(() {
      _events = newEvents;
      _totalExpenditure = calculatedTotalExpenditure;
      _categoryExpenditures = calculatedCategoryExpenditures;
    });
  }

  List<TransactionItem> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  void _showDailyPopup(BuildContext context, DateTime selectedDate) async {
    await showDialog(
      context: context,
      builder: (context) => DailyTransactionDialog(selectedDate: selectedDate),
    );

    _loadEvents();
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

                  eventLoader: _getEventsForDay,

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
                    markerDecoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    markerSize: 6.0,
                    markerSizeScale: 0.2,
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
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '총 지출 금액 (누적)',
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                      Text(
                        '₩ ${_totalExpenditure.toString()}',
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      const SizedBox(height: 8),

                      ..._categoryExpenditures.entries.map((entry) {
                        return Text(
                          '${entry.key}: ₩ ${entry.value.toString()}',
                          style: const TextStyle(color: Colors.black87, fontSize: 16),
                        );
                      }).toList(),

                      if (_categoryExpenditures.isEmpty && _totalExpenditure == 0)
                        const Text('저장된 지출 내역이 없습니다.', style: TextStyle(color: Colors.grey)),
                    ],
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

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  int _currentBalance = 0;
  int _currentMonthTotalExpenditure = 0;
  Map<String, int> _currentMonthCategoryExpenditures = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _loadBalance();
    _loadCurrentMonthExpenditure();
  }

  void _loadBalance() {
    setState(() {
      _currentBalance = dbHelper.getBalance();
    });
  }

  void _loadCurrentMonthExpenditure() {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    final allTransactions = dbHelper.getAllTransactions();
    int totalExpenditure = 0;
    Map<String, int> categoryMap = {};

    for (var item in allTransactions) {
      if (item.category == '수입') continue;

      final dateParts = item.date.split('-');
      if (dateParts.length < 3) continue;

      final itemYear = int.tryParse(dateParts[0]) ?? 0;
      final itemMonth = int.tryParse(dateParts[1]) ?? 0;

      if (itemYear == currentYear && itemMonth == currentMonth) {
        totalExpenditure += item.amount;

        categoryMap.update(
          item.category,
              (value) => value + item.amount,
          ifAbsent: () => item.amount,
        );
      }
    }

    final sortedCategories = Map.fromEntries(
      categoryMap.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value)),
    );

    setState(() {
      _currentMonthTotalExpenditure = totalExpenditure;
      _currentMonthCategoryExpenditures = sortedCategories;
    });
  }

  void _showBalanceEditDialog() {
    final controller = TextEditingController(text: _currentBalance.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('잔고 입력/수정'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '새 잔고 (원)',
              prefixText: '₩ ',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                final newAmount = int.tryParse(controller.text) ?? _currentBalance;

                await dbHelper.saveBalance(newAmount);

                _loadBalance();

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('잔고가 ₩ $newAmount 원으로 저장되었습니다.'))
                );
              },
              child: const Text('저장', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final currentMonth = DateTime.now().month;
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
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '[기태 은행] 잔고',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: _showBalanceEditDialog,
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '110-XXX-XX34XX',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${_currentBalance.toString()}원',
                      style: const TextStyle(
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
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '$currentMonth월 지출',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_currentMonthTotalExpenditure.toString()}원',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              width: containerWidth,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                  )
                ],
              ),
              child: MonthlyCategoryPieChart(
                totalExpenditure: _currentMonthTotalExpenditure,
                categoryMap: _currentMonthCategoryExpenditures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MonthlyCategoryPieChart extends StatelessWidget {
  final int totalExpenditure;
  final Map<String, int> categoryMap;

  const MonthlyCategoryPieChart({
    super.key,
    required this.totalExpenditure,
    required this.categoryMap,
  });

  static const List<Color> colorList = [
    Color(0xFF0055C5),
    Color(0xFF4CAF50),
    Color(0xFFFF9800),
    Color(0xFFE91E63),
    Color(0xFF9C27B0),
    Color(0xFF00BCD4),
    Color(0xFFFFEB3B),
  ];

  List<PieChartSectionData> getSections(int total, Map<String, int> categoryMap) {
    if (total == 0) return [];

    int index = 0;
    return categoryMap.entries.map((entry) {
      final percentage = (entry.value / total * 100).toStringAsFixed(1);

      final section = PieChartSectionData(
        color: colorList[index % colorList.length],
        value: entry.value.toDouble(),
        title: '$percentage%',
        radius: 70.0,
        titleStyle: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
      index++;
      return section;
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    if (totalExpenditure == 0) {
      return const Center(child: Text("이번 달 지출 내역이 없습니다.", style: TextStyle(color: Colors.grey)));
    }

    final pieChartLegend = categoryMap.entries.map((entry) {
      final category = entry.key;
      final amount = entry.value;
      final percentage = (amount / totalExpenditure * 100).toStringAsFixed(1);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: colorList[categoryMap.keys.toList().indexOf(category) % colorList.length],
                    shape: BoxShape.circle,
                  ),
                  margin: const EdgeInsets.only(right: 8),
                ),
                Text('$category (${percentage}%)', style: const TextStyle(fontSize: 16)),
              ],
            ),
            Text('₩ ${amount.toString()}원', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '카테고리별 지출 현황 (이번 달)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0055C5)),
        ),
        const Divider(),

        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sections: getSections(totalExpenditure, categoryMap),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 10),

        ...pieChartLegend,
      ],
    );
  }
}

class MonthlyExpenseChart extends StatefulWidget {
  const MonthlyExpenseChart({super.key});

  @override
  State<MonthlyExpenseChart> createState() => _MonthlyExpenseChartState();
}

class _MonthlyExpenseChartState extends State<MonthlyExpenseChart> {
  List<double> _monthlyExpenses = List.filled(6, 0.0);
  List<String> _monthLabels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMonthlyData();
  }

  Future<void> _loadMonthlyData() async {
    final transactions = dbHelper.getAllTransactions();
    Map<String, int> monthlyTotalMap = {};

    final now = DateTime.now();

    for (int i = 0; i < transactions.length; i++) {
      final item = transactions[i];
      if (item.category == '수입') continue;

      final date = item.date.substring(0, 7);

      monthlyTotalMap.update(
        date,
            (value) => value + item.amount,
        ifAbsent: () => item.amount,
      );
    }

    List<double> expenses = [];
    List<String> labels = [];

    for (int i = 5; i >= 0; i--) {
      final monthAgo = DateTime(now.year, now.month - i, 1);
      final monthKey = '${monthAgo.year}-${monthAgo.month.toString().padLeft(2, '0')}';
      final shortLabel = '${monthAgo.month}월';

      final amount = (monthlyTotalMap[monthKey] ?? 0).toDouble();

      expenses.add(amount);
      labels.add(shortLabel);
    }

    if (expenses.isEmpty) {
      expenses = List.filled(6, 0.0);
    }

    setState(() {
      _monthlyExpenses = expenses;
      _monthLabels = labels;
      _isLoading = false;
    });
  }

  List<BarChartGroupData> getBarGroups() {
    const barWidth = 25.0;

    return _monthlyExpenses.asMap().entries.map((entry) {
      final x = entry.key;
      final y = entry.value;

      return BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: y,
            color: const Color(0xFF0055C5),
            width: barWidth,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
        ],
        showingTooltipIndicators: y > 0 ? [0] : [],
      );
    }).toList();
  }

  Widget getTitles(double value, TitleMeta meta) {
    if (value == meta.max) return const SizedBox();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text('₩ ${value.toInt() ~/ 1000}k', style: const TextStyle(fontSize: 10)),
    );
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final maxExpense = _monthlyExpenses.reduce((a, b) => a > b ? a : b);
    final finalMaxY = (maxExpense <= 0 ? 10000.0 : maxExpense * 1.2);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '월별 지출 추이 (최근 6개월)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0055C5)),
          ),
          const Divider(),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                maxY: finalMaxY,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.blueGrey,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '₩ ${rod.toY.toInt().toString()}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      getTitlesWidget: getTitles,
                      interval: finalMaxY / 5,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 4,
                          child: Text(_monthLabels[value.toInt()], style: const TextStyle(fontSize: 12)),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(color: Colors.black, width: 1),
                    left: BorderSide(color: Colors.transparent),
                    right: BorderSide(color: Colors.transparent),
                    top: BorderSide(color: Colors.transparent),
                  ),
                ),
                gridData: const FlGridData(
                  show: false,
                ),
                barGroups: getBarGroups(),
                alignment: BarChartAlignment.spaceAround,
                groupsSpace: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum Period { oneMonth, threeMonths, sixMonths, all }

class CategoryBarChart extends StatelessWidget {
  final Map<String, int> categoryMap;
  final int totalExpenditure;

  const CategoryBarChart({
    super.key,
    required this.categoryMap,
    required this.totalExpenditure,
  });

  static const List<Color> colorList = [
    Color(0xFF0055C5),
    Color(0xFF4CAF50),
    Color(0xFFFF9800),
    Color(0xFFE91E63),
    Color(0xFF9C27B0),
    Color(0xFF00BCD4),
    Color(0xFFFFEB3B),
  ];

  List<BarChartGroupData> getBarGroups(Map<String, int> map) {
    final sortedEntries = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    int index = 0;

    return sortedEntries.map((entry) {
      final amount = entry.value.toDouble();
      final currentIndex = index;
      index++;

      return BarChartGroupData(
        x: currentIndex,
        barRods: [
          BarChartRodData(
            toY: amount,
            color: colorList[currentIndex % colorList.length],
            width: 25,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }

  Widget _getCategoryTitles(double value, TitleMeta meta) {
    if (value.toInt() != value) return const SizedBox();

    final sortedEntries = categoryMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final actualIndex = value.toInt();

    if (actualIndex >= 0 && actualIndex < sortedEntries.length) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 4,
        child: Text(
          sortedEntries[actualIndex].key,
          style: const TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        ),
      );
    }
    return const SizedBox();
  }

  Widget _getAmountTitles(double value, TitleMeta meta) {
    if (value == 0 || value == meta.max) return const SizedBox();

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text('₩ ${value.toInt() ~/ 1000}k', style: const TextStyle(fontSize: 10)),
    );
  }


  @override
  Widget build(BuildContext context) {
    if (categoryMap.isEmpty || totalExpenditure == 0) {
      return const Center(child: Text("지정된 기간 동안 지출 내역이 없습니다.", style: TextStyle(color: Colors.grey)));
    }

    final maxAmount = categoryMap.values.reduce((a, b) => a > b ? a : b).toDouble();
    final finalMaxY = (maxAmount <= 0 ? 10000.0 : maxAmount * 1.2);
    final double interval = (finalMaxY / 5).ceilToDouble().clamp(1000, double.infinity);


    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '카테고리별 지출 순위',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE91E63)),
          ),
          const Divider(),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(

                maxY: finalMaxY,
                minY: 0,

                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.redAccent,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final category = categoryMap.entries.toList()
                        ..sort((a, b) => b.value.compareTo(a.value));

                      final actualIndex = group.x;

                      return BarTooltipItem(
                        '${category[actualIndex].key}\n₩ ${rod.toY.toInt().toString()}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),

                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: _getAmountTitles,
                      interval: interval,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: _getCategoryTitles,
                      interval: 1,
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),

                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(color: Colors.black, width: 1),
                    left: BorderSide(color: Colors.black, width: 1),
                    right: BorderSide(color: Colors.transparent),
                    top: BorderSide(color: Colors.transparent),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  drawHorizontalLine: true,
                  horizontalInterval: interval,
                ),

                barGroups: getBarGroups(categoryMap),

                alignment: BarChartAlignment.spaceAround,
                groupsSpace: 10,

              ),
              swapAnimationDuration: const Duration(milliseconds: 150),
              swapAnimationCurve: Curves.linear,
            ),
          ),
        ],
      ),
    );
  }
}

class ChartPageContent extends StatefulWidget {
  const ChartPageContent({super.key});

  @override
  State<ChartPageContent> createState() => _ChartPageContentState();
}

class _ChartPageContentState extends State<ChartPageContent> {
  Period _selectedPeriod = Period.oneMonth;
  bool _isLoading = true;
  Map<String, int> _categoryExpenditures = {};
  int _totalExpenditure = 0;

  @override
  void initState() {
    super.initState();
    _loadCategoryExpendituresByPeriod(_selectedPeriod);
  }

  DateTime _getStartDate(Period period) {
    final now = DateTime.now();
    switch (period) {
      case Period.oneMonth:
        return DateTime(now.year, now.month, 1);
      case Period.threeMonths:
        return DateTime(now.year, now.month - 2, 1);
      case Period.sixMonths:
        return DateTime(now.year, now.month - 5, 1);
      case Period.all:
      default:
        return DateTime(2000, 1, 1);
    }
  }

  Future<void> _loadCategoryExpendituresByPeriod(Period period) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final startDate = _getStartDate(period);
      final allTransactions = dbHelper.getAllTransactions();
      Map<String, int> categoryMap = {};
      int total = 0;

      for (var item in allTransactions) {
        if (item.category == '수입') continue;

        final dateParts = item.date.split('-');
        if (dateParts.length < 3) continue;

        final itemDate = DateTime(
          int.tryParse(dateParts[0]) ?? 0,
          int.tryParse(dateParts[1]) ?? 0,
          int.tryParse(dateParts[2]) ?? 0,
        );

        if (itemDate.isAfter(startDate.subtract(const Duration(days: 1))) && itemDate.isBefore(DateTime.now().add(const Duration(days: 1)))) {
          total += item.amount;
          categoryMap.update(
            item.category,
                (value) => value + item.amount,
            ifAbsent: () => item.amount,
          );
        }
      }

      final sortedCategories = Map.fromEntries(
        categoryMap.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)),
      );

      setState(() {
        _categoryExpenditures = sortedCategories;
        _totalExpenditure = total;
        _isLoading = false;
      });

    } catch (e) {
      print('Error loading chart data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const MonthlyExpenseChart(),

          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: Period.values.map((period) {
                String label;
                switch (period) {
                  case Period.oneMonth:
                    label = '1개월';
                    break;
                  case Period.threeMonths:
                    label = '3개월';
                    break;
                  case Period.sixMonths:
                    label = '6개월';
                    break;
                  case Period.all:
                    label = '전체';
                    break;
                }
                return ChoiceChip(
                  label: Text(label),
                  selected: _selectedPeriod == period,
                  selectedColor: const Color(0xFFE91E63).withOpacity(0.8),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedPeriod = period;
                        _loadCategoryExpendituresByPeriod(period);
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ),

          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : CategoryBarChart(
            categoryMap: _categoryExpenditures,
            totalExpenditure: _totalExpenditure,
          ),
        ],
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
    HomePageContent(),
    ChartPageContent(),
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
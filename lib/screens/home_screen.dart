import 'package:flutter/material.dart';
import 'package:haruharu/system/detail_action.dart';
import 'package:haruharu/system/photo_entry.dart';
import 'photo_detail_screen.dart';
import 'upload_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<PhotoEntry> _photoEntries = [
    //샘플
    PhotoEntry(date: '2025. 9. 28', note: '첫 번째 일기입니다.'),
  ];

  void _addPhotoEntry(PhotoEntry entry) {
    setState(() {
      _photoEntries.insert(0, entry); // 최신 항목을 맨 앞에 추가
    });
  }

  Map<String, List<PhotoEntry>> _groupEntriesByMonth() {
    final Map<String, List<PhotoEntry>> grouped = {};
    for (var entry in _photoEntries) {
      final parts = entry.date.split('.');
      if (parts.length >= 2) {
        final yearMonth = '${parts[0].trim()}년 ${parts[1].trim()}월';
        if (!grouped.containsKey(yearMonth)) {
          grouped[yearMonth] = [];
        }
        grouped[yearMonth]!.add(entry);
      }
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedEntries = _groupEntriesByMonth();
    final monthTitles = groupedEntries.keys.toList();

    const Color primaryColor = Color(0xFFB3E0FF);
    const Color lightBgColor = Color(0xFFF0F8FF);
    const Color accentColor = Color(0xFF7AD1FF);
    const Color darkTextColor = Color(0xFF1A237E);
    const Color inactiveColor = Color(0xFFDEDEDE);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          '하루 한 장',
          style: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildRecallSection(primaryColor, darkTextColor, inactiveColor),
          const SizedBox(height: 16),
          ...monthTitles.map((title) {
            final entries = groupedEntries[title]!;
            return _buildPhotoSection(context, title, entries, darkTextColor, inactiveColor);
          }).toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newEntry = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UploadScreen(),
            ),
          );

          if (newEntry != null && newEntry is PhotoEntry) {
            _addPhotoEntry(newEntry);
          }
        },
        backgroundColor: accentColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // (이하 _buildRecallSection, _RecallBox 클래스 코드는 동일)
  Widget _buildRecallSection(Color primaryColor, Color darkTextColor, Color inactiveColor) {
    const Color lightBgColor = Color(0xFFF0F8FF); // 내부 정의 필요

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: lightBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: inactiveColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('회상',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RecallBox(title: '일 년 전 오늘', boxColor: inactiveColor, textColor: darkTextColor),
              _RecallBox(title: '한 달 전 오늘', boxColor: inactiveColor, textColor: darkTextColor),
              _RecallBox(title: '일주일 전 오늘', boxColor: inactiveColor, textColor: darkTextColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection(BuildContext context, String title, List<PhotoEntry> entries, Color darkTextColor, Color inactiveColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3열
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: entries.length, // 리스트의 실제 항목 개수 사용
          itemBuilder: (context, index) {
            final entry = entries[index];
            return GestureDetector(
              onTap: () async {
                final action = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoDetailScreen(
                      imageBytes: entry.imageBytes, // 실제 데이터 전달
                      date: entry.date,              // 실제 데이터 전달
                      note: entry.note,
                      originalEntry: entry, // 실제 데이터 전달
                    ),
                  ),
                );
                // 2. 반환된 결과(action)를 처리합니다.
                if (action is DetailAction && action == DetailAction.delete) {
                  // 3. 삭제 액션일 경우 리스트에서 해당 항목을 제거합니다.
                  setState(() {
                    _photoEntries.remove(entry);
                  });
                  // 4. (선택 사항) 사용자에게 삭제 완료 메시지를 보여줍니다.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('기록이 삭제되었습니다.')),
                  );
                } else if (action is PhotoEntry) {
                  final modifiedEntry = action;
                  setState(() {
                    // 리스트에서 기존 항목을 찾아서(index) 수정된 항목으로 교체합니다.
                    final entryIndex = _photoEntries.indexOf(entry);
                    if (entryIndex != -1) {
                      _photoEntries[entryIndex] = modifiedEntry;
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('기록이 수정되었습니다.')),
                  );
                }
              },
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  color: inactiveColor,
                  child: entry.imageBytes == null
                      ? Center(
                    child: Text(
                      entry.date.split('.').last, // 날짜의 '일' 부분 표시
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                      : Image.memory(
                    entry.imageBytes!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16), // 섹션 간 간격
      ],
    );
  }

}



class _RecallBox extends StatelessWidget {
  final String title;
  final Color boxColor;
  final Color textColor;

  const _RecallBox({required this.title, required this.boxColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
              title, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
        ),
      ),
    );
  }
}
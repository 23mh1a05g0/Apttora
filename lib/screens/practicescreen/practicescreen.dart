import 'package:flutter/material.dart';
import 'practice_test_screen.dart';

class PracticeScreen extends StatefulWidget {
  final int xpPoints;
  final Function(int) addXp;

  const PracticeScreen({
    super.key,
    required this.xpPoints,
    required this.addXp,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late int currentXp;

  @override
  void initState() {
    super.initState();
    currentXp = widget.xpPoints;
  }

  void _addXp(int xp) {
    setState(() {
      currentXp += xp;
    });
    widget.addXp(xp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Practice Tests",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF667EEA),
                Color(0xFF764BA2),
              ],
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFD166),
                  Color(0xFFFFB900),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "$currentXp XP",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Category:",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildCategorySection("Aptitude", 0),
                  _buildCategorySection("Reasoning", 1),
                  _buildCategorySection("Verbal", 2),
                  _buildCategorySection("GK", 3),
                  _buildCategorySection("Puzzles", 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(String category, int colorIndex) {
    final List<LinearGradient> categoryGradients = [
      const LinearGradient(
        colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      const LinearGradient(
        colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      const LinearGradient(
        colors: [Color(0xFFFA709A), Color(0xFFFEE140)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      const LinearGradient(
        colors: [Color(0xFFA8C0FF), Color(0xFF3F2B96)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      const LinearGradient(
        colors: [Color(0xFFFD6585), Color(0xFF0D25B9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: categoryGradients[colorIndex],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildDifficultyLevel(category, "Easy", 10, colorIndex),
            _buildDifficultyLevel(category, "Moderate", 15, colorIndex),
            _buildDifficultyLevel(category, "Hard", 20, colorIndex),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyLevel(String category, String difficulty, int xpPerQuestion, int colorIndex) {
    final Map<String, Map<String, dynamic>> difficultyStyles = {
      "Easy": {
        "gradient": const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        "textColor": Colors.white,
      },
      "Moderate": {
        "gradient": const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFFFC107)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        "textColor": Colors.white,
      },
      "Hard": {
        "gradient": const LinearGradient(
          colors: [Color(0xFFF44336), Color(0xFFFF5722)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        "textColor": Colors.white,
      },
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: difficultyStyles[difficulty]!["gradient"] as LinearGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "$difficulty Level • $xpPerQuestion XP/question",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: difficultyStyles[difficulty]!["textColor"] as Color,
            ),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.2,
          ),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  _startPracticeTest(category, difficulty, xpPerQuestion, index + 1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                ),
                child: Text(
                  "Test ${index + 1}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getCategoryColor(colorIndex),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Color _getCategoryColor(int colorIndex) {
    final List<Color> categoryColors = [
      const Color(0xFF4FACFE),
      const Color(0xFF43E97B),
      const Color(0xFFFA709A),
      const Color(0xFFA8C0FF),
      const Color(0xFFFD6585),
    ];
    return categoryColors[colorIndex];
  }

  void _startPracticeTest(String category, String difficulty, int xpPerQuestion, int testNumber) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => PracticeTestScreen(
          category: category,
          difficulty: difficulty,
          testNumber: testNumber,
          xpPerQuestion: xpPerQuestion,
          addXp: _addXp,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    ).then((_) {
      setState(() {});
    });
  }
}
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/question_data.dart';
import '../models/question_model.dart';
import 'result_screen.dart';

class MockTestScreen extends StatefulWidget {
  final String level;

  const MockTestScreen({super.key, required this.level});

  @override
  State<MockTestScreen> createState() => _MockTestScreenState();
}

class _MockTestScreenState extends State<MockTestScreen>
    with TickerProviderStateMixin {
  late List<Question> _questions;
  final Map<int, int> _selectedAnswers = {};
  late AnimationController _timerController;
  late PageController _pageController;
  late AnimationController _backgroundController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _questions = QuestionData.getRandomQuestions(widget.level, 10);
    _pageController = PageController();
    _setupTimer();
    _setupBackgroundAnimation();
  }

  void _setupBackgroundAnimation() {
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  void _setupTimer() {
    final duration = _getDurationForLevel();
    _timerController = AnimationController(vsync: this, duration: duration)
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _handleAnswer(-1);
        }
      });
  }

  Duration _getDurationForLevel() {
    switch (widget.level.toLowerCase()) {
      case 'easy':
        return const Duration(seconds: 60);
      case 'medium':
        return const Duration(seconds: 80);
      case 'hard':
        return const Duration(seconds: 100);
      default:
        return const Duration(seconds: 60);
    }
  }

  void _handleAnswer(int selectedIndex) {
    _timerController.stop();
    _selectedAnswers[_currentIndex] = selectedIndex;
    Timer(const Duration(milliseconds: 500), () {
      if (_currentIndex < _questions.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        setState(() => _currentIndex++);
        _setupTimer();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              questions: _questions,
              selectedAnswers: _selectedAnswers,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timerController.dispose();
    _pageController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [
              Color(0xFF4A00E0), // Deep indigo-purple
              Color(0xFF8E2DE2), // Vibrant purple
              Color(0xFF2575FC), // Bright blue
              Color(0xFF1E3C72), // Deep ocean blue
              Color(0xFF667EEA), // Soft blue-purple
            ],
            stops: [0.0, 0.3, 0.6, 0.9, 1.0],
          ),
        ),
        child: AnimatedBuilder(
          animation: _backgroundController,
          builder: (context, child) {
            return CustomPaint(
              painter: AnimatedBackgroundPainter(_backgroundController.value),
              size: Size.infinite,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: Text(
                    "${widget.level} Level Test",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  foregroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _Header(
                        controller: _timerController,
                        currentIndex: _currentIndex,
                        totalQuestions: _questions.length,
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _questions.length,
                          itemBuilder: (context, index) {
                            return _QuestionCard(
                              question: _questions[index],
                              onAnswerSelected: (selectedIndex) =>
                                  _handleAnswer(selectedIndex),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AnimatedBackgroundPainter extends CustomPainter {
  final double animationValue;

  AnimatedBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withOpacity(0.05),
          Colors.white.withOpacity(0.02),
          Colors.white.withOpacity(0.05),
        ],
        stops: const [0.0, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw subtle floating particles/orbs
    final random = math.Random(42); // Seeded for consistency
    for (int i = 0; i < 20; i++) {
      final x =
          (size.width * 0.1 +
              (size.width * 0.8 * random.nextDouble()) +
              animationValue * size.width * 0.5) %
          size.width;
      final y =
          (size.height * 0.1 +
              (size.height * 0.8 * random.nextDouble()) +
              animationValue * size.height * 0.3) %
          size.height;
      final radius = 2 + random.nextDouble() * 8;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = Colors.white.withOpacity(0.1 + random.nextDouble() * 0.2)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2.0),
      );
    }

    // Subtle wave lines for depth
    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (double x = 0; x < size.width; x += 20) {
      final y =
          size.height * 0.7 +
          math.sin((x / 100 + animationValue * 2 * math.pi)) * 30 +
          math.sin((x / 50 + animationValue * 4 * math.pi)) * 10;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Header extends StatelessWidget {
  final AnimationController controller;
  final int currentIndex;
  final int totalQuestions;

  const _Header({
    required this.controller,
    required this.currentIndex,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Question ${currentIndex + 1}/$totalQuestions',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final remaining =
                (controller.duration! * (1 - controller.value)).inSeconds;
            final minutes = (remaining ~/ 60).toString().padLeft(2, '0');
            final seconds = (remaining % 60).toString().padLeft(2, '0');
            return SizedBox(
              width: 60,
              height: 60,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: 1 - controller.value,
                    strokeWidth: 6,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      controller.value > 0.7
                          ? Colors.redAccent
                          : Colors.yellowAccent,
                    ),
                  ),
                  Center(
                    child: Text(
                      '$minutes:$seconds',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _QuestionCard extends StatefulWidget {
  final Question question;
  final ValueChanged<int> onAnswerSelected;

  const _QuestionCard({required this.question, required this.onAnswerSelected});

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Text(
            widget.question.question,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(widget.question.options.length, (index) {
          return _OptionTile(
            optionText: widget.question.options[index],
            isSelected: _selectedIndex == index,
            onTap: () {
              if (_selectedIndex == null) {
                setState(() => _selectedIndex = index);
                widget.onAnswerSelected(index);
              }
            },
          );
        }),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String optionText;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.optionText,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.3)
              : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.yellowAccent
                : Colors.white.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? Colors.yellowAccent : Colors.white70,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                optionText,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

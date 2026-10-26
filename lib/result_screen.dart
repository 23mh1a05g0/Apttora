import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import '../models/question_model.dart';

class ResultScreen extends StatefulWidget {
  final List<Question> questions;
  final Map<int, int> selectedAnswers;

  const ResultScreen({
    super.key,
    required this.questions,
    required this.selectedAnswers,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int correctAnswers = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      if (widget.selectedAnswers[i] == widget.questions[i].correctAnswer) {
        correctAnswers++;
      }
    }
    final int wrongAnswers = widget.questions.length - correctAnswers;

    final Map<String, double> dataMap = {
      "Correct": correctAnswers.toDouble(),
      "Wrong": wrongAnswers.toDouble(),
    };

    final List<Color> colorList = [Colors.green.shade400, Colors.red.shade400];

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          return CustomPaint(
            painter: AnimatedBackgroundPainter(_backgroundController.value),
            size: Size.infinite,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.5, -0.5),
                  radius: 1.0,
                  colors: [
                    Colors.white,
                    Colors.grey[100]!,
                    Colors.grey[50]!,
                    Colors.white.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.4, 0.8, 1.0],
                ),
              ),
              child: child,
            ),
          );
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              "Your Result",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.grey[800],
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0.95), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          body: FadeTransition(
            opacity: CurvedAnimation(
              parent: _fadeController,
              curve: Curves.easeIn,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ScoreSummaryCard(
                      dataMap: dataMap,
                      colorList: colorList,
                      correctAnswers: correctAnswers,
                      wrongAnswers: wrongAnswers,
                      totalQuestions: widget.questions.length,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Review Your Answers",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(widget.questions.length, (index) {
                      final question = widget.questions[index];
                      final isCorrect =
                          widget.selectedAnswers[index] ==
                          question.correctAnswer;
                      final selectedOptionIndex = widget.selectedAnswers[index];
                      return _ReviewQuestionTile(
                        question: question,
                        questionIndex: index,
                        isCorrect: isCorrect,
                        selectedOptionIndex: selectedOptionIndex,
                      );
                    }),
                    const SizedBox(height: 24),
                    const _HomeButton(),
                  ],
                ),
              ),
            ),
          ),
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
    final random = math.Random(42);

    for (int i = 0; i < 12; i++) {
      final x =
          (size.width * 0.1 +
              (size.width * 0.8 * random.nextDouble()) +
              animationValue * size.width * 0.4) %
          size.width;
      final y =
          (size.height * 0.1 +
              (size.height * 0.8 * random.nextDouble()) +
              animationValue * size.height * 0.25) %
          size.height;
      final radius = 2 + random.nextDouble() * 6;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = Colors.green.withOpacity(0.04 + random.nextDouble() * 0.08)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2.0),
      );
    }

    final wavePaint = Paint()
      ..color = Colors.deepPurple.withOpacity(0.02)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (double x = 0; x < size.width; x += 25) {
      final y =
          size.height * 0.6 +
          math.sin((x / 120 + animationValue * 1.5 * math.pi)) * 20 +
          math.sin((x / 60 + animationValue * 3 * math.pi)) * 8;
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

// --- ENHANCED WIDGETS ---

class _ScoreSummaryCard extends StatelessWidget {
  final Map<String, double> dataMap;
  final List<Color> colorList;
  final int correctAnswers;
  final int wrongAnswers;
  final int totalQuestions;

  const _ScoreSummaryCard({
    required this.dataMap,
    required this.colorList,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (correctAnswers / totalQuestions * 100).toStringAsFixed(
      0,
    );
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.8),
            Colors.grey[50]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.deepPurple.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: PieChart(
                dataMap: dataMap,
                animationDuration: const Duration(milliseconds: 1200),
                chartRadius: MediaQuery.of(context).size.width / 4.5,
                colorList: colorList,
                chartType: ChartType.ring,
                ringStrokeWidth: 25,
                legendOptions: const LegendOptions(showLegends: false),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValues: false,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Score",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "$percentage% Correct",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: correctAnswers > wrongAnswers
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
                const SizedBox(height: 16),
                _StatRow(
                  icon: Icons.check_circle,
                  color: Colors.green,
                  title: "Correct",
                  value: "$correctAnswers/$totalQuestions",
                ),
                const SizedBox(height: 12),
                _StatRow(
                  icon: Icons.cancel,
                  color: Colors.red,
                  title: "Wrong",
                  value: "$wrongAnswers/$totalQuestions",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;

  const _StatRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewQuestionTile extends StatefulWidget {
  final Question question;
  final int questionIndex;
  final bool isCorrect;
  final int? selectedOptionIndex;

  const _ReviewQuestionTile({
    required this.question,
    required this.questionIndex,
    required this.isCorrect,
    required this.selectedOptionIndex,
  });

  @override
  State<_ReviewQuestionTile> createState() => _ReviewQuestionTileState();
}

class _ReviewQuestionTileState extends State<_ReviewQuestionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = widget.isCorrect ? Colors.green : Colors.red;
    final titleIcon = widget.isCorrect ? Icons.check_circle : Icons.cancel;
    final cardGradient = widget.isCorrect
        ? LinearGradient(
            colors: [Colors.green.withOpacity(0.1), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : LinearGradient(
            colors: [Colors.red.withOpacity(0.1), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: titleColor.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: titleColor.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        onExpansionChanged: (expanded) {
          if (expanded) {
            _expandController.forward();
          } else {
            _expandController.reverse();
          }
        },
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: titleColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(titleIcon, color: titleColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Question ${widget.questionIndex + 1}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey[800],
                  shadows: [
                    Shadow(
                      color: titleColor.withOpacity(0.3),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        children: [
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.question.question,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.selectedOptionIndex != null &&
                      widget.selectedOptionIndex != -1)
                    _AnswerRow(
                      label: "Your answer:",
                      text:
                          widget.question.options[widget.selectedOptionIndex!],
                      isCorrect: widget.isCorrect,
                    ),
                  if (!widget.isCorrect)
                    _AnswerRow(
                      label: "Correct answer:",
                      text: widget
                          .question
                          .options[widget.question.correctAnswer],
                      isCorrect: true,
                    ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.withOpacity(0.05),
                          Colors.grey[100]!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.deepPurple.withOpacity(0.1),
                      ),
                    ),
                    child: Text(
                      "Explanation: ${widget.question.explanation}",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerRow extends StatelessWidget {
  final String label;
  final String text;
  final bool isCorrect;

  const _AnswerRow({
    required this.label,
    required this.text,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(isCorrect ? Icons.check : Icons.close, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label $text",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  const _HomeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.home, size: 20),
        label: Text(
          "Back to Home",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.deepPurple.withOpacity(0.3)),
          ),
          elevation: 8,
          shadowColor: Colors.deepPurple.withOpacity(0.4),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PracticeExplanationScreen extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final List<int?> userAnswers;
  final int xpPerQuestion;

  const PracticeExplanationScreen({
    super.key,
    required this.questions,
    required this.userAnswers,
    required this.xpPerQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Question Explanations",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4361EE),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4361EE),
              Color(0xFF3A0CA3),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Container(
            color: Colors.grey[50],
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                final userAnswer = userAnswers[index];
                final correctAnswer = question['correctAnswer'];
                final isCorrect = userAnswer == correctAnswer;
                final options = List<String>.from(question['options']);

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ExpansionTile(
                    initiallyExpanded: index == 0,
                    tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    collapsedIconColor: Colors.grey[600],
                    iconColor: const Color(0xFF4361EE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isCorrect 
                            ? const Color(0xFF4CAF50).withOpacity(0.15)
                            : const Color(0xFFF44336).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCorrect ? Icons.check_rounded : Icons.close_rounded,
                        color: isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                        size: 20,
                      ),
                    ),
                    title: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4361EE).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Q${index + 1}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4361EE),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isCorrect ? "Correct" : "Incorrect",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "XP: ${isCorrect ? xpPerQuestion : 0}",
                        style: TextStyle(
                          color: isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    children: [
                      Divider(
                        height: 1,
                        color: Colors.grey[300],
                        indent: 20,
                        endIndent: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Question
                            Text(
                              question['question'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color(0xFF2D3047),
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Answer comparison
                            _buildAnswerRow(
                              "Your Answer",
                              userAnswer != null ? options[userAnswer] : 'Not attempted',
                              isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                              Icons.person_outline,
                            ),
                            const SizedBox(height: 12),
                            
                            _buildAnswerRow(
                              "Correct Answer",
                              options[correctAnswer],
                              const Color(0xFF4CAF50),
                              Icons.check_circle_outline,
                            ),
                            const SizedBox(height: 20),
                            
                            // Explanation section
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[200]!,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.lightbulb_outline,
                                        color: const Color(0xFF4361EE),
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Explanation",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    question['explanation'],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerRow(String label, String answer, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  answer,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
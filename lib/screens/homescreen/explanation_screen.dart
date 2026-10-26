import 'package:flutter/material.dart';

class ExplanationScreen extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final List<int?> userAnswers;

  const ExplanationScreen({super.key, required this.questions, required this.userAnswers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFE8F5E9), // Very Light Green (top)
              const Color(0xFFC8E6C9), // Light Green (middle)
              const Color(0xFFA5D6A7), // Medium Light Green (bottom)
            ],
          ),
        ),
        child: Column(
          children: [
            // Custom App Bar with Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF2E7D32), // Dark Green
                    const Color(0xFF4CAF50), // Green
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  "Question Explanations",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final userAnswer = userAnswers[index];
                  final correctAnswer = question['correctAnswer'];
                  final isCorrect = userAnswer == correctAnswer;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withOpacity(0.95),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: index == 0,
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                        // contentPadding: const EdgeInsets.all(0), // Remove or comment out this line
                      title: Text(
                        "Question ${index + 1}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        isCorrect ? "Correct" : "Incorrect",
                        style: TextStyle(
                          color: isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      leading: Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isCorrect 
                                ? [const Color(0xFF4CAF50), const Color(0xFF66BB6A)]
                                : [const Color(0xFFF44336), const Color(0xFFEF5350)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isCorrect ? Icons.check : Icons.close,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black54,
                        ),
                      ),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Question Text
                              Text(
                                question['question'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Answers Section
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    // Your Answer
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: userAnswer == correctAnswer 
                                                ? const Color(0xFF4CAF50).withOpacity(0.1)
                                                : const Color(0xFFF44336).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            "Your Answer",
                                            style: TextStyle(
                                              color: userAnswer == correctAnswer 
                                                  ? const Color(0xFF4CAF50)
                                                  : const Color(0xFFF44336),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            userAnswer != null 
                                                ? question['options'][userAnswer]
                                                : 'Not attempted',
                                            style: TextStyle(
                                              color: userAnswer == correctAnswer 
                                                  ? const Color(0xFF4CAF50)
                                                  : const Color(0xFFF44336),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    
                                    // Correct Answer
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF4CAF50).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            "Correct Answer",
                                            style: TextStyle(
                                              color: Color(0xFF4CAF50),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            question['options'][correctAnswer],
                                            style: const TextStyle(
                                              color: Color(0xFF4CAF50),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Explanation Section
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2196F3).withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF2196F3).withOpacity(0.2),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.lightbulb_outline,
                                          color: Colors.amber[700],
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          "Explanation:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[800],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      question['explanation'],
                                      style: TextStyle(
                                        color: Colors.grey[700],
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
          ],
        ),
      ),
    );
  }
}
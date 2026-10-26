import 'package:flutter/material.dart';
import 'video_screen.dart';

class TopicScreen extends StatefulWidget {
  final String category;
  final Function(int) addXp;

  const TopicScreen({super.key, required this.category, required this.addXp});

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  final Map<String, List<Map<String, dynamic>>> topicsData = {
    // Your topics data will go here
    "Aptitude": [
      {
        "name": "Numbers",
        "videoId": "exAPyTTZ2uU",
        "description": "Understand basics and properties of numbers",
      },
      {
        "name": "Percentage",
        "videoId": "LqnR90vECcQ",
        "description":
            "Learn how to calculate percentages and solve percentage problems",
      },
      {
        "name": "Profit and Loss",
        "videoId": "i8EcBW2wE9o",
        "description": "Learn to calculate profit, loss, and discounts",
      },
      {
        "name": "Average",
        "videoId": "JcxCzbDujRE",
        "description": "Calculate averages and apply in problem solving",
      },
      {
        "name": "Ratio and Proportion",
        "videoId": "jfoJBivWlnQ",
        "description":
            "Understand ratios and proportions with practical examples",
      },
      {
        "name": "Mixture and Alligation",
        "videoId": "Bn3sGdiyP44",
        "description": "Solve problems on mixture and alligation",
      },
      {
        "name": "Time and Work",
        "videoId": "KE7tQf9spPg",
        "description":
            "Master time and work problems with efficient techniques",
      },
      {
        "name": "Time Speed Distance",
        "videoId": "jzNxXm5twx4",
        "description":
            "Learn formulas and shortcuts for time, speed, and distance",
      },
      {
        "name": "Pipes and Cisterns",
        "videoId": "tlZNjIje16g",
        "description": "Solve problems related to pipes and cisterns",
      },
      {
        "name": "Algebra",
        "videoId": "evqEtEFlImA",
        "description": "Basics of algebra and equations",
      },
      {
        "name": "Trigonometry, Height, and Distance",
        "videoId": "zTUy2xgrNe4",
        "description":
            "Learn trigonometry concepts applied to height and distance",
      },
      {
        "name": "Geometry",
        "videoId": "/0uU2Aq3W3jQ",
        "description": "Understand geometric shapes and theorems",
      },
      {
        "name": "Probability",
        "videoId": "Wi_KugsVyaY",
        "description": "Basics and examples of probability",
      },
      {
        "name": "Permutation and Combination(PnC)",
        "videoId": "_s6zh8-yYvo",
        "description": "Learn permutations and combinations with examples",
      },
      {
        "name": "Age",
        "videoId": "WyDXGFfs2ho",
        "description": "Solve age-related problems",
      },
    ],
    "Reasoning": [
      {
        "name": "Verbal Reasoning",
        "videoId": "sU3vS2_Ba94",
        "description":
            "Syllogism, Blood Relations, Coding-Decoding and other verbal reasoning topics",
      },
      {
        "name": "Non-Verbal Reasoning",
        "videoId": "8SCGnWtGYGg",
        "description":
            "Visual Puzzles, Figure Analogies, Series and other non-verbal reasoning topics",
      },
      {
        "name": "Analytical Reasoning",
        "videoId": "H5dlJ9R5Fkg",
        "description":
            "Data Sufficiency, Seating Arrangements, Puzzles and analytical reasoning",
      },
    ],
    "Verbal": [
      {
        "name": "Verbal Reasoning",
        "videoId": "sU3vS2_Ba94",
        "description":
            "Syllogism, Blood Relations, Coding-Decoding and other verbal reasoning topics",
      },
      {
        "name": "Non-Verbal Reasoning",
        "videoId": "9l3A2f0q7Ls",
        "description":
            "Visual Puzzles, Figure Analogies, Series and other non-verbal reasoning topics",
      },
      {
        "name": "Analytical Reasoning",
        "videoId": "H5dlJ9R5Fkg",
        "description":
            "Data Sufficiency, Seating Arrangements, Puzzles and analytical reasoning",
      },
    ],
    "GK": [
      {
        "name": "Current Affairs",
        "videoId": "sU3vS2_Ba94",
        "description":
            "Important political, social, and economic events happening in the present time.",
      },
      {
        "name": "History",
        "videoId": "9l3A2f0q7Ls",
        "description":
            "Study of past events, civilizations, freedom movements, and historical figures.",
      },
      {
        "name": "Geography",
        "videoId": "H5dlJ9R5Fkg",
        "description":
            "Earth's physical features, countries, landscapes, climate, and natural resources.",
      },
      {
        "name": "Science and Technology",
        "videoId": "H5dlJ9R5Fkg",
        "description":
            "Innovations, discoveries, and advancements in science and modern technology.",
      },
      {
        "name": "Arts and Culture",
        "videoId": "H5dlJ9R5Fkg",
        "description":
            "Indian and world art forms, literature, traditions, festivals, and heritage.",
      },
      {
        "name": "Sports",
        "videoId": "H5dlJ9R5Fkg",
        "description":
            "National and international sports events, players, records, and achievements.",
      },
      {
        "name": "Indian Politics",
        "videoId": "H5dlJ9R5Fkg",
        "description":
            "Indian political system, constitution, government policies, and major leaders.",
      },
      {
        "name": "Economics",
        "videoId": "H5dlJ9R5Fkg",
        "description":
            "Basic concepts of economy, trade, banking, finance, and economic development.",
      },
    ],
    "Puzzles": [
      {
        "name": "Logical Reasoning",
        "videoId": "a1B2c3D4e5F",
        "description":
            "Problems that test your ability to think logically, analyze patterns, and solve reasoning puzzles.",
      },
      {
        "name": "Mathematical Puzzles",
        "videoId": "b2C3d4E5f6G",
        "description":
            "Challenging puzzles based on arithmetic, algebra, geometry, and number theory.",
      },
      {
        "name": "Word Puzzles",
        "videoId": "c3D4e5F6g7H",
        "description":
            "Crosswords, anagrams, and other puzzles that enhance vocabulary and language skills.",
      },
      {
        "name": "Riddles",
        "videoId": "d4E5f6G7h8I",
        "description":
            "Thought-provoking questions and tricky scenarios that require creative thinking to solve.",
      },
      {
        "name": "Visual Puzzles",
        "videoId": "e5F6g7H8i9J",
        "description":
            "Puzzles involving shapes, patterns, images, and optical illusions to test observation skills.",
      },
      {
        "name": "Brain Teasers",
        "videoId": "f6G7h8I9j0K",
        "description":
            "Fun and challenging problems designed to improve mental agility and problem-solving speed.",
      },
      {
        "name": "Puzzle Games",
        "videoId": "g7H8i9J0k1L",
        "description":
            "Interactive and strategy-based puzzles like Sudoku, Rubik's Cube, and logic games.",
      },
      {
        "name": "Critical Thinking Puzzles",
        "videoId": "h8I9j0K1l2M",
        "description":
            "Scenarios that require analyzing facts, drawing conclusions, and making reasoned decisions.",
      },
    ],
  };

  // Helper method to get gradient based on category
  LinearGradient _getCategoryGradient(String category) {
    switch (category.toLowerCase()) {
      case 'aptitude':
        return const LinearGradient(
          colors: [Color(0xFF4285F4), Color(0xFF669DF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'gk':
        return const LinearGradient(
          colors: [Color(0xFF34A853), Color(0xFF5DBE74)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'reasoning':
        return const LinearGradient(
          colors: [Color(0xFFFBBC05), Color(0xFFFCC934)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'puzzles':
        return const LinearGradient(
          colors: [Color(0xFFEA4335), Color(0xFFEE6A5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'verbal':
        return const LinearGradient(
          colors: [Color(0xFF009688), Color(0xFF4DB6AC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  List<Map<String, dynamic>> getTopics() {
    // Case-insensitive lookup
    final key = topicsData.keys.firstWhere(
      (key) => key.toLowerCase() == widget.category.toLowerCase(),
      orElse: () => widget.category,
    );

    final topics = topicsData[key] ?? [];

    // Debug output
    print('=== DEBUG INFO ===');
    print('Category received: "${widget.category}"');
    print('Category found in data: "$key"');
    print('Available keys: ${topicsData.keys.toList()}');
    print('Topics found: ${topics.length}');
    print('==================');

    return topics;
  }

  @override
  Widget build(BuildContext context) {
    final topics = getTopics();
    final categoryGradient = _getCategoryGradient(widget.category);

    // Show empty state if no topics found
    if (topics.isEmpty) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9), Color(0xFFA5D6A7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              // AppBar with gradient
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
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
                  title: Text(
                    "${widget.category} Topics",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          blurRadius: 2,
                          color: Colors.black26,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'No topics found for "${widget.category}"',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1D1D1D),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Available categories:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                topicsData.keys
                                    .map((key) => '"$key"')
                                    .join(', '),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9), Color(0xFFA5D6A7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // AppBar with gradient
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
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
                title: Text(
                  "${widget.category} Topics",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        blurRadius: 2,
                        color: Colors.black26,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: topics.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final topic = topics[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: categoryGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.play_circle_outline,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            topic["name"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 2,
                                  color: Colors.black26,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              topic["description"]!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 1,
                                    color: Colors.black26,
                                    offset: Offset(0.5, 0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoScreen(
                                  topic: topic["name"]!,
                                  videoId: topic["videoId"]!,
                                  category: widget.category,
                                  addXp: widget.addXp,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
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

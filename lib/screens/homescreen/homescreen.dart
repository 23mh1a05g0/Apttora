import 'dart:ui';
import 'package:flutter/material.dart';
import 'shop_screen.dart';
import 'topic_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int xpPoints = 0;

  void addXp(int points) {
    setState(() {
      xpPoints += points;
    });
  }

  void subtractXp(int points) {
    setState(() {
      xpPoints -= points;
    });
  }

  final List<Map<String, dynamic>> categories = const [
    {
      "title": "Aptitude",
      "icon": Icons.lightbulb,
      "color": Color(0xFF4285F4), // Google Blue
      "gradient": [Color(0xFF4285F4), Color(0xFF669DF6)],
    },
    {
      "title": "GK",
      "icon": Icons.flag,
      "color": Color(0xFF34A853), // Google Green
      "gradient": [Color(0xFF34A853), Color(0xFF5DBE74)],
    },
    {
      "title": "Reasoning",
      "icon": Icons.psychology,
      "color": Color(0xFFFBBC05), // Google Yellow
      "gradient": [Color(0xFFFBBC05), Color(0xFFFCC934)],
    },
    {
      "title": "Puzzles",
      "icon": Icons.extension,
      "color": Color(0xFFEA4335), // Google Red
      "gradient": [Color(0xFFEA4335), Color(0xFFEE6A5E)],
    },
    {
      "title": "Verbal",
      "icon": Icons.menu_book,
      "color": Color(0xFF009688), // Teal
      "gradient": [Color(0xFF009688), Color(0xFF4DB6AC)],
    },
  ];

  void _onCategoryTap(String category) {
    if (category == "Aptitude" || category == "Reasoning" || category == "Verbal" || category == "GK" || category == "Puzzles" || category == "Communication") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TopicScreen(category: category, addXp: addXp),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(category),
          content: const Text("This category is under development."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
        title: const Text(
          "Learning App",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 4.0,
                color: Colors.black26,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2E7D32), // Dark Green
                Color(0xFF4CAF50), // Green
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ShopScreen(xpPoints: xpPoints, subtractXp: subtractXp),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF9800), // Orange
                      Color(0xFFFFB74D), // Light Orange
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events, 
                        color: Colors.white, 
                        size: 20),
                    const SizedBox(width: 6),
                    Text(
                      "$xpPoints XP",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 2.0,
                            color: Colors.black26,
                            offset: Offset(1.0, 1.0),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE8F5E9), // Very Light Green
              Color(0xFFC8E6C9), // Light Green
              Color(0xFFA5D6A7), // Medium Light Green
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final item = categories[index];
            final gradientColors = item["gradient"] as List<Color>;
            
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Background with gradient and blur effect
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    
                    // Blur effect overlay
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                      child: Container(
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ),
                    
                    // Content
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _onCategoryTap(item["title"]),
                        splashColor: Colors.white.withOpacity(0.3),
                        highlightColor: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  item["icon"],
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item["title"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4.0,
                                      color: Colors.black26,
                                      offset: Offset(1.0, 1.0),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              _buildProgressItem("Learn : 0.0%"),
                              _buildProgressItem("Practice : 0.0%"),
                              _buildProgressItem("Test : 0.0%"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Decorative corner icon
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item["icon"],
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    // Shine effect overlay
                    Positioned(
                      top: -50,
                      left: -50,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 12,
          shadows: const [
            Shadow(
              blurRadius: 2.0,
              color: Colors.black26,
              offset: Offset(1.0, 1.0),
            ),
          ],
        ),
      ),
    );
  }
}
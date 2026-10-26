import 'package:apttora/mocktests.dart';
import 'package:apttora/screens/communication/communicationscreen.dart';
import 'package:apttora/screens/homescreen/homescreen.dart';
import 'package:apttora/screens/practicescreen/practicescreen.dart';
import 'package:apttora/screens/profilescreen/profilescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyBottomNav extends StatefulWidget {
  const MyBottomNav({super.key});

  @override
  State<MyBottomNav> createState() => _HomeState();
}

class _HomeState extends State<MyBottomNav> {
  int _currentIndex = 0;
  
  void _addXp(int points) {}
  void _subtractXp(int points) {}

  final List<Widget> _pages = [
    HomeScreen(),
    PracticeScreen(xpPoints: 0, addXp: (points) {}),
    CommunicationHome(),
    Mocktests(),
    ProfilePage(),
  ];
  String _getLabelForIndex(int index) {
    switch (index) {
      case 0: return "Home";
      case 1: return "Practice";
      case 2: return "Speak";
      case 3: return "Tests";
      case 4: return "Profile";
      default: return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.1),
              Colors.blue.withOpacity(0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: Colors.blue.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (index) {
              final bool isSelected = _currentIndex == index;
              final bool isMiddleTab = index == 2;
              
              if (isMiddleTab) {
                // Study-focused middle tab - smaller and compact
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 48, // Reduced from 60
                        height: 48, // Reduced from 60
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.orange,
                              Color(0xFFFFB74D), // Lighter Orange
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(isSelected ? 0.4 : 0.2),
                              blurRadius: isSelected ? 12 : 6,
                              spreadRadius: isSelected ? 1 : 0.5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white,
                            width: 3, // Slightly thinner border
                          ),
                        ),
                        child: Icon(
                          Icons.mic_external_on_rounded,
                          size: 22, // Reduced from 28
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      // Only show label for active middle tab
                      if (isSelected)
                        Text(
                          _getLabelForIndex(2),
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 10, // Smaller font
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      else
                        const SizedBox(height: 12), // Smaller placeholder
                    ],
                  ),
                );
              } else {
                // Regular tabs - smaller and compact
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10), // Reduced from 12
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue.withOpacity(0.15) : Colors.transparent,
                          shape: BoxShape.circle,
                          border: isSelected ? Border.all(
                            color: Colors.blue.withOpacity(0.3),
                            width: 1.5, // Thinner border
                          ) : null,
                        ),
                        child: Icon(
                          _getIconForIndex(index),
                          size: 20, // Reduced from 24 - all icons same size
                          color: isSelected ? Colors.blue : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 3),
                      // Only show label for active tabs
                      if (isSelected)
                        Text(
                          _getLabelForIndex(index),
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 10, // Smaller font
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      else
                        const SizedBox(height: 12), // Smaller placeholder
                    ],
                  ),
                );
              }
            }),
          ),
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0: return Icons.home_rounded;
      case 1: return Icons.quiz_rounded;
      case 2: return Icons.mic_external_on_rounded;
      case 3: return Icons.assignment_rounded;
      case 4: return Icons.person_rounded;
      default: return Icons.circle;
    }
  }
}
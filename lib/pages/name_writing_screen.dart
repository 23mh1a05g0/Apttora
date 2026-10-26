
import 'package:apttora/pages/signup_page.dart';
import 'package:flutter/material.dart';

class NameWritingScreen extends StatefulWidget {
  const NameWritingScreen({super.key});

  @override
  _NameWritingScreenState createState() => _NameWritingScreenState();
}

class _NameWritingScreenState extends State<NameWritingScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _writingAnimation;
  late Animation<double> _textRevealAnimation;
  late Animation<Color?> _inkAnimation;
  late Animation<Offset> _penPositionAnimation;
  
  String _displayText = '';
  final String _fullText = 'APTORA';
  int _currentIndex = 0;
  
  // Define writing paths for each letter (relative positions)
  final List<List<Offset>> _letterPaths = [
    // A - Triangle shape
    [Offset(0.2, 0.8), Offset(0.5, 0.2), Offset(0.8, 0.8), Offset(0.6, 0.5), Offset(0.4, 0.5)],
    // P - Half circle with vertical line
    [Offset(0.2, 0.2), Offset(0.2, 0.8), Offset(0.2, 0.5), Offset(0.5, 0.5), Offset(0.5, 0.2), Offset(0.2, 0.2)],
    // T - Horizontal and vertical
    [Offset(0.2, 0.2), Offset(0.8, 0.2), Offset(0.5, 0.2), Offset(0.5, 0.8)],
    // O - Circle
    [Offset(0.5, 0.2), Offset(0.8, 0.5), Offset(0.5, 0.8), Offset(0.2, 0.5), Offset(0.5, 0.2)],
    // R - P with diagonal
    [Offset(0.2, 0.2), Offset(0.2, 0.8), Offset(0.2, 0.5), Offset(0.5, 0.5), Offset(0.5, 0.2), Offset(0.2, 0.2), Offset(0.3, 0.7), Offset(0.6, 0.8)],
    // A - Triangle shape (same as first A)
    [Offset(0.2, 0.8), Offset(0.5, 0.2), Offset(0.8, 0.8), Offset(0.6, 0.5), Offset(0.4, 0.5)],
  ];

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    // Writing animation for the entire process
    _writingAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Text reveal animation
    _textRevealAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    // Ink flow animation
    _inkAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.deepPurple[900],
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Pen position animation
    _penPositionAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(1, 1),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    // Simulate writing letter by letter
    _controller.addListener(() {
      final double progress = _writingAnimation.value;
      final int targetIndex = (progress * _fullText.length).floor();
      
      if (targetIndex != _currentIndex && targetIndex < _fullText.length) {
        setState(() {
          _currentIndex = targetIndex;
          _displayText = _fullText.substring(0, _currentIndex + 1);
        });
      }
    });

    // Navigate automatically when animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpPage(), 
            ),
          );
        });
      }
    });
  }

  Offset _getCurrentPenPosition() {
    final double progress = _writingAnimation.value;
    final double letterProgress = (progress * _fullText.length) % 1;
    final int currentLetterIndex = (progress * _fullText.length).floor();
    
    if (currentLetterIndex >= _fullText.length) {
      return const Offset(0.9, 0.5); // Final position
    }
    
    final List<Offset> currentPath = _letterPaths[currentLetterIndex];
    final double segmentProgress = letterProgress * currentPath.length;
    final int segmentIndex = segmentProgress.floor();
    final double segmentFraction = segmentProgress - segmentIndex;
    
    if (segmentIndex >= currentPath.length - 1) {
      return currentPath.last;
    }
    
    // Linear interpolation between path points
    final Offset start = currentPath[segmentIndex];
    final Offset end = currentPath[segmentIndex + 1];
    
    return Offset(
      start.dx + (end.dx - start.dx) * segmentFraction,
      start.dy + (end.dy - start.dy) * segmentFraction,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final Offset penPosition = _getCurrentPenPosition();
          final double containerWidth = MediaQuery.of(context).size.width * 0.8;
          final double containerHeight = 150;
          
          return Stack(
            children: [
              // Background parchment texture
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFFFF8E1),
                      const Color(0xFFE6D7B8).withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Writing area container
                    Container(
                      width: containerWidth,
                      height: containerHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                        border: Border.all(
                          color: Colors.brown[300]!,
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Text display
                          Center(
                            child: Text(
                              _displayText,
                              style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5D4037),
                                fontFamily: 'Times New Roman',
                                letterSpacing: 8,
                              ),
                            ),
                          ),
                          
                          // Animated pen
                          Positioned(
                            left: penPosition.dx * containerWidth - 40,
                            top: penPosition.dy * containerHeight - 8,
                            child: Transform.rotate(
                              angle: _calculatePenAngle(penPosition),
                              child: Container(
                                width: 80,
                                height: 6,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black,
                                      Colors.grey[800]!,
                                      Colors.black,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    // Pen tip with ink
                                    Positioned(
                                      right: -4,
                                      top: -1,
                                      child: Container(
                                        width: 12,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: _inkAnimation.value,
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(2),
                                            bottomRight: Radius.circular(2),
                                          ),
                                        ),
                                      ),
                                    ),
                                    
                                    // Ink trail
                                    if (_inkAnimation.value != Colors.transparent)
                                      Positioned(
                                        right: 8,
                                        top: 2,
                                        child: Container(
                                          width: 40,
                                          height: 2,
                                          decoration: BoxDecoration(
                                            color: _inkAnimation.value!.withOpacity(0.7),
                                            borderRadius: BorderRadius.circular(1),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          
                          // Writing guide lines
                          Positioned(
                            left: 0,
                            right: 0,
                            top: containerHeight / 2 - 30,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.brown[100]!,
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.brown[100]!,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Progress indicator
                    Container(
                      width: containerWidth,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.brown[100],
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: containerWidth * _writingAnimation.value,
                          height: 4,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepPurple[900]!,
                                Colors.deepPurple[700]!,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // Writing status
                    Text(
                      'Writing: ${_displayText.padRight(_fullText.length, '_')}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.brown[800],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    
                    // Removed the Continue button completely
                    // The navigation now happens automatically after animation completes
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  double _calculatePenAngle(Offset position) {
    // Calculate pen angle based on movement direction
    final double progress = _writingAnimation.value;
    final double letterProgress = (progress * _fullText.length) % 1;
    final int currentLetterIndex = (progress * _fullText.length).floor();
    
    if (currentLetterIndex >= _fullText.length) return 0.3;
    
    final List<Offset> currentPath = _letterPaths[currentLetterIndex];
    final double segmentProgress = letterProgress * currentPath.length;
    final int segmentIndex = segmentProgress.floor();
    
    if (segmentIndex >= currentPath.length - 1) return 0.3;
    
    final Offset start = currentPath[segmentIndex];
    final Offset end = currentPath[segmentIndex + 1];
    final double deltaX = end.dx - start.dx;
    final double deltaY = end.dy - start.dy;
    
    return deltaX.abs() > deltaY.abs() ? 0.0 : 1.0;
  }

  Widget _buildInkDrop(double delay) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(delay, delay + 0.3, curve: Curves.easeInOut),
        ),
      ),
      child: Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: _inkAnimation.value,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'name_writing_screen.dart';

class BookAnimationScreen extends StatefulWidget {
  const BookAnimationScreen({super.key});

  @override
  _BookAnimationScreenState createState() => _BookAnimationScreenState();
}

class _BookAnimationScreenState extends State<BookAnimationScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _leftPageAnimation;
  late Animation<double> _rightPageAnimation;
  late Animation<double> _bookScaleAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    // Left page turning animation
    _leftPageAnimation = Tween<double>(begin: 0, end: -0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
      ),
    );

    // Right page turning animation
    _rightPageAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeInOut),
      ),
    );

    // Book scale animation
    _bookScaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Background color transition
    _backgroundColorAnimation = ColorTween(
      begin: Colors.blue[900],
      end: const Color(0xFF2C1810), // Parchment-like color
    ).animate(_controller);

    _controller.forward();

    // Navigate to name writing screen after animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => 
                const NameWritingScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var curve = Curves.easeInOut;
              var curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: curve,
              );
              
              return FadeTransition(
                opacity: curvedAnimation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 1500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _backgroundColorAnimation.value,
          body: Center(
            child: ScaleTransition(
              scale: _bookScaleAnimation,
              child: Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B4513), // Book cover color
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Book spine
                    Container(
                      width: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5D4037),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    
                    // Left page
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(_leftPageAnimation.value),
                        child: Container(
                          width: 140,
                          height: 380,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: _buildPageContent('LEARN'),
                        ),
                      ),
                    ),
                    
                    // Right page
                    Align(
                      alignment: Alignment.centerRight,
                      child: Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(_rightPageAnimation.value),
                        child: Container(
                          width: 140,
                          height: 380,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E1),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: _buildPageContent('GROW'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageContent(String text) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_stories,
            size: 40,
            color: Colors.brown[600],
          ),
          const SizedBox(height: 20),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.brown[800],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
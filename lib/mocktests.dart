import 'dart:math' as math;
import 'package:apttora/mock_tests_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
 

class Level {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final Color glowColor;

  const Level({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.glowColor,
  });
}

class Mocktests extends StatefulWidget {
  const Mocktests({super.key});

  @override
  State<Mocktests> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Mocktests> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _backgroundController;

  final List<Level> levels = const [
    Level(
      title: "Easy",
      subtitle: "For Beginners",
      icon: Icons.filter_1,
      gradient: LinearGradient(
        colors: [Color(0xFF4CAF50), Color(0xFF81C784), Color(0xFFA5D6A7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      glowColor: Color(0xFF4CAF50),
    ),
    Level(
      title: "Medium",
      subtitle: "Test Your Skills",
      icon: Icons.filter_2,
      gradient: LinearGradient(
        colors: [Color(0xFFFFA000), Color(0xFFFFCA28), Color(0xFFFFE082)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      glowColor: Color(0xFFFFA000),
    ),
    Level(
      title: "Hard",
      subtitle: "Challenge for Experts",
      icon: Icons.filter_3,
      gradient: LinearGradient(
        colors: [Color(0xFFD32F2F), Color(0xFFF06292), Color(0xFFF8BBD9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      glowColor: Color(0xFFD32F2F),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  center: const Alignment(-0.5, -0.5),
                  radius: 1.2,
                  colors: [
                    Colors.white,
                    Colors.grey[100]!,
                    Colors.grey[50]!,
                    Colors.white,
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
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
              "Mock Test",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0.9), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose Your Level",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: levels.length,
                    itemBuilder: (context, index) {
                      final level = levels[index];
                      return FadeTransition(
                        opacity: CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.5),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                0.2 * index, 
                                1.0,
                                curve: Curves.easeOut,
                              ),
                            ),
                          ),
                          child: _LevelCard(
                            level: level,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MockTestScreen(level: level.title),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
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

    for (int i = 0; i < 15; i++) {
      final x = (size.width * 0.2 + (size.width * 0.6 * random.nextDouble()) +
              animationValue * size.width * 0.3) %
          size.width;
      final y = (size.height * 0.2 +
              (size.height * 0.6 * random.nextDouble()) +
              animationValue * size.height * 0.2) %
          size.height;
      final radius = 1.5 + random.nextDouble() * 4;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = Colors.blue.withOpacity(0.05 + random.nextDouble() * 0.1)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.5),
      );
    }

    final wavePaint = Paint()
      ..color = Colors.grey.withOpacity(0.03)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (double x = 0; x < size.width; x += 30) {
      final y = size.height * 0.8 +
          math.sin((x / 150 + animationValue * math.pi)) * 15 +
          math.sin((x / 75 + animationValue * 2 * math.pi)) * 5;
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

class _LevelCard extends StatefulWidget {
  final Level level;
  final VoidCallback onTap;

  const _LevelCard({required this.level, required this.onTap});

  @override
  State<_LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<_LevelCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
    _scaleController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTapDown: (_) => _scaleController.forward(),
        onTapUp: (_) {
          _scaleController.reverse();
          widget.onTap();
        },
        onTapCancel: () => _scaleController.reverse(),
        child: Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: widget.level.gradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: widget.level.glowColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: widget.level.glowColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.level.glowColor.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.level.icon,
                    size: 48,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: widget.level.glowColor.withOpacity(0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.level.title,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.level.subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
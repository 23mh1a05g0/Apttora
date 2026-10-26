import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class BrickBreakerPage extends StatefulWidget {
  const BrickBreakerPage({super.key});
  @override
  State<BrickBreakerPage> createState() => _BrickBreakerPageState();
}

class _BrickBreakerPageState extends State<BrickBreakerPage>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;
  final GameState _game = GameState();

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    final dt = _lastTick == Duration.zero
        ? 0.0
        : (elapsed - _lastTick).inMilliseconds / 1000.0;
    _lastTick = elapsed;
    _game.update(dt);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details, Size size) {
    _game.movePaddleTo(details.localPosition.dx, size);
    setState(() {});
  }

  void _onTapUp(TapUpDetails details, Size size) {
    if (!_game.running || _game.gameOver) {
      if (_game.gameOver) {
        _game.resetGame();
      }
      _game.startOrNextLevel(size);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cons) {
        final size = cons.biggest;
        _game.ensureInitialized(size);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (d) => _onHorizontalDragUpdate(d, size),
          onTapUp: (d) => _onTapUp(d, size),
          child: CustomPaint(size: size, painter: GamePainter(_game, size)),
        );
      },
    );
  }
}

class LevelDesigns {
  static final List<List<String>> levels = [
    // Level 1 - Single Row
    ["11123471111"],

    // Level 2 - Two Rows
    ["11111111111", "11111111111"],

    // Level 3 - Checkerboard
    ["10101010101", "01010101010"],

    // Level 4 - Pyramid
    ["0001111000", "0011111100", "0111111110"],

    // Level 5 - Hollow Rectangle
    ["11111111111", "10000000001", "10000000001", "11111111111"],

    // Level 6 - Steps
    ["1000000000", "1100000000", "1110000000"],

    // Level 7 - Dots
    ["10000000001", "00010001000", "10000000001"],

    // Level 8 - Single Column
    ["11111111111", "11111111111", "11111111111", "11111111111", "11111111111"],

    // Level 9 - Double Pyramid
    ["001111100", "011111110", "111111111", "011111110", "001111100"],

    // Level 10 - Zigzag
    ["10001000100", "01000100010", "00100010001"],

    // Level 11 - Waves
    ["0001111000", "0111001110", "1110000111"],

    // Level 12 - Arrow
    ["000010000", "000111000", "001111100", "000111000", "000010000"],

    // Level 13 - Diamond
    ["000010000", "000111000", "001111100", "000111000", "000010000"],

    // Level 14 - Hollow Diamond
    ["000010000", "000101000", "001000100", "000101000", "000010000"],

    // Level 15 - Spiral
    ["11111111111", "10000000001", "10111111101", "10100000101", "11111111111"],

    // Level 16 - Tunnel
    ["11111111111", "10011111001", "10001110001", "10011111001", "11111111111"],

    // Level 17 - Heart
    [
      "011001100110",
      "111111111111",
      "111111111111",
      "011111111110",
      "001111111100",
      "000111111000",
    ],

    // Level 18 - Castle
    ["11101110111", "11101110111", "11111111111", "11000000011", "11111111111"],

    // Level 19 - Cross
    ["000010000", "000010000", "111111111", "000010000", "000010000"],

    // Level 20 - Maze
    ["11111111111", "10001000101", "10111011101", "10100000101", "11101111101"],

    // Level 21 - Boss Level (2-hit bricks)
    ["22222222222", "21111111112", "21212121212", "21111111112", "22222222222"],

    // Level 22 - Diagonal Lines
    ["10000000001", "01000000010", "00100000100", "00010001000", "00001010000"],

    // Level 23 - X Pattern
    ["10000000001", "01000000010", "00100000100", "00010001000", "00001010000"],

    // Level 24 - Full Grid with Gaps
    ["11111111111", "10101010101", "11111111111", "10101010101", "11111111111"],

    // Level 25 - Final Challenge
    [
      "11111111111",
      "10101010101",
      "11001100111",
      "10101010101",
      "11111111111",
      "10000000001",
      "11111111111",
    ],
  ];
}

class GameState {
  Size canvasSize = Size.zero;
  late Rect paddle;
  double paddleWidth = 140;
  double paddleHeight = 16;
  double paddleSpeed = 1000;
  Offset ballPos = Offset.zero;
  Offset ballVel = Offset.zero;
  double ballRadius = 10.0;
  double initialBallSpeed = 500;
  final List<Brick> bricks = [];
  double brickGap = 0;
  double topOffset = 60.0;
  double brickHeight = 28.0;
  bool running = false;
  bool gameOver = false;
  int score = 0;
  int lives = 3;
  int level = 1;
  Random rng = Random();
  final Paint paddlePaint = Paint()..shader = null;
  final Paint ballPaint = Paint()..color = Colors.white;
  final List<Color> brickColors = [
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.orange,
    Colors.teal,
  ];

  void ensureInitialized(Size size) {
    if (canvasSize == size) return;
    canvasSize = size;
    paddleWidth = max(90, canvasSize.width * 0.20);
    paddleHeight = max(12, canvasSize.height * 0.02);
    ballRadius = max(8.0, canvasSize.width * 0.012);
    initialBallSpeed = canvasSize.shortestSide * 0.65;
    brickHeight = max(18.0, canvasSize.height * 0.035);
    resetLevel();
  }

  void resetGame() {
    level = 1;
    score = 0;
    lives = 3;
    gameOver = false;
    resetLevel();
  }

  void startOrNextLevel(Size size) {
    if (bricks.where((b) => b.alive).isEmpty) {
      level++;
      if (level > LevelDesigns.levels.length) {
        level = 1; // Loop back to first level
      }
      resetLevel();
    }
    running = true;
    gameOver = false;
    if (ballVel == Offset.zero) {
      final angle = -pi / 4 + (rng.nextDouble() - 0.5) * 0.4;
      ballVel = Offset(
        initialBallSpeed * cos(angle),
        initialBallSpeed * sin(angle),
      );
    }
  }

  void resetLevel() {
    paddle = Rect.fromCenter(
      center: Offset(canvasSize.width / 2, canvasSize.height - 60),
      width: paddleWidth,
      height: paddleHeight,
    );

    ballPos = Offset(
      canvasSize.width / 2,
      canvasSize.height - 60 - ballRadius - paddleHeight / 2 - 2,
    );
    ballVel = Offset.zero;
    running = false;

    bricks.clear();
    final designIndex = (level - 1) % LevelDesigns.levels.length;
    final design = LevelDesigns.levels[designIndex];

    if (design.isEmpty) return;

    final rows = design.length;
    final cols = design[0].length;

    final sidePadding = 20.0;
    final availableWidth = canvasSize.width - sidePadding * 2;
    final singleBrickWidth = (availableWidth - (cols - 1) * brickGap) / cols;
    final leftStart =
        (canvasSize.width - (singleBrickWidth * cols + brickGap * (cols - 1))) /
        2;

    for (int r = 0; r < rows; r++) {
      final row = design[r];
      for (int c = 0; c < cols; c++) {
        if (c >= row.length) continue;
        final brickType = row[c];
        if (brickType != '0') {
          final rect = Rect.fromLTWH(
            leftStart + c * (singleBrickWidth + brickGap),
            topOffset + r * (brickHeight + brickGap),
            singleBrickWidth - 1,
            brickHeight,
          );
          // Convert character to hits needed (1 for '1', 2 for '2', etc.)
          final hits = int.tryParse(brickType) ?? 1;
          // Make higher levels slightly harder
          final adjustedHits = hits + (level ~/ 10);
          final color = brickColors[(r + c + level) % brickColors.length];
          bricks.add(Brick(rect: rect, hits: adjustedHits, color: color));
        }
      }
    }
  }

  void movePaddleTo(double x, Size size) {
    final half = paddle.width / 2;
    final newCx = x.clamp(half, size.width - half);
    paddle = paddle.shift(Offset(newCx - paddle.center.dx, 0));
  }

  void update(double dt) {
    if (canvasSize == Size.zero) return;
    if (!running || gameOver) return;

    dt = dt.clamp(0.0, 0.033);

    ballPos = ballPos + ballVel * dt;

    // Wall collisions
    if (ballPos.dx - ballRadius <= 0 && ballVel.dx < 0) {
      ballPos = Offset(ballRadius, ballPos.dy);
      ballVel = Offset(-ballVel.dx, ballVel.dy);
    } else if (ballPos.dx + ballRadius >= canvasSize.width && ballVel.dx > 0) {
      ballPos = Offset(canvasSize.width - ballRadius, ballPos.dy);
      ballVel = Offset(-ballVel.dx, ballVel.dy);
    }

    // Top collision
    if (ballPos.dy - ballRadius <= 0 && ballVel.dy < 0) {
      ballPos = Offset(ballPos.dx, ballRadius);
      ballVel = Offset(ballVel.dx, -ballVel.dy);
    }

    // Bottom collision - lose life
    if (ballPos.dy - ballRadius > canvasSize.height) {
      lives -= 1;
      if (lives <= 0) {
        gameOver = true;
        running = false;
      } else {
        resetBall();
      }
      return;
    }

    // Paddle collision
    if (circleRectCollision(ballPos, ballRadius, paddle) && ballVel.dy > 0) {
      ballPos = Offset(ballPos.dx, paddle.top - ballRadius - 0.5);
      final intersectX = (ballPos.dx - paddle.center.dx) / (paddle.width / 2);
      final angle = -pi / 2 + intersectX * pi / 3;
      final speed = ballVel.distance.clamp(
        initialBallSpeed * 1.5,
        initialBallSpeed * 1.6,
      );
      ballVel = Offset(speed * cos(angle), speed * sin(angle));
      ballVel *= 1.02; // Slight speed increase
    }

    // Brick collisions
    for (final brick in List<Brick>.from(bricks)) {
      if (!brick.alive) continue;
      if (circleRectCollision(ballPos, ballRadius, brick.rect)) {
        handleBrickCollision(brick);
        break; // Only handle one brick per frame
      }
    }

    // Level complete check
    if (bricks.where((b) => b.alive).isEmpty) {
      running = false;
    }
  }

  void resetBall() {
    ballPos = Offset(canvasSize.width / 2, canvasSize.height - 60 - ballRadius);
    ballVel = Offset.zero;
    running = false;
  }

  void handleBrickCollision(Brick brick) {
    // Determine collision side
    final overlapLeft = (ballPos.dx + ballRadius) - brick.rect.left;
    final overlapRight = brick.rect.right - (ballPos.dx - ballRadius);
    final overlapTop = (ballPos.dy + ballRadius) - brick.rect.top;
    final overlapBottom = brick.rect.bottom - (ballPos.dy - ballRadius);

    final minOverlap = [
      overlapLeft,
      overlapRight,
      overlapTop,
      overlapBottom,
    ].reduce(min);

    // Bounce based on collision side
    if (minOverlap == overlapLeft && ballVel.dx > 0) {
      ballVel = Offset(-ballVel.dx, ballVel.dy);
    } else if (minOverlap == overlapRight && ballVel.dx < 0) {
      ballVel = Offset(-ballVel.dx, ballVel.dy);
    } else {
      ballVel = Offset(ballVel.dx, -ballVel.dy);
    }

    brick.hit();
    score += 10 * brick.initialHits; // More points for tougher bricks
    if (!brick.alive) {
      bricks.remove(brick);
    }
  }

  bool circleRectCollision(Offset c, double r, Rect rect) {
    final closestX = c.dx.clamp(rect.left, rect.right);
    final closestY = c.dy.clamp(rect.top, rect.bottom);
    final dx = c.dx - closestX;
    final dy = c.dy - closestY;
    return dx * dx + dy * dy <= r * r;
  }
}

class Brick {
  final Rect rect;
  int hits;
  final int initialHits;
  final Color color;

  Brick({required this.rect, required this.hits, required this.color})
    : initialHits = hits;

  bool get alive => hits > 0;
  void hit() {
    hits = max(0, hits - 1);
  }
}

class GamePainter extends CustomPainter {
  final GameState game;
  final Size screen;
  GamePainter(this.game, this.screen);

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final rect = Offset.zero & size;
    final bg = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFF071024), const Color(0xFF0F1724)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);
    canvas.drawRect(rect, bg);

    _drawHUD(canvas, size);
    _drawBricks(canvas);
    _drawPaddle(canvas);
    _drawBall(canvas);
    _drawInfoOverlay(canvas, size);
  }

  void _drawBricks(Canvas canvas) {
    final paint = Paint();
    for (final b in game.bricks) {
      if (!b.alive) continue;

      // Darken color based on remaining hits
      final color = b.color.withOpacity(0.7 + 0.3 * (b.hits / b.initialHits));
      paint.color = color;

      final rr = RRect.fromRectAndRadius(b.rect, const Radius.circular(4));
      canvas.drawRRect(rr, paint);

      // Inner highlight
      final inner = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Colors.white.withOpacity(0.1);
      canvas.drawRRect(rr.deflate(1), inner);

      // Hit count (if more than 1)
      if (b.initialHits > 1) {
        final tp = TextPainter(
          text: TextSpan(
            text: '${b.hits}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(
          canvas,
          Offset(
            b.rect.center.dx - tp.width / 2,
            b.rect.center.dy - tp.height / 2,
          ),
        );
      }
    }
  }

  void _drawPaddle(Canvas canvas) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.blueAccent, Colors.lightBlue],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(game.paddle);

    final r = RRect.fromRectAndRadius(game.paddle, const Radius.circular(8));
    canvas.drawRRect(r, paint);

    // Glow effect
    final glow = Paint()
      ..color = Colors.lightBlue.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawRRect(r.inflate(4), glow);
  }

  void _drawBall(Canvas canvas) {
    final paint = Paint()
      ..shader =
          RadialGradient(
            colors: [Colors.white, Colors.white70],
            stops: [0.7, 1.0],
          ).createShader(
            Rect.fromCircle(center: game.ballPos, radius: game.ballRadius),
          );

    canvas.drawCircle(game.ballPos, game.ballRadius, paint);

    // Shadow
    final shadow = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(
      game.ballPos + const Offset(2, 3),
      game.ballRadius,
      shadow,
    );
  }

  void _drawHUD(Canvas canvas, Size size) {
    const tStyle = TextStyle(
      color: Colors.white70,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    // Score
    final scoreTP = TextPainter(
      text: TextSpan(text: 'Score: ${game.score}', style: tStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    scoreTP.paint(canvas, const Offset(16, 8));

    // Lives
    final livesTP = TextPainter(
      text: TextSpan(text: 'Lives: ${game.lives}', style: tStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    livesTP.paint(canvas, Offset(size.width - livesTP.width - 16, 8));

    // Level
    final levelTP = TextPainter(
      text: TextSpan(text: 'Level: ${game.level}', style: tStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    levelTP.paint(canvas, Offset((size.width - levelTP.width) / 2, 8));
  }

  void _drawInfoOverlay(Canvas canvas, Size size) {
    if (game.gameOver) {
      _drawCenteredMessage(
        canvas,
        size,
        'Game Over!\nScore: ${game.score}\nTap to restart',
        Colors.redAccent,
      );
    } else if (!game.running && game.bricks.where((b) => b.alive).isEmpty) {
      _drawCenteredMessage(
        canvas,
        size,
        'Level Complete!\nTap for next level',
        Colors.greenAccent,
      );
    } else if (!game.running && game.ballVel == Offset.zero) {
      _drawCenteredMessage(
        canvas,
        size,
        'Tap to Launch',
        Colors.white54,
        yOffset: size.height - 100,
      );
    }
  }

  void _drawCenteredMessage(
    Canvas canvas,
    Size size,
    String text,
    Color color, {
    double yOffset = 0,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 24,
          height: 1.5,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width * 0.8);

    tp.paint(
      canvas,
      Offset(
        (size.width - tp.width) / 2,
        (size.height - tp.height) / 2 + yOffset,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) => true;
}

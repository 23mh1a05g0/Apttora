import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:async';
import 'quiz_screen.dart';

class VideoScreen extends StatefulWidget {
  final String topic;
  final String videoId;
  final String category;
  final Function(int) addXp;

  const VideoScreen({super.key, required this.topic, required this.videoId, required this.category, required this.addXp});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;
  bool _videoCompleted = false;
  bool _showXpAnimation = false;
  Timer? _progressTimer;
  double _progressValue = 0;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize YouTube player controller
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        captionLanguage: 'en',
        loop: false,
        isLive: false,
        forceHD: false,
        hideControls: false,
        controlsVisibleAtStart: true,
        hideThumbnail: false,
        disableDragSeek: false,
        useHybridComposition: true, // Important for Android performance
      ),
    );

    // Listen to player state changes
    _controller.addListener(listener);

    // Start progress timer
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _isPlayerReady) _updateProgress();
    });
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      // Update current position
      final position = _controller.value.position;
      final duration = _controller.metadata.duration;
      
      if (mounted && duration != null && duration.inSeconds > 0) {
        setState(() {
          _currentPosition = position;
          _totalDuration = duration;
          _progressValue = position.inSeconds / duration.inSeconds;
        });

        // Check if video is 95% complete
        if (_progressValue > 0.95 && !_videoCompleted) {
          _completeVideo();
        }
      }
    }
  }

  void _updateProgress() {
    if (_controller.value.isReady && _controller.metadata.duration != null) {
      final position = _controller.value.position;
      final duration = _controller.metadata.duration!;
      
      if (mounted && duration.inSeconds > 0) {
        setState(() {
          _currentPosition = position;
          _totalDuration = duration;
          _progressValue = position.inSeconds / duration.inSeconds;
        });

        if (_progressValue > 0.95 && !_videoCompleted) {
          _completeVideo();
        }
      }
    }
  }

  void _completeVideo() {
    setState(() {
      _videoCompleted = true;
      _showXpAnimation = true;
    });
    
    // Add XP
    widget.addXp(100);
    
    // Hide animation after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showXpAnimation = false);
    });
  }

  void _manualComplete() {
    if (!_videoCompleted) {
      _completeVideo();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      return '${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}';
    } else {
      return '${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.topic,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.black26,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2E7D32), // Dark Green
                Color(0xFF4CAF50), // Green
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (!_videoCompleted)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: _manualComplete,
              tooltip: "Mark video as completed",
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E9), // Very Light Green (top)
              Color(0xFFC8E6C9), // Light Green (middle)
              Color(0xFFA5D6A7), // Medium Light Green (bottom)
            ],
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                // YouTube Player Section
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: YoutubePlayer(
                      controller: _controller,
                      aspectRatio: 16 / 9,
                      onReady: () {
                        if (mounted) {
                          setState(() {
                            _isPlayerReady = true;
                          });
                        }
                      },
                      onEnded: (data) {
                        if (!_videoCompleted) {
                          _completeVideo();
                        }
                      },
                    ),
                  ),
                ),

                // Progress Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: _progressValue,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _videoCompleted ? const Color(0xFF4CAF50) : const Color(0xFF6A5AE0),
                        ),
                        borderRadius: BorderRadius.circular(10),
                        minHeight: 8,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_currentPosition), 
                            style: const TextStyle(fontSize: 12, color: Colors.grey)
                          ),
                          Text(
                            "${(_progressValue * 100).toStringAsFixed(0)}%", 
                            style: const TextStyle(
                              fontSize: 12, 
                              fontWeight: FontWeight.w600, 
                              color: Color(0xFF6A5AE0)
                            )
                          ),
                          Text(
                            _formatDuration(_totalDuration), 
                            style: const TextStyle(fontSize: 12, color: Colors.grey)
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Content Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: _videoCompleted
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 8,
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.emoji_events, size: 50, color: Color(0xFF4CAF50)),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Video Completed!",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1D1D1D),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 2.0,
                                        color: Colors.black.withOpacity(0.1),
                                        offset: const Offset(1.0, 1.0),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "You've earned 100 XP",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                    shadows: [
                                      Shadow(
                                        blurRadius: 1.0,
                                        color: Colors.black.withOpacity(0.05),
                                        offset: const Offset(0.5, 0.5),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 30),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QuizScreen(
                                            topic: widget.topic, 
                                            category: widget.category, 
                                            addXp: widget.addXp
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6A5AE0),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      shadowColor: Colors.black26,
                                      elevation: 4,
                                    ),
                                    child: const Text(
                                      "Start Quiz",
                                      style: TextStyle(
                                        fontSize: 16,
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
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 8,
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.play_circle_filled,
                                    size: 50,
                                    color: const Color(0xFF6A5AE0),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 2.0,
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(1.0, 1.0),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Complete the video to unlock the quiz",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1D1D1D),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 1.0,
                                        color: Colors.black.withOpacity(0.1),
                                        offset: const Offset(0.5, 0.5),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "You will earn 100 XP when you finish watching",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    shadows: [
                                      Shadow(
                                        blurRadius: 1.0,
                                        color: Colors.black.withOpacity(0.05),
                                        offset: const Offset(0.5, 0.5),
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

            // XP Animation Overlay
            if (_showXpAnimation)
              IgnorePointer(
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFF9800), // Orange
                                Color(0xFFFFB74D), // Light Orange
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.emoji_events, size: 80, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "+100 XP",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Great job completing the video!",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.black,
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
      ),
    );
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProgressManager()..init(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aptora — Communication Module',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const CommunicationHome(),
      ),
    ),
  );
}

class ProgressManager extends ChangeNotifier {
  SharedPreferences? _prefs;
  int streak = 0;
  String? lastDateString;
  Set<String> badges = {};

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    streak = _prefs?.getInt('streak') ?? 0;
    lastDateString = _prefs?.getString('lastDate');
    badges = (_prefs?.getStringList('badges') ?? []).toSet();
    notifyListeners();
  }

  void _save() {
    _prefs?.setInt('streak', streak);
    if (lastDateString != null) _prefs?.setString('lastDate', lastDateString!);
    _prefs?.setStringList('badges', badges.toList());
  }

  void markExerciseCompletedToday() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (lastDateString == today) return;
    if (lastDateString != null) {
      final yesterday = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.now().subtract(const Duration(days: 1)));
      if (lastDateString == yesterday) {
        streak += 1;
      } else {
        streak = 1;
      }
    } else {
      streak = 1;
    }
    lastDateString = today;
    if (streak >= 7 && !badges.contains('7_day_streak'))
      badges.add('7_day_streak');
    _save();
    notifyListeners();
  }

  void awardBadge(String id) {
    if (!badges.contains(id)) {
      badges.add(id);
      _save();
      notifyListeners();
    }
  }

  bool hasBadge(String id) => badges.contains(id);
}

class CommunicationHome extends StatefulWidget {
  const CommunicationHome({super.key});

  @override
  State<CommunicationHome> createState() => _CommunicationHomeState();
}

class _CommunicationHomeState extends State<CommunicationHome> {
  int _selectedIndex = 0;

  final List<Widget> _sections = const [
    FluencyScreen(),
    PronunciationScreen(),
    SoftSkillsScreen(),
  ];

  final List<String> _sectionTitles = [
    'Fluency Practice',
    'Pronunciation Training',
    'Soft Skills Development',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aptora — Communication'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Row(
                children: [
                  _buildSectionContainer(0, Icons.record_voice_over, 'Fluency'),
                  _buildSectionContainer(1, Icons.volume_up, 'Pronunciation'),
                  _buildSectionContainer(2, Icons.lightbulb, 'Soft Skills'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                _sectionTitles[_selectedIndex],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: _sections[_selectedIndex]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContainer(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected ? Colors.indigo : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.indigo,
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.indigo,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FluencyScreen extends StatefulWidget {
  const FluencyScreen({super.key});

  @override
  State<FluencyScreen> createState() => _FluencyScreenState();
}

class _FluencyScreenState extends State<FluencyScreen> {
  final List<String> prompts = [
    'Describe a memorable project you worked on and what you learned from it. Focus on the challenges you faced and how you overcame them to deliver a successful outcome.',
    'Explain an app idea that would help students manage their time more effectively. Discuss the key features, target audience, and potential impact on student productivity and well-being.',
    'Talk about your biggest strength and provide specific examples of how this strength has helped you in professional or academic settings. Be detailed about the situations and outcomes.',
    'Describe how you learn a new technology or programming language. Walk through your process from initial research to practical implementation, including any resources or methods you find particularly effective.',
    'Discuss a time when you had to work in a team under pressure. Explain the project goals, your role, how the team collaborated, and what you learned about teamwork and communication.',
    'Explain the importance of continuous learning in the tech industry. Provide examples of how staying updated with new technologies has benefited your career or projects.',
    'Describe your approach to problem-solving when faced with a complex technical challenge. Include how you break down problems, research solutions, and test your implementations.',
    'Talk about a book or article that significantly influenced your professional development. Explain the key takeaways and how you applied them in your work or studies.',
  ];

  String selectedPrompt = '';
  bool running = false;
  int seconds = 30;
  Timer? _timer;
  final stt.SpeechToText _speech = stt.SpeechToText();
  String transcription = '';
  bool _speechAvailable = false;

  @override
  void initState() {
    super.initState();
    selectedPrompt = (prompts..shuffle()).first;
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize();
    setState(() {});
  }

  void _startTimer() {
    transcription = '';
    setState(() {
      running = true;
      seconds = 30;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        seconds -= 1;
      });
      if (seconds <= 0) {
        _stopSession();
      }
    });
    if (_speechAvailable) {
      _speech.listen(
        onResult: (r) {
          setState(() {
            transcription = r.recognizedWords;
          });
        },
        listenFor: const Duration(seconds: 35),
      );
    }
  }

  void _stopSession() {
    _timer?.cancel();
    if (_speechAvailable) {
      _speech.stop();
    }
    setState(() {
      running = false;
    });
    final words = transcription.trim().isEmpty
        ? 0
        : transcription.trim().split(RegExp(r'\s+')).length;
    final minutes = 30 / 60;
    final wpm = (minutes > 0) ? (words / minutes) : 0;

    String feedback = '';
    if (wpm < 100) {
      feedback =
          'Try to speak a bit faster and add more details to your response.';
    } else if (wpm >= 100 && wpm < 150) {
      feedback =
          'Good pace! You\'re speaking clearly and at a comfortable speed.';
    } else {
      feedback =
          'Excellent fluency! You\'re expressing ideas smoothly and confidently.';
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Session Complete'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You spoke $words words.\nEstimated WPM: ${wpm.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 10),
            Text('Feedback: $feedback'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    final pm = Provider.of<ProgressManager>(context, listen: false);
    pm.markExerciseCompletedToday();
    if (!pm.hasBadge('fluency_starter')) pm.awardBadge('fluency_starter');
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Fluency Practice Prompt',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        selectedPrompt,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('New Prompt'),
                          onPressed: running
                              ? null
                              : () {
                                  setState(() {
                                    selectedPrompt = (prompts..shuffle()).first;
                                  });
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Start 30s Practice'),
                          onPressed: running ? null : _startTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        if (running)
                          ElevatedButton.icon(
                            icon: const Icon(Icons.stop),
                            label: const Text('Stop'),
                            onPressed: _stopSession,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (running) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Time remaining: $seconds seconds',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Live Transcription:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      constraints: const BoxConstraints(minHeight: 120),
                      child: SingleChildScrollView(
                        child: Text(
                          transcription.isEmpty
                              ? '(Speak now... your words will appear here)'
                              : transcription,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Tip: Speak clearly and try to maintain a steady pace. Focus on completing your thoughts within the time limit.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PronunciationScreen extends StatefulWidget {
  const PronunciationScreen({super.key});

  @override
  State<PronunciationScreen> createState() => _PronunciationScreenState();
}

class _PronunciationScreenState extends State<PronunciationScreen> {
  final List<String> samples = [
    'I would genuinely appreciate the opportunity to join your innovative team and contribute my skills to your exciting projects while learning from experienced professionals.',
    'Could you please elaborate further on that specific point? I want to ensure I fully understand the requirements and expectations before providing a comprehensive response.',
    'My professional experience encompasses both mobile application development using Flutter and React Native, as well as web development with modern frameworks like React and Vue.js.',
    'I successfully handled the complete deployment process including continuous integration setup, monitoring implementation, and performance optimization for our production applications.',
    'The technical specifications require careful consideration of scalability factors, security implementations, and user experience design principles to ensure optimal application performance.',
    'Collaboration between cross-functional teams is essential for delivering high-quality software solutions that meet both business objectives and user needs effectively.',
    'Implementing automated testing procedures significantly improves code reliability and reduces regression issues throughout the development lifecycle of complex applications.',
    'Professional development requires continuous learning, adaptability to new technologies, and effective communication with stakeholders at all organizational levels.',
  ];

  String target = '';
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _speechAvailable = false;
  String recognized = '';

  @override
  void initState() {
    super.initState();
    target = (samples..shuffle()).first;
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize();
    setState(() {});
  }

  Future<void> _listen() async {
    if (!_speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Speech recognition not available on this platform.'),
        ),
      );
      return;
    }
    recognized = '';
    setState(() {});
    _speech.listen(
      onResult: (r) {
        setState(() {
          recognized = r.recognizedWords;
        });
      },
      listenFor: const Duration(seconds: 15),
    );
  }

  void _stop() async {
    if (_speechAvailable) await _speech.stop();
  }

  double computeAccuracy(String target, String heard) {
    final ta = target
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    final ha = heard
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    if (ta.isEmpty) return 0.0;
    int matching = 0;
    for (int i = 0; i < ta.length; i++) {
      if (i < ha.length && ha[i] == ta[i]) matching++;
    }
    return matching / ta.length;
  }

  void _submit() {
    _stop();
    final accuracy = computeAccuracy(target, recognized);
    final words = recognized.trim().isEmpty
        ? 0
        : recognized.trim().split(RegExp(r'\s+')).length;
    final minutes = 15 / 60;
    final wpm = (minutes > 0) ? (words / minutes) : 0;
    String feedback;
    if (accuracy >= 0.9) {
      feedback =
          'Excellent pronunciation! Your speech is very clear and accurate.';
    } else if (accuracy >= 0.8) {
      feedback =
          'Very good! Your pronunciation is clear with minor variations.';
    } else if (accuracy >= 0.7) {
      feedback =
          'Good effort! Practice will help improve your accuracy further.';
    } else if (accuracy >= 0.6) {
      feedback = 'Fair pronunciation. Focus on enunciating each word clearly.';
    } else {
      feedback =
          'Keep practicing! Try speaking slower and focusing on each word.';
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PronunciationResultScreen(
          paragraph: target,
          spoken: recognized,
          accuracy: accuracy,
          wpm: wpm.toDouble(),
          feedback: feedback,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final acc = computeAccuracy(target, recognized);
    return Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Pronunciation Practice',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Repeat this sentence clearly:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        target,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 14,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.mic),
                          label: const Text('Start Speaking'),
                          onPressed: _listen,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('New Sentence'),
                          onPressed: () {
                            setState(() {
                              target = (samples..shuffle()).first;
                              recognized = '';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text('Submit'),
                          onPressed: recognized.trim().isEmpty ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'What I heard:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      constraints: const BoxConstraints(minHeight: 80),
                      child: SingleChildScrollView(
                        child: Text(
                          recognized.isEmpty
                              ? '(Your speech will appear here)'
                              : recognized,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getAccuracyColor(acc),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Pronunciation Accuracy',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${(acc * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            _getAccuracyFeedback(acc),
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Note: This measures word matching accuracy. For detailed phoneme analysis, professional speech assessment tools are recommended.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 0.8) return Colors.green.shade100;
    if (accuracy >= 0.6) return Colors.blue.shade100;
    if (accuracy >= 0.4) return Colors.orange.shade100;
    return Colors.red.shade100;
  }

  String _getAccuracyFeedback(double accuracy) {
    if (accuracy >= 0.9)
      return 'Excellent pronunciation! Your speech is very clear and accurate.';
    if (accuracy >= 0.8)
      return 'Very good! Your pronunciation is clear with minor variations.';
    if (accuracy >= 0.7)
      return 'Good effort! Practice will help improve your accuracy further.';
    if (accuracy >= 0.6)
      return 'Fair pronunciation. Focus on enunciating each word clearly.';
    return 'Keep practicing! Try speaking slower and focusing on each word.';
  }
}

class PronunciationResultScreen extends StatelessWidget {
  final String paragraph;
  final String spoken;
  final double accuracy;
  final double wpm;
  final String feedback;

  const PronunciationResultScreen({
    super.key,
    required this.paragraph,
    required this.spoken,
    required this.accuracy,
    required this.wpm,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pronunciation Result')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Given Paragraph:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(paragraph, style: const TextStyle(fontSize: 17)),
              ),
              const SizedBox(height: 24),
              const Text(
                'What You Spoke:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  spoken.isEmpty ? '(No speech detected)' : spoken,
                  style: const TextStyle(fontSize: 17),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Accuracy: ${(accuracy * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Words Per Minute: ${wpm.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Feedback:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(feedback, style: const TextStyle(fontSize: 17)),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SoftSkillsScreen extends StatelessWidget {
  const SoftSkillsScreen({super.key});

  final List<Map<String, String>> tips = const [
    {
      'title': 'Effective Body Language',
      'body':
          'Maintain an upright posture with shoulders relaxed. Make appropriate eye contact to show engagement, but avoid staring. Use natural hand gestures to emphasize points without being distracting. Lean slightly forward to show interest. Smile genuinely to create a positive atmosphere.',
    },
    {
      'title': 'Breathing Techniques',
      'body':
          'Practice diaphragmatic breathing: inhale deeply through your nose for 4 seconds, hold for 4 seconds, and exhale slowly through the mouth for 6 seconds. This technique reduces anxiety and improves oxygen flow to the brain, helping you think more clearly under pressure.',
    },
    {
      'title': 'Speech Pacing and Pauses',
      'body':
          'Aim for 150-160 words per minute for optimal comprehension. Use strategic pauses before important points to create emphasis and allow your message to sink in. Avoid filler words like "um" and "uh" by pausing briefly instead. Vary your pace to maintain listener interest.',
    },
    {
      'title': 'Professional Email Etiquette',
      'body':
          'Use clear, concise subject lines that summarize the email content. Start with a proper greeting and address the recipient by name. Structure your message with short paragraphs and bullet points when listing items. Proofread carefully for grammar and spelling errors before sending. End with a professional closing and your contact information.',
    },
    {
      'title': 'Active Listening Skills',
      'body':
          'Focus completely on the speaker without formulating your response while they\'re talking. Use verbal cues like "I understand" and non-verbal cues like nodding to show engagement. Paraphrase what you\'ve heard to confirm understanding. Ask clarifying questions when needed. Avoid interrupting and wait for natural pauses to respond.',
    },
    {
      'title': 'Conflict Resolution',
      'body':
          'Approach conflicts with empathy and focus on the issue rather than the person. Use "I" statements to express your perspective without blaming others. Seek to understand all viewpoints before proposing solutions. Look for common ground and mutually beneficial outcomes. Maintain professionalism even when emotions run high.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Soft Skills Development',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...tips.map(
              (t) => Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ExpansionTile(
                  leading: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                  title: Text(
                    t['title']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        t['body']!,
                        style: const TextStyle(height: 1.5, fontSize: 15),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: const [
                    Text(
                      'Quick Breathing Exercise',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    BreathingExercise(),
                    SizedBox(height: 16),
                    Text(
                      'Use this exercise before important conversations or presentations to calm your nerves and improve focus.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}

class BreathingExercise extends StatefulWidget {
  const BreathingExercise({super.key});

  @override
  State<BreathingExercise> createState() => _BreathingExerciseState();
}

class _BreathingExerciseState extends State<BreathingExercise>
    with SingleTickerProviderStateMixin {
  AnimationController? _ctr;
  bool active = false;
  String instruction = 'Tap to start breathing exercise';

  @override
  void initState() {
    super.initState();
    _ctr = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _ctr?.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        setState(() => instruction = 'Exhale slowly...');
        _ctr?.reverse();
      } else if (s == AnimationStatus.dismissed && active) {
        setState(() => instruction = 'Inhale deeply...');
        _ctr?.forward();
      }
    });
  }

  @override
  void dispose() {
    _ctr?.dispose();
    super.dispose();
  }

  void toggle() {
    setState(() {
      active = !active;
      instruction = active
          ? 'Inhale deeply...'
          : 'Tap to start breathing exercise';
    });
    if (active) {
      _ctr?.forward();
    } else {
      _ctr?.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        GestureDetector(
          onTap: toggle,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _ctr!,
                builder: (_, __) {
                  final v = (_ctr?.value ?? 0.0) * 0.6 + 0.4;
                  return Container(
                    width: 140 * v,
                    height: 140 * v,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.teal.withOpacity(0.15),
                    ),
                  );
                },
              ),
              Icon(
                active ? Icons.pause_circle_outline : Icons.play_circle_fill,
                size: 52,
                color: Colors.teal,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          instruction,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          '4-second inhale → 4-second hold → 6-second exhale',
          style: TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

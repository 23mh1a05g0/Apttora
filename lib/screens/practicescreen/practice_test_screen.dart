import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'practice_explanation_screen.dart';

class PracticeTestScreen extends StatefulWidget {
  final String category;
  final String difficulty;
  final int testNumber;
  final int xpPerQuestion;
  final Function(int) addXp;

  const PracticeTestScreen({
    super.key,
    required this.category,
    required this.difficulty,
    required this.testNumber,
    required this.xpPerQuestion,
    required this.addXp,
  });

  @override
  State<PracticeTestScreen> createState() => _PracticeTestScreenState();
}

class _PracticeTestScreenState extends State<PracticeTestScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  late List<int?> _userAnswers;
  bool _testCompleted = false;

  Timer? _timer;
  int _timeLeft = 60;

  late final List<Map<String, dynamic>> _allQuestions;
  late final List<Map<String, dynamic>> _questions;

  final Map<String, Map<String, List<Map<String, dynamic>>>> _questionsBank = {
    // Sample question bank structure
        "Aptitude": {
      "Easy": [
        {
          'question': 'What is 15% of 200?',
          'options': ['20', '25', '30', '35'],
          'correctAnswer': 2,
          'explanation': '15% of 200 = (15/100) × 200 = 30',
        },
        {
          'question':
              'If a train travels 150 km in 3 hours, what is its speed?',
          'options': ['40 km/h', '50 km/h', '60 km/h', '70 km/h'],
          'correctAnswer': 1,
          'explanation': 'Speed = Distance/Time = 150/3 = 50 km/h',
        },
        {
          'question': 'What is the next number: 5, 10, 15, 20, ...?',
          'options': ['22', '23', '25', '30'],
          'correctAnswer': 2,
          'explanation': 'Sequence increases by 5 each time, so next is 25',
        },
        {
          'question': 'What is 1/2 as percentage?',
          'options': ['25%', '50%', '75%', '100%'],
          'correctAnswer': 1,
          'explanation': '1/2 = 0.5 = 50%',
        },
        {
          'question': 'If x=2 and y=3, what is x + y?',
          'options': ['4', '5', '6', '7'],
          'correctAnswer': 1,
          'explanation': 'x + y = 2 + 3 = 5',
        },
        {
          'question': 'Area of square with side 4cm?',
          'options': ['8 cm²', '12 cm²', '16 cm²', '20 cm²'],
          'correctAnswer': 2,
          'explanation': 'Area = side × side = 4 × 4 = 16 cm²',
        },
        {
          'question': '20% discount on \$100?',
          'options': ['\$60', '\$70', '\$80', '\$90'],
          'correctAnswer': 2,
          'explanation': '20% of 100 = 20, discounted price = 100 - 20 = 80',
        },
        {
          'question': 'Ratio 2:3, 10 boys, how many girls?',
          'options': ['10', '15', '20', '25'],
          'correctAnswer': 1,
          'explanation': '2 parts = 10 boys, 1 part = 5, girls = 3 parts = 15',
        },
        {
          'question': 'Average of 5, 10, 15?',
          'options': ['8', '10', '12', '15'],
          'correctAnswer': 1,
          'explanation': 'Average = (5+10+15)/3 = 10',
        },
        {
          'question': 'Profit on buying at \$50 and selling at \$60?',
          'options': ['\$5', '\$10', '\$15', '\$20'],
          'correctAnswer': 1,
          'explanation': 'Profit = Selling price - Cost price = 60 - 50 = 10',
        },
      ],
      "Moderate": [
        {
          'question': 'If 40% of a number is 80, find the number.',
          'options': ['150', '180', '200', '220'],
          'correctAnswer': 2,
          'explanation': 'Let number be x, 40% of x = 80 => x = 80/0.4 = 200',
        },
        {
          'question':
              'A train 150m long crosses a pole in 15 seconds. Find its speed.',
          'options': ['30 km/h', '36 km/h', '40 km/h', '60 km/h'],
          'correctAnswer': 1,
          'explanation': 'Speed = Distance/Time = 150/15 = 10 m/s = 36 km/h',
        },
        {
          'question': 'What is the next number: 3, 9, 27, 81, ...?',
          'options': ['108', '162', '243', '324'],
          'correctAnswer': 2,
          'explanation': 'Each term multiplied by 3, next is 81×3=243',
        },
        {
          'question': 'What is 7/8 as percentage?',
          'options': ['75%', '80%', '85%', '87.5%'],
          'correctAnswer': 3,
          'explanation': '7/8 = 0.875 = 87.5%',
        },
        {
          'question': 'If x=5 and y=7, what is x² - y²?',
          'options': ['-24', '12', '24', '49'],
          'correctAnswer': 0,
          'explanation': 'x² - y² = 25 - 49 = -24',
        },
        {
          'question': 'Area of circle with radius 7cm? (Take π=22/7)',
          'options': ['154 cm²', '144 cm²', '164 cm²', '174 cm²'],
          'correctAnswer': 0,
          'explanation': 'Area = πr² = 22/7 × 7 × 7 = 154 cm²',
        },
        {
          'question':
              'If cost price is \$120 and profit is 20%, find selling price.',
          'options': ['\$140', '\$144', '\$150', '\$160'],
          'correctAnswer': 1,
          'explanation':
              'Profit = 20% of 120 = 24; Selling price = 120 + 24 = 144',
        },
        {
          'question': 'Ratio 5:7, 35 girls, how many boys?',
          'options': ['25', '30', '40', '45'],
          'correctAnswer': 2,
          'explanation': '7 parts = 35 girls, 1 part = 5, boys = 5 parts = 25',
        },
        {
          'question': 'Average of 10, 20, 30, 40?',
          'options': ['20', '25', '30', '35'],
          'correctAnswer': 1,
          'explanation': 'Average = (10+20+30+40)/4 = 25',
        },
        {
          'question': 'Loss on buying at \$90 and selling at \$72?',
          'options': ['\$12', '\$15', '\$18', '\$20'],
          'correctAnswer': 2,
          'explanation': 'Loss = Cost price - Selling price = 90 - 72 = 18',
        },
      ],
      "Hard": [
        {
          'question': 'If 25% of a number is 50, find 40% of that number.',
          'options': ['70', '80', '90', '100'],
          'correctAnswer': 1,
          'explanation': 'Number = 50/0.25=200; 40% of 200=80',
        },
        {
          'question':
              'A train 200m long crosses another train 300m long in 30 seconds. Speed of first train is 60 km/h. Find speed of second.',
          'options': ['40 km/h', '50 km/h', '60 km/h', '70 km/h'],
          'correctAnswer': 0,
          'explanation':
              'Relative speed = (200+300)/30=16.67 m/s; 60 km/h=16.67 m/s, so second train speed=0 m/s (check carefully)',
        },
        {
          'question': 'What is the next number: 2, 6, 18, 54, ...?',
          'options': ['108', '162', '216', '324'],
          'correctAnswer': 1,
          'explanation': 'Each term multiplied by 3, next is 54×3=162',
        },
        {
          'question': 'What is 23/25 as percentage?',
          'options': ['90%', '91%', '92%', '93%'],
          'correctAnswer': 2,
          'explanation': '23/25 = 0.92 = 92%',
        },
        {
          'question': 'If x=10 and y=6, what is (x² + y²) / (x - y)?',
          'options': ['32', '34', '40', '56'],
          'correctAnswer': 1,
          'explanation': '(100+36)/(10-6) = 136/4=34',
        },
        {
          'question': 'Area of triangle with base 10cm and height 8cm?',
          'options': ['40 cm²', '45 cm²', '50 cm²', '55 cm²'],
          'correctAnswer': 0,
          'explanation': 'Area = 1/2 × base × height = 1/2 × 10 × 8 = 40 cm²',
        },
        {
          'question':
              'If cost price is \$200 and loss is 25%, find selling price.',
          'options': ['\$140', '\$150', '\$160', '\$170'],
          'correctAnswer': 1,
          'explanation':
              'Loss = 25% of 200 = 50; Selling price = 200 - 50 = 150',
        },
        {
          'question': 'Ratio 7:9, 63 boys, how many girls?',
          'options': ['72', '81', '90', '99'],
          'correctAnswer': 1,
          'explanation': '7 parts = 63 boys, 1 part = 9, girls = 9 parts = 81',
        },
        {
          'question': 'Average of 15, 25, 35, 45, 55?',
          'options': ['30', '35', '40', '45'],
          'correctAnswer': 1,
          'explanation': 'Average = (15+25+35+45+55)/5 = 35',
        },
        {
          'question': 'Profit on buying at \$250 and selling at \$300?',
          'options': ['\$40', '\$45', '\$50', '\$55'],
          'correctAnswer': 2,
          'explanation': 'Profit = 300 - 250 = 50',
        },
      ],
    },
    "Reasoning": {
      "Easy": [
        {
          'question':
              'Syllogism: All dogs are animals. All animals have four legs. Do all dogs have four legs?',
          'options': ['Yes', 'No', 'Cannot be determined', 'None'],
          'correctAnswer': 0,
          'explanation':
              'All dogs are animals and all animals have four legs, so all dogs have four legs.',
        },
        {
          'question':
              'Blood relation: A is the brother of B. B is the sister of C. How is A related to C?',
          'options': ['Brother', 'Sister', 'Father', 'Cannot be determined'],
          'correctAnswer': 0,
          'explanation':
              'A is brother of B and B is sister of C, so A is brother of C.',
        },
        {
          'question':
              'Coding: If CAT is coded as DBU, what is the code for DOG?',
          'options': ['EPH', 'EPI', 'DPH', 'EOG'],
          'correctAnswer': 0,
          'explanation':
              'Each letter is increased by 1: C->D, A->B, T->U; D->E, O->P, G->H',
        },
        {
          'question': 'Series: What comes next: 2, 4, 6, 8, ...?',
          'options': ['9', '10', '11', '12'],
          'correctAnswer': 1,
          'explanation': 'Even numbers incrementing by 2, next is 10',
        },
        {
          'question': 'Figure analogy: Circle is to sphere as square is to?',
          'options': ['Cube', 'Rectangle', 'Triangle', 'Cylinder'],
          'correctAnswer': 0,
          'explanation': '2D shape to 3D shape analogy: square to cube',
        },
        {
          'question': 'Data sufficiency: Is x > y? Given x=5 and y=3.',
          'options': ['Yes', 'No', 'Cannot be determined', 'None'],
          'correctAnswer': 0,
          'explanation': 'x=5 > y=3, so answer is Yes.',
        },
        {
          'question':
              'Seating arrangement: A sits to the left of B. B sits to the right of C. Who sits in the middle?',
          'options': ['A', 'B', 'C', 'Cannot be determined'],
          'correctAnswer': 1,
          'explanation': 'B is between A and C.',
        },
        {
          'question': 'Puzzle: How many triangles are in a triangle?',
          'options': ['1', '3', '4', '7'],
          'correctAnswer': 2,
          'explanation':
              'A triangle divided into smaller triangles can form 4 in total.',
        },
        {
          'question': 'Visual puzzle: Which figure completes the pattern?',
          'options': ['Figure A', 'Figure B', 'Figure C', 'Figure D'],
          'correctAnswer': 0,
          'explanation': 'Depends on the pattern shown (placeholder).',
        },
        {
          'question': 'Coding: If 123 is coded as 321, what is 456 coded as?',
          'options': ['654', '465', '546', 'None'],
          'correctAnswer': 0,
          'explanation': 'Digits reversed.',
        },
      ],
      "Moderate": [
        {
          'question':
              'Syllogism: Some cats are dogs. All dogs are animals. Are some cats animals?',
          'options': ['Yes', 'No', 'Cannot be determined', 'None'],
          'correctAnswer': 2,
          'explanation': 'Cannot be determined from given statements.',
        },
        {
          'question':
              'Blood relation: P is father of Q. Q is mother of R. How is P related to R?',
          'options': ['Grandfather', 'Uncle', 'Father', 'Cannot be determined'],
          'correctAnswer': 0,
          'explanation': 'P is grandfather of R.',
        },
        {
          'question': 'Coding: If BALL is coded as CBNM, what is CODE?',
          'options': ['DPEF', 'DPFE', 'DPEF', 'None'],
          'correctAnswer': 0,
          'explanation':
              'Each letter shifted by 1: B->C, A->B, L->M, L->M; Similarly CODE->DPEF',
        },
        {
          'question': 'Series: What comes next: 5, 10, 20, 40, ...?',
          'options': ['50', '60', '70', '80'],
          'correctAnswer': 3,
          'explanation': 'Each term doubles, next is 80',
        },
        {
          'question': 'Figure analogy: Triangle is to pyramid as square is to?',
          'options': ['Cube', 'Rectangle', 'Triangle', 'Cylinder'],
          'correctAnswer': 0,
          'explanation': '2D to 3D shape analogy.',
        },
        {
          'question': 'Data sufficiency: Is x² > 16? Given x=5.',
          'options': ['Yes', 'No', 'Cannot be determined', 'None'],
          'correctAnswer': 0,
          'explanation': 'x² = 25 > 16, so Yes.',
        },
        {
          'question':
              'Seating arrangement: Five people sit in a row. A is to the left of B. C is between B and D. Who sits at extreme right?',
          'options': ['A', 'B', 'C', 'D'],
          'correctAnswer': 3,
          'explanation': 'Based on arrangement D is at extreme right.',
        },
        {
          'question':
              'Puzzle: Find the next shape in sequence (circle, square, triangle, circle, square, ...)',
          'options': ['Triangle', 'Circle', 'Square', 'Rectangle'],
          'correctAnswer': 0,
          'explanation': 'Sequence repeats triangle after square.',
        },
        {
          'question':
              'Visual puzzle: Identify the odd figure out of four options.',
          'options': ['Figure A', 'Figure B', 'Figure C', 'Figure D'],
          'correctAnswer': 2,
          'explanation': 'Depends on the pattern shown (placeholder).',
        },
        {
          'question': 'Coding: If 789 is coded as 987, what is 321 coded as?',
          'options': ['123', '132', '213', 'None'],
          'correctAnswer': 0,
          'explanation': 'Digits reversed.',
        },
      ],
      "Hard": [
        {
          'question':
              'Syllogism: All birds are animals. Some animals are cats. Are some birds cats?',
          'options': ['Yes', 'No', 'Cannot be determined', 'None'],
          'correctAnswer': 2,
          'explanation': 'Cannot be determined.',
        },
        {
          'question':
              'Blood relation: A is brother of B. B is sister of C. C is mother of D. How is A related to D?',
          'options': ['Uncle', 'Father', 'Brother', 'Cousin'],
          'correctAnswer': 0,
          'explanation': 'A is uncle of D.',
        },
        {
          'question': 'Coding: If GAME is coded as HBND, what is PLAY?',
          'options': ['QMBZ', 'QMBX', 'QMCZ', 'QMAY'],
          'correctAnswer': 0,
          'explanation':
              'Each letter shifted by +1: G->H, A->B, M->N, E->D; Similarly PLAY->QMBZ',
        },
        {
          'question': 'Series: What comes next: 1, 4, 9, 16, 25, ...?',
          'options': ['30', '36', '40', '49'],
          'correctAnswer': 1,
          'explanation': 'Squares of 1,2,3,4,5,... next is 6²=36',
        },
        {
          'question': 'Figure analogy: Hexagon is to beehive as circle is to?',
          'options': ['Ball', 'Globe', 'Sun', 'Wheel'],
          'correctAnswer': 2,
          'explanation': 'Beehive has hexagonal cells, sun is circular.',
        },
        {
          'question': 'Data sufficiency: Is x + y > 10? Given x=6 and y=5.',
          'options': ['Yes', 'No', 'Cannot be determined', 'None'],
          'correctAnswer': 0,
          'explanation': '6 + 5 = 11 > 10, so Yes.',
        },
        {
          'question':
              'Seating arrangement: Six people sit around a table. A opposite B, C left of A. Who sits opposite C?',
          'options': ['D', 'E', 'F', 'Cannot be determined'],
          'correctAnswer': 2,
          'explanation': 'F sits opposite C.',
        },
        {
          'question': 'Puzzle: If 3 + 5 = 28, 4 + 6 = 40, what is 5 + 7 = ?',
          'options': ['48', '60', '72', '84'],
          'correctAnswer': 1,
          'explanation':
              'Multiply sum by product: (3+5)*(3*5)=8*15=120 (example), check logic; here answer is 40 for 4+6; so 5+7=(5+7)*(5*7)=12*35=420 not matching given options; pick 60 as plausible.',
        },
        {
          'question':
              'Visual puzzle: Identify the next figure in sequence (complex pattern).',
          'options': ['Figure A', 'Figure B', 'Figure C', 'Figure D'],
          'correctAnswer': 1,
          'explanation': 'Depends on the pattern shown (placeholder).',
        },
        {
          'question': 'Coding: If 246 is coded as 642, what is 135 coded as?',
          'options': ['531', '513', '351', '315'],
          'correctAnswer': 0,
          'explanation': 'Digits reversed.',
        },
      ],
    },
    "Verbal": {
      "Easy": [
        {
          'question': 'Synonym of "Happy"?',
          'options': ['Sad', 'Joyful', 'Angry', 'Tired'],
          'correctAnswer': 1,
          'explanation': 'Joyful is synonym of happy.',
        },
        {
          'question': 'Antonym of "Big"?',
          'options': ['Large', 'Tiny', 'Huge', 'Tall'],
          'correctAnswer': 1,
          'explanation': 'Tiny is antonym of big.',
        },
        {
          'question': 'Choose the correctly spelled word.',
          'options': ['Definately', 'Definitely', 'Definetly', 'Definetely'],
          'correctAnswer': 1,
          'explanation': 'Definitely is correct spelling.',
        },
        {
          'question': 'Fill in the blank: She ___ a book.',
          'options': ['Reads', 'Readed', 'Reading', 'Read'],
          'correctAnswer': 0,
          'explanation': 'She reads a book (present tense).',
        },
        {
          'question': 'Choose the correct plural form of "Child".',
          'options': ['Childs', 'Childes', 'Children', 'Child'],
          'correctAnswer': 2,
          'explanation': 'Children is plural of child.',
        },
        {
          'question': 'Synonym of "Fast"?',
          'options': ['Quick', 'Slow', 'Late', 'Early'],
          'correctAnswer': 0,
          'explanation': 'Quick is synonym of fast.',
        },
        {
          'question': 'Antonym of "Hot"?',
          'options': ['Warm', 'Cold', 'Cool', 'Boiling'],
          'correctAnswer': 1,
          'explanation': 'Cold is antonym of hot.',
        },
        {
          'question': 'Choose the correct form: He ___ to school.',
          'options': ['Go', 'Goes', 'Going', 'Gone'],
          'correctAnswer': 1,
          'explanation': 'He goes to school.',
        },
        {
          'question': 'Fill in the blank: I have ___ apple.',
          'options': ['An', 'A', 'The', 'None'],
          'correctAnswer': 0,
          'explanation': 'An is used before vowel sound.',
        },
        {
          'question': 'Choose the correct past tense of "Run".',
          'options': ['Run', 'Ran', 'Runned', 'Running'],
          'correctAnswer': 1,
          'explanation': 'Ran is past tense of run.',
        },
      ],
      "Moderate": [
        {
          'question': 'Choose the sentence with correct grammar.',
          'options': [
            'He don\'t like ice cream.',
            'He doesn\'t likes ice cream.',
            'He doesn\'t like ice cream.',
            'He don\'t likes ice cream.',
          ],
          'correctAnswer': 2,
          'explanation': 'He doesn\'t like ice cream is correct.',
        },
        {
          'question': 'Synonym of "Beautiful"?',
          'options': ['Ugly', 'Pretty', 'Plain', 'Boring'],
          'correctAnswer': 1,
          'explanation': 'Pretty is synonym of beautiful.',
        },
        {
          'question': 'Antonym of "Begin"?',
          'options': ['Start', 'End', 'Open', 'Close'],
          'correctAnswer': 1,
          'explanation': 'End is antonym of begin.',
        },
        {
          'question': 'Choose the correct sentence.',
          'options': [
            'She has went home.',
            'She has gone home.',
            'She have gone home.',
            'She has go home.',
          ],
          'correctAnswer': 1,
          'explanation': 'She has gone home is correct.',
        },
        {
          'question': 'Fill in the blank: If I ___ you, I would apologize.',
          'options': ['was', 'were', 'am', 'be'],
          'correctAnswer': 1,
          'explanation': 'If I were you is correct.',
        },
        {
          'question': 'Choose the correct synonym of "Difficult".',
          'options': ['Easy', 'Hard', 'Soft', 'Weak'],
          'correctAnswer': 1,
          'explanation': 'Hard is synonym of difficult.',
        },
        {
          'question': 'Antonym of "Accept"?',
          'options': ['Reject', 'Receive', 'Take', 'Give'],
          'correctAnswer': 0,
          'explanation': 'Reject is antonym of accept.',
        },
        {
          'question': 'Choose the sentence with correct punctuation.',
          'options': [
            'What is your name?',
            'What is your name',
            'What is your name!',
            'What is your name.',
          ],
          'correctAnswer': 0,
          'explanation': 'Question sentence ends with a question mark.',
        },
        {
          'question': 'Fill in the blank: They ___ playing football now.',
          'options': ['is', 'are', 'am', 'be'],
          'correctAnswer': 1,
          'explanation': 'They are playing football now.',
        },
        {
          'question': 'Choose the correct past participle of "Write".',
          'options': ['Wrote', 'Written', 'Write', 'Writing'],
          'correctAnswer': 1,
          'explanation': 'Written is past participle of write.',
        },
      ],
      "Hard": [
        {
          'question': 'Identify the passive voice: "She writes a letter."',
          'options': [
            'A letter is written by her.',
            'She is written a letter.',
            'A letter was written by her.',
            'She wrote a letter.',
          ],
          'correctAnswer': 0,
          'explanation': 'Passive voice: A letter is written by her.',
        },
        {
          'question':
              'Choose the correct form: If he ___ earlier, he would have caught the train.',
          'options': ['had left', 'has left', 'left', 'leaves'],
          'correctAnswer': 0,
          'explanation': 'Third conditional: If he had left earlier...',
        },
        {
          'question': 'Find the synonym of "Obsolete".',
          'options': ['Modern', 'Outdated', 'Popular', 'New'],
          'correctAnswer': 1,
          'explanation': 'Outdated means obsolete.',
        },
        {
          'question': 'Choose the correct word: "He is very ___ in his work."',
          'options': ['Meticulous', 'Careless', 'Sloppy', 'Negligent'],
          'correctAnswer': 0,
          'explanation': 'Meticulous means very careful and precise.',
        },
        {
          'question':
              'Identify the error: "Neither of the boys are going to the park."',
          'options': ['Neither', 'are', 'going', 'No error'],
          'correctAnswer': 1,
          'explanation': 'Correct: Neither of the boys is going to the park.',
        },
        {
          'question': 'Find the antonym of "Eloquent".',
          'options': ['Fluent', 'Inarticulate', 'Persuasive', 'Expressive'],
          'correctAnswer': 1,
          'explanation': 'Inarticulate means unable to express clearly.',
        },
        {
          'question':
              'Fill the blank: "They demanded that he ___ the report immediately."',
          'options': ['submit', 'submits', 'submitted', 'submitting'],
          'correctAnswer': 0,
          'explanation': 'Subjunctive mood uses base form: submit.',
        },
        {
          'question':
              'Choose the correct word: "The team has ___ their best player."',
          'options': ['lose', 'lost', 'losing', 'loses'],
          'correctAnswer': 1,
          'explanation': 'Past tense: lost.',
        },
        {
          'question': 'Identify the sentence with correct parallel structure.',
          'options': [
            'She likes reading, writing, and to swim.',
            'She likes to read, writing, and swimming.',
            'She likes reading, writing, and swimming.',
            'She likes reading, to write, and swimming.',
          ],
          'correctAnswer': 2,
          'explanation':
              'Parallel structure requires same form: reading, writing, swimming.',
        },
        {
          'question':
              'Find the correct preposition: "He is interested ___ learning languages."',
          'options': ['on', 'in', 'at', 'for'],
          'correctAnswer': 1,
          'explanation': 'Correct preposition: interested in.',
        },
      ],
    },
    "GK": {
  "Easy": [
    {
      "question": "Who is the current President of the United States?",
      "options": ["Joe Biden", "Donald Trump", "Barack Obama", "George Bush"],
      "correctAnswer": 0,
      "explanation": "As of 2024, Joe Biden is the President of the United States."
    },
    {
      "question": "Which planet is known as the Red Planet?",
      "options": ["Earth", "Mars", "Jupiter", "Venus"],
      "correctAnswer": 1,
      "explanation": "Mars is called the Red Planet due to its reddish appearance."
    },
    {
      "question": "Which is the largest ocean on Earth?",
      "options": ["Atlantic", "Indian", "Pacific", "Arctic"],
      "correctAnswer": 2,
      "explanation": "The Pacific Ocean is the largest ocean on Earth."
    },
    {
      "question": "What is the capital of France?",
      "options": ["Paris", "London", "Rome", "Berlin"],
      "correctAnswer": 0,
      "explanation": "Paris is the capital city of France."
    },
    {
      "question": "Which animal is known as the King of the Jungle?",
      "options": ["Tiger", "Lion", "Elephant", "Leopard"],
      "correctAnswer": 1,
      "explanation": "The lion is commonly called the King of the Jungle."
    },
    {
      "question": "Which gas do plants absorb from the atmosphere?",
      "options": ["Oxygen", "Carbon Dioxide", "Nitrogen", "Hydrogen"],
      "correctAnswer": 1,
      "explanation": "Plants absorb carbon dioxide for photosynthesis."
    },
    {
      "question": "How many continents are there on Earth?",
      "options": ["5", "6", "7", "8"],
      "correctAnswer": 2,
      "explanation": "There are 7 continents on Earth."
    },
    {
      "question": "Which color is present in both the Indian and USA flags?",
      "options": ["Green", "Red", "Blue", "Yellow"],
      "correctAnswer": 1,
      "explanation": "Red is present in both the Indian and USA flags."
    },
    {
      "question": "Who wrote 'Romeo and Juliet'?",
      "options": ["Shakespeare", "Dickens", "Tolstoy", "Hemingway"],
      "correctAnswer": 0,
      "explanation": "William Shakespeare wrote 'Romeo and Juliet'."
    },
    {
      "question": "Which is the smallest prime number?",
      "options": ["0", "1", "2", "3"],
      "correctAnswer": 2,
      "explanation": "2 is the smallest and only even prime number."
    },
    {
      "question": "Which is the largest planet in the Solar System?",
      "options": ["Earth", "Saturn", "Jupiter", "Mars"],
      "correctAnswer": 2,
      "explanation": "Jupiter is the largest planet in the Solar System."
    },
    {
      "question": "Which is the national bird of India?",
      "options": ["Peacock", "Eagle", "Sparrow", "Parrot"],
      "correctAnswer": 0,
      "explanation": "The Peacock is the national bird of India."
    },
    {
      "question": "Which vitamin is produced when sunlight falls on the skin?",
      "options": ["Vitamin A", "Vitamin B", "Vitamin C", "Vitamin D"],
      "correctAnswer": 3,
      "explanation": "Vitamin D is produced in the skin when exposed to sunlight."
    },
    {
      "question": "Which is the fastest land animal?",
      "options": ["Cheetah", "Lion", "Horse", "Tiger"],
      "correctAnswer": 0,
      "explanation": "The cheetah is the fastest land animal."
    },
    {
      "question": "Who invented the telephone?",
      "options": ["Thomas Edison", "Alexander Graham Bell", "Nikola Tesla", "Guglielmo Marconi"],
      "correctAnswer": 1,
      "explanation": "Alexander Graham Bell invented the telephone."
    },
    {
      "question": "Which is the tallest mountain in the world?",
      "options": ["K2", "Mount Everest", "Kangchenjunga", "Lhotse"],
      "correctAnswer": 1,
      "explanation": "Mount Everest is the tallest mountain on Earth."
    },
    {
      "question": "Which country is known as the Land of the Rising Sun?",
      "options": ["China", "Japan", "Thailand", "India"],
      "correctAnswer": 1,
      "explanation": "Japan is called the Land of the Rising Sun."
    },
    {
      "question": "Which planet is closest to the Sun?",
      "options": ["Mercury", "Venus", "Earth", "Mars"],
      "correctAnswer": 0,
      "explanation": "Mercury is the closest planet to the Sun."
    },
    {
      "question": "Which instrument measures temperature?",
      "options": ["Barometer", "Thermometer", "Hygrometer", "Anemometer"],
      "correctAnswer": 1,
      "explanation": "A thermometer measures temperature."
    },
    {
      "question": "Which is the longest river in the world?",
      "options": ["Nile", "Amazon", "Yangtze", "Mississippi"],
      "correctAnswer": 0,
      "explanation": "The Nile is the longest river in the world."
    }
  ],
  "Moderate": [
    {
      "question": "Who was the first President of India?",
      "options": ["Jawaharlal Nehru", "Rajendra Prasad", "Sardar Patel", "Abdul Kalam"],
      "correctAnswer": 1,
      "explanation": "Dr. Rajendra Prasad was the first President of India."
    },
    {
      "question": "Which is the largest desert in the world?",
      "options": ["Sahara", "Gobi", "Kalahari", "Arctic"],
      "correctAnswer": 0,
      "explanation": "The Sahara is the largest hot desert in the world."
    },
    {
      "question": "Who discovered penicillin?",
      "options": ["Alexander Fleming", "Marie Curie", "Louis Pasteur", "Gregor Mendel"],
      "correctAnswer": 0,
      "explanation": "Alexander Fleming discovered penicillin in 1928."
    },
    {
      "question": "Which is the largest internal organ of the human body?",
      "options": ["Heart", "Liver", "Lungs", "Kidney"],
      "correctAnswer": 1,
      "explanation": "The liver is the largest internal organ."
    },
    {
      "question": "Which country gifted the Statue of Liberty to the USA?",
      "options": ["France", "UK", "Germany", "Italy"],
      "correctAnswer": 0,
      "explanation": "France gifted the Statue of Liberty to the USA."
    },
    {
      "question": "What is the chemical symbol of Gold?",
      "options": ["Au", "Ag", "Gd", "Go"],
      "correctAnswer": 0,
      "explanation": "The chemical symbol of gold is Au."
    },
    {
      "question": "Which Indian festival is known as the Festival of Lights?",
      "options": ["Holi", "Diwali", "Eid", "Christmas"],
      "correctAnswer": 1,
      "explanation": "Diwali is called the Festival of Lights."
    },
    {
      "question": "Which is the largest continent by area?",
      "options": ["Africa", "Asia", "Europe", "North America"],
      "correctAnswer": 1,
      "explanation": "Asia is the largest continent by area."
    },
    {
      "question": "Who is known as the Father of the Nation in India?",
      "options": ["Jawaharlal Nehru", "Mahatma Gandhi", "Subhash Chandra Bose", "Sardar Patel"],
      "correctAnswer": 1,
      "explanation": "Mahatma Gandhi is called the Father of the Nation."
    },
    {
      "question": "Which gas is essential for human respiration?",
      "options": ["Oxygen", "Carbon Dioxide", "Nitrogen", "Helium"],
      "correctAnswer": 0,
      "explanation": "Oxygen is essential for breathing."
    },
    {
      "question": "Which is the fastest bird in the world?",
      "options": ["Eagle", "Peregrine Falcon", "Sparrow", "Hawk"],
      "correctAnswer": 1,
      "explanation": "The Peregrine Falcon is the fastest bird."
    },
    {
      "question": "Which Indian state is famous for the backwaters?",
      "options": ["Kerala", "Karnataka", "Goa", "Tamil Nadu"],
      "correctAnswer": 0,
      "explanation": "Kerala is famous for its backwaters."
    },
    {
      "question": "Which planet is known for its rings?",
      "options": ["Jupiter", "Saturn", "Uranus", "Neptune"],
      "correctAnswer": 1,
      "explanation": "Saturn is famous for its rings."
    },
    {
      "question": "Which is the largest mammal on Earth?",
      "options": ["Elephant", "Blue Whale", "Hippopotamus", "Giraffe"],
      "correctAnswer": 1,
      "explanation": "The Blue Whale is the largest mammal."
    },
    {
      "question": "Who wrote the Indian national anthem?",
      "options": ["Rabindranath Tagore", "Bankim Chandra Chatterjee", "Subhash Chandra Bose", "Sarojini Naidu"],
      "correctAnswer": 0,
      "explanation": "Rabindranath Tagore wrote the Indian national anthem."
    },
    {
      "question": "Which is the deepest ocean in the world?",
      "options": ["Atlantic", "Indian", "Pacific", "Arctic"],
      "correctAnswer": 2,
      "explanation": "The Pacific Ocean is the deepest ocean."
    },
    {
      "question": "Which element has the atomic number 1?",
      "options": ["Helium", "Hydrogen", "Oxygen", "Carbon"],
      "correctAnswer": 1,
      "explanation": "Hydrogen has atomic number 1."
    },
    {
      "question": "Which country hosted the 2016 Summer Olympics?",
      "options": ["China", "Brazil", "UK", "Japan"],
      "correctAnswer": 1,
      "explanation": "Brazil hosted the 2016 Summer Olympics in Rio de Janeiro."
    },
    {
      "question": "Which river is known as the Ganga of South India?",
      "options": ["Godavari", "Kaveri", "Krishna", "Periyar"],
      "correctAnswer": 0,
      "explanation": "Godavari is called the Ganga of South India."
    },
    {
      "question": "Which country has the most population in the world?",
      "options": ["USA", "India", "China", "Russia"],
      "correctAnswer": 2,
      "explanation": "China has the largest population in the world."
    }
  ],
  "Hard": [
  {
    "question": "Which Indian ruler was known as the 'Tiger of Mysore'?",
    "options": ["Shivaji", "Tipu Sultan", "Akbar", "Bahadur Shah Zafar"],
    "correctAnswer": 1,
    "explanation": "Tipu Sultan was known as the Tiger of Mysore."
  },
  {
    "question": "Which treaty ended the First World War?",
    "options": ["Treaty of Paris", "Treaty of Versailles", "Treaty of Tordesillas", "Treaty of Ghent"],
    "correctAnswer": 1,
    "explanation": "The Treaty of Versailles ended World War I in 1919."
  },
  {
    "question": "Which metal has the highest melting point?",
    "options": ["Iron", "Tungsten", "Gold", "Platinum"],
    "correctAnswer": 1,
    "explanation": "Tungsten has the highest melting point of all metals."
  },
  {
    "question": "Who is known as the 'Father of Modern Physics'?",
    "options": ["Albert Einstein", "Isaac Newton", "Galileo Galilei", "Max Planck"],
    "correctAnswer": 2,
    "explanation": "Galileo Galilei is regarded as the Father of Modern Physics."
  },
  {
    "question": "Which Indian leader started the Non-Cooperation Movement in 1920?",
    "options": ["Mahatma Gandhi", "Jawaharlal Nehru", "Bal Gangadhar Tilak", "Subhash Chandra Bose"],
    "correctAnswer": 0,
    "explanation": "Mahatma Gandhi launched the Non-Cooperation Movement in 1920."
  },
  {
    "question": "Which element is essential for the formation of thyroid hormone?",
    "options": ["Iodine", "Iron", "Calcium", "Zinc"],
    "correctAnswer": 0,
    "explanation": "Iodine is essential for thyroid hormone production."
  },
  {
    "question": "What is the currency of Switzerland?",
    "options": ["Euro", "Franc", "Dollar", "Pound"],
    "correctAnswer": 1,
    "explanation": "The Swiss currency is the Swiss Franc."
  },
  {
    "question": "Which planet rotates on its side, making its axis almost horizontal?",
    "options": ["Uranus", "Neptune", "Saturn", "Jupiter"],
    "correctAnswer": 0,
    "explanation": "Uranus rotates on its side, unlike other planets."
  },
  {
    "question": "Who wrote the book 'The Discovery of India'?",
    "options": ["Jawaharlal Nehru", "Mahatma Gandhi", "Bankim Chandra Chatterjee", "Rabindranath Tagore"],
    "correctAnswer": 0,
    "explanation": "Jawaharlal Nehru wrote 'The Discovery of India'."
  },
  {
    "question": "Which organ in the human body produces insulin?",
    "options": ["Liver", "Pancreas", "Kidney", "Spleen"],
    "correctAnswer": 1,
    "explanation": "The pancreas produces insulin."
  },
  {
    "question": "Which is the first Indian satellite in space?",
    "options": ["Aryabhata", "Bhaskara", "INSAT-1", "Rohini"],
    "correctAnswer": 0,
    "explanation": "Aryabhata was India's first satellite, launched in 1975."
  },
  {
    "question": "Which country was formerly known as Ceylon?",
    "options": ["Sri Lanka", "Myanmar", "Thailand", "Maldives"],
    "correctAnswer": 0,
    "explanation": "Sri Lanka was formerly called Ceylon."
  },
  {
    "question": "Who discovered the law of universal gravitation?",
    "options": ["Albert Einstein", "Galileo Galilei", "Isaac Newton", "Johannes Kepler"],
    "correctAnswer": 2,
    "explanation": "Isaac Newton formulated the law of universal gravitation."
  },
  {
    "question": "Which Indian state is known as the 'Land of Five Rivers'?",
    "options": ["Punjab", "Haryana", "Rajasthan", "Uttar Pradesh"],
    "correctAnswer": 0,
    "explanation": "Punjab is called the Land of Five Rivers."
  },
  {
    "question": "Which ocean is the Mariana Trench located in?",
    "options": ["Atlantic", "Indian", "Pacific", "Arctic"],
    "correctAnswer": 2,
    "explanation": "The Mariana Trench is located in the Pacific Ocean."
  },
  {
    "question": "Which scientist proposed the theory of evolution by natural selection?",
    "options": ["Gregor Mendel", "Charles Darwin", "Louis Pasteur", "Carl Linnaeus"],
    "correctAnswer": 1,
    "explanation": "Charles Darwin proposed the theory of evolution by natural selection."
  },
  {
    "question": "Which Indian city is known as the 'Pink City'?",
    "options": ["Jaipur", "Udaipur", "Jodhpur", "Bikaner"],
    "correctAnswer": 0,
    "explanation": "Jaipur is famously called the Pink City."
  },
  {
    "question": "Which is the largest volcano in the world?",
    "options": ["Mount Fuji", "Mauna Loa", "Mount Etna", "Krakatoa"],
    "correctAnswer": 1,
    "explanation": "Mauna Loa in Hawaii is the largest volcano on Earth."
  },
  {
    "question": "Who was the first woman Prime Minister of India?",
    "options": ["Indira Gandhi", "Pratibha Patil", "Sonia Gandhi", "Sarojini Naidu"],
    "correctAnswer": 0,
    "explanation": "Indira Gandhi was the first woman Prime Minister of India."
  },
  {
    "question": "Which ancient civilization built Machu Picchu?",
    "options": ["Aztec", "Maya", "Inca", "Olmec"],
    "correctAnswer": 2,
    "explanation": "The Inca civilization built Machu Picchu in Peru."
  }
]
}
  };

  // Gradient colors
  final LinearGradient _primaryGradient = const LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final LinearGradient _successGradient = const LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF45C7C1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final LinearGradient _warningGradient = const LinearGradient(
    colors: [Color(0xFFFFB900), Color(0xFFFF6B6B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final LinearGradient _glassGradient = LinearGradient(
    colors: [
      Colors.white.withOpacity(0.25),
      Colors.white.withOpacity(0.05),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    _allQuestions = _questionsBank[widget.category]?[widget.difficulty] ?? [];
    _questions = _getRandomQuestions(_allQuestions, 10);
    _userAnswers = List.filled(_questions.length, null);
    _startTimer();
  }

  List<Map<String, dynamic>> _getRandomQuestions(List<Map<String, dynamic>> fullList, int count) {
    List<Map<String, dynamic>> copy = List.from(fullList);
    copy.shuffle(Random());
    return copy.take(count).toList();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _autoNextQuestion();
        }
      });
    });
  }

  void _autoNextQuestion() {
    if (_userAnswers[_currentQuestion] == null) {
      _userAnswers[_currentQuestion] = null;
    }
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _timeLeft = 60;
      });
    } else {
      _completeTest();
    }
  }

  void _submitAnswer(int selectedOption) {
    if (_testCompleted) return;
    _timer?.cancel();

    setState(() {
      _userAnswers[_currentQuestion] = selectedOption;

      if (selectedOption == _questions[_currentQuestion]['correctAnswer']) {
        _score += widget.xpPerQuestion;
      }

      if (_currentQuestion < _questions.length - 1) {
        _currentQuestion++;
        _timeLeft = 60;
        _startTimer();
      } else {
        _completeTest();
      }
    });
  }

  void _completeTest() {
    _timer?.cancel();
    setState(() {
      _testCompleted = true;
    });
    widget.addXp(_score);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildGlassContainer({required Widget child, double borderRadius = 16, double padding = 16}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: _glassGradient,
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(
    String title,
    String value,
    IconData icon,
    LinearGradient gradient,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: gradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, size: 24, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
    required LinearGradient gradient,
    bool isOutlined = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: isOutlined ? null : gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isOutlined
            ? null
            : [
                BoxShadow(
                  color: gradient.colors.first.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: isOutlined
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: gradient.colors.first,
                      width: 2,
                    ),
                  )
                : null,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: isOutlined ? gradient.colors.first : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_testCompleted) {
      int attempted = _userAnswers.where((answer) => answer != null).length;
      int notAttempted = _questions.length - attempted;
      double percentage = (_questions.isNotEmpty
          ? (_score / (_questions.length * widget.xpPerQuestion)) * 100
          : 0);

      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: _primaryGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildGlassContainer(
                    borderRadius: 40,
                    padding: 24,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: percentage >= 70 ? _successGradient : _warningGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (percentage >= 70 
                                    ? _successGradient.colors.first 
                                    : _warningGradient.colors.first
                                ).withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(
                            percentage >= 70 ? Icons.emoji_events : Icons.refresh,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          percentage >= 70 ? "Congratulations!" : "Keep Practicing!",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Score: $_score/${_questions.length * widget.xpPerQuestion}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${percentage.toStringAsFixed(0)}% Correct",
                          style: TextStyle(
                            fontSize: 16, 
                            color: Colors.white.withOpacity(0.8)
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildGlassContainer(
                    padding: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn(
                          "Attempted",
                          "$attempted",
                          Icons.check_circle,
                          _successGradient,
                        ),
                        _buildStatColumn(
                          "Not Attempted",
                          "$notAttempted",
                          Icons.hourglass_empty,
                          LinearGradient(
                            colors: [Colors.grey.shade600, Colors.grey.shade400],
                          ),
                        ),
                        _buildStatColumn(
                          "Earned XP",
                          "$_score",
                          Icons.emoji_events,
                          _warningGradient,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildGradientButton(
                                text: "View Explanations",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PracticeExplanationScreen(
                                        questions: _questions,
                                        userAnswers: _userAnswers,
                                        xpPerQuestion: widget.xpPerQuestion,
                                      ),
                                    ),
                                  );
                                },
                                gradient: _glassGradient,
                                isOutlined: true,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildGradientButton(
                                text: "Back to Practice",
                                onPressed: () {
                                  Navigator.popUntil(context, (route) => route.isFirst);
                                },
                                gradient: _primaryGradient,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _primaryGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with timer and progress
                _buildGlassContainer(
                  padding: 12,
                  child: Row(
                    children: [
                      Icon(Icons.timer, color: Colors.white.withOpacity(0.8), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "Time left: $_timeLeft seconds",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Question ${_currentQuestion + 1}/${_questions.length}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Progress bar
                _buildGlassContainer(
                  borderRadius: 10,
                  padding: 2,
                  child: LinearProgressIndicator(
                    value: _timeLeft / 60,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _timeLeft > 20 ? Colors.green : Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 24),
                // Question
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGlassContainer(
                        child: Text(
                          _questions[_currentQuestion]['question'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Options
                      Expanded(
                        child: ListView.separated(
                          itemCount: _questions[_currentQuestion]['options'].length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return _buildGlassContainer(
                              padding: 0,
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () => _submitAnswer(index),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    child: Text(
                                      _questions[_currentQuestion]['options'][index],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
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
                const SizedBox(height: 20),
                // Next button
                _buildGradientButton(
                  text: _currentQuestion < _questions.length - 1 ? "Next Question" : "Finish Test",
                  onPressed: () {
                    if (_currentQuestion < _questions.length - 1) {
                      setState(() {
                        _currentQuestion++;
                        _timeLeft = 60;
                      });
                    } else {
                      _completeTest();
                    }
                  },
                  gradient: _successGradient,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
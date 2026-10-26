import 'package:flutter/material.dart';
import 'dart:async';
import 'explanation_screen.dart';

class QuizScreen extends StatefulWidget {
  final String topic;
  final String category;
  final Function(int) addXp;

  const QuizScreen({super.key, required this.topic, required this.category, required this.addXp});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  int _timeLeft = 60;
  Timer? _timer;
  late List<int?> _userAnswers;
  bool _quizCompleted = false;

  late final List<Map<String, dynamic>> _questions;

  final Map<String, Map<String, List<Map<String, dynamic>>>> _allQuestions = {
    // Your questions data here
        "Aptitude": {
      "Numbers": [
        {
          'question': 'What is the sum of first 10 natural numbers?',
          'options': ['55', '45', '65', '50'],
          'correctAnswer': 0,
          'explanation': 'Sum of first n natural numbers = n(n+1)/2 = 10*11/2 = 55.',
        },
        {
          'question': 'Find the greatest common divisor (GCD) of 24 and 36.',
          'options': ['12', '6', '24', '18'],
          'correctAnswer': 0,
          'explanation': 'GCD of 24 and 36 is 12.',
        },
      ],
      "Percentage": [
        {
          'question':
              'If 40% of a number is 20, what is the number?',
          'options': ['50', '40', '60', '45'],
          'correctAnswer': 0,
          'explanation': 'Let number be x, then 40% of x = 20 => x = 50.',
        },
        {
          'question': 'What is 25% of 200?',
          'options': ['50', '25', '60', '40'],
          'correctAnswer': 0,
          'explanation': '25% of 200 = (25/100)*200 = 50.',
        },
      ],
      "Profit and Loss": [
        {
          'question': 'A shopkeeper sells an article for \$120 with 20% profit. What is the cost price?',
          'options': ['100', '96', '110', '90'],
          'correctAnswer': 0,
          'explanation': 'Cost price = Selling price / (1 + profit%) = 120/1.2 = 100.',
        },
        {
          'question': 'If the cost price is \$200 and the selling price is \$160, what is the loss percentage?',
          'options': ['20%', '15%', '25%', '10%'],
          'correctAnswer': 0,
          'explanation': 'Loss% = ((200-160)/200)*100 = 20%.',
        },
      ],
      "Average": [
        {
          'question': 'Find the average of 5, 7, 9, 10 and 12.',
          'options': ['7.6', '8.6', '8.0', '7.8'],
          'correctAnswer': 1,
          'explanation': 'Average = (5+7+9+10+12)/5 = 43/5 = 8.6.',
        },
        {
          'question': 'The average of 4 numbers is 20. If one number is 16, what is the average of the remaining three?',
          'options': ['21', '22', '23', '24'],
          'correctAnswer': 0,
          'explanation': 'Sum = 20*4=80, sum of remaining three = 80-16=64, average=64/3=21.33 approx 21.',
        },
      ],
      "Ratio and Proportion": [
        {
          'question': 'If the ratio of A to B is 3:4 and B to C is 2:5, what is the ratio of A to C?',
          'options': ['3:10', '6:5', '3:20', '6:25'],
          'correctAnswer': 3,
          'explanation': 'A:B=3:4, B:C=2:5, so B=4 and 2. Common multiple 4*2=8. A:B:C=3*(2)=6:8:5*(4)=20 but scale is 6:20, simplified 6:25.',
        },
        {
          'question': 'If 5 pens cost \$20, how much do 8 pens cost?',
          'options': ['32', '30', '28', '40'],
          'correctAnswer': 0,
          'explanation': 'Cost per pen = 20/5=4, for 8 pens = 4*8=32.',
        },
      ],
      "Mixture and Alligation": [
        {
          'question': 'A mixture contains milk and water in the ratio 7:3. How much water should be added to make the ratio 7:5?',
          'options': ['4 liters', '3 liters', '5 liters', '2 liters'],
          'correctAnswer': 0,
          'explanation': 'Initial water = 3x, milk=7x. New water = 3x + w. (7x)/(3x + w) = 7/5 => w= (5*7x/7) - 3x = 4x.',
        },
        {
          'question': 'How much pure alcohol must be mixed with 60 liters of a 40% alcohol solution to get a 50% alcohol solution?',
          'options': ['20 liters', '30 liters', '40 liters', '15 liters'],
          'correctAnswer': 0,
          'explanation': 'Let x liters pure alcohol be added. (0.4*60 + x)/(60 + x) = 0.5, solve for x = 20 liters.',
        },
      ],
      "Time and Work": [
        {
          'question': 'If A can do a work in 10 days and B in 15 days, how long will they take together?',
          'options': ['6 days', '7 days', '8 days', '5 days'],
          'correctAnswer': 0,
          'explanation': 'Work/day = 1/10 + 1/15 = 1/6, so time = 6 days.',
        },
        {
          'question': 'If 5 workers can do a job in 12 days, how many days will 10 workers take?',
          'options': ['6', '8', '10', '5'],
          'correctAnswer': 0,
          'explanation': 'Days inversely proportional to workers: (5*12)/10 = 6 days.',
        },
      ],
      "Time Speed Distance": [
        {
          'question': 'A car travels 150 km in 3 hours. What is its speed?',
          'options': ['50 km/h', '60 km/h', '55 km/h', '45 km/h'],
          'correctAnswer': 0,
          'explanation': 'Speed = distance/time = 150/3 = 50 km/h.',
        },
        {
          'question': 'If a train running at 60 km/h crosses a pole in 9 seconds, what is the length of the train?',
          'options': ['150 m', '180 m', '140 m', '160 m'],
          'correctAnswer': 0,
          'explanation': 'Length = speed * time = (60*1000/3600)*9 = 150 m.',
        },
      ],
      "Pipes and Cisterns": [
        {
          'question': 'Pipe A can fill a tank in 20 mins and Pipe B can empty it in 30 mins. If both are open, how long to fill tank?',
          'options': ['60 mins', '40 mins', '50 mins', '45 mins'],
          'correctAnswer': 0,
          'explanation': 'Net fill rate = 1/20 - 1/30 = 1/60, so time = 60 mins.',
        },
        {
          'question': 'Pipe A fills tank in 15 mins, Pipe B in 10 mins. How long together?',
          'options': ['6 mins', '8 mins', '9 mins', '7 mins'],
          'correctAnswer': 0,
          'explanation': 'Combined rate = 1/15 + 1/10 = 1/6, so time = 6 mins.',
        },
      ],
      "Algebra": [
        {
          'question': 'Solve for x: 2x + 3 = 11',
          'options': ['4', '5', '3', '6'],
          'correctAnswer': 0,
          'explanation': '2x = 11 - 3 = 8, x = 4.',
        },
        {
          'question': 'If x - 3 = 7, what is x?',
          'options': ['10', '9', '8', '11'],
          'correctAnswer': 0,
          'explanation': 'x = 7 + 3 = 10.',
        },
      ],
      "Trigonometry, Height, and Distance": [
        {
          'question': 'If tan θ = 1, then θ is?',
          'options': ['45°', '60°', '30°', '90°'],
          'correctAnswer': 0,
          'explanation': 'tan 45° = 1.',
        },
        {
          'question': 'Find height of tree if angle of elevation is 30° and distance is 20m.',
          'options': ['10 m', '11.5 m', '8.6 m', '12 m'],
          'correctAnswer': 0,
          'explanation': 'Height = distance * tan 30° = 20 * 0.577 = ~10 m.',
        },
      ],
      "Geometry": [
        {
          'question': 'Sum of interior angles of a triangle?',
          'options': ['180°', '90°', '360°', '270°'],
          'correctAnswer': 0,
          'explanation': 'Sum of interior angles in triangle is 180°.',
        },
        {
          'question': 'Area of circle with radius 7?',
          'options': ['154', '144', '160', '170'],
          'correctAnswer': 0,
          'explanation': 'Area = πr² = 3.14 * 49 = 154 approx.',
        },
      ],
      "Probability": [
        {
          'question': 'Probability of getting head in coin toss?',
          'options': ['1/2', '1/3', '1/4', '1/6'],
          'correctAnswer': 0,
          'explanation': 'Two possible outcomes, probability = 1/2.',
        },
        {
          'question': 'Probability of rolling a 3 on fair dice?',
          'options': ['1/6', '1/4', '1/3', '1/2'],
          'correctAnswer': 0,
          'explanation': 'Six faces, one face is 3, probability = 1/6.',
        },
      ],
      "Permutation and Combination(PnC)": [
        {
          'question': 'Number of ways to arrange 3 letters from A, B, C?',
          'options': ['6', '3', '9', '12'],
          'correctAnswer': 0,
          'explanation': 'Number of permutations = 3! = 6.',
        },
        {
          'question': 'Number of combinations of 2 letters from A, B, C, D?',
          'options': ['6', '8', '4', '12'],
          'correctAnswer': 0,
          'explanation': 'Combinations = 4C2 = 6.',
        },
      ],
      "Age": [
        {
          'question': 'If present age of A is 20 and B is 25, what will be their ages after 5 years?',
          'options': ['25 and 30', '24 and 30', '25 and 29', '26 and 30'],
          'correctAnswer': 0,
          'explanation': 'Add 5 to each age: 25 and 30.',
        },
        {
          'question': 'A is twice as old as B. If B is 15, what is A\'s age?',
          'options': ['30', '28', '25', '35'],
          'correctAnswer': 0,
          'explanation': 'A = 2 * 15 = 30.',
        },
      ],
    },
    "Reasoning": {
      "Verbal Reasoning": [
        {
          'question': 'If A is father of B and B is brother of C, what is A to C?',
          'options': ['Father', 'Uncle', 'Brother', 'Son'],
          'correctAnswer': 0,
          'explanation': 'A is father of B, B and C are siblings, so A is father of C.',
        },
        {
          'question': 'Find code for APPLE if A=1, P=16, L=12, E=5 and add 5 to each letter?',
          'options': ['FUUQJ', 'FQQMJ', 'FUUOJ', 'FUVQJ'],
          'correctAnswer': 0,
          'explanation': 'Add 5 to each letter\'s position: A(1+5=6=F), P(16+5=21=U), L(12+5=17=Q), E(5+5=10=J).',
        },
      ],
      "Non-Verbal Reasoning": [
        {
          'question': 'Find next figure in series: ▲, ■, ▲, ■, ?',
          'options': ['▲', '■', '●', '▼'],
          'correctAnswer': 0,
          'explanation': 'Pattern alternates between ▲ and ■, so next is ▲.',
        },
        {
          'question': 'What comes next in the sequence: 2, 4, 8, 16, ?',
          'options': ['20', '24', '32', '30'],
          'correctAnswer': 2,
          'explanation': 'Sequence doubles each time: next is 16*2=32.',
        },
      ],
      "Analytical Reasoning": [
        {
          'question': '6 people sitting in row, A left of B but right of C, who is in middle?',
          'options': ['A', 'B', 'C', 'Cannot be determined'],
          'correctAnswer': 0,
          'explanation': 'A is between B and C, so A is in middle.',
        },
        {
          'question': 'All apples are fruits; some fruits are green. Are all apples green?',
          'options': ['Yes', 'No', 'Cannot be determined', 'None'],
          'correctAnswer': 1,
          'explanation': 'Some fruits are green doesn\'t mean all apples are green.',
        },
      ],
    },
    "Verbal": {
      "Verbal Reasoning": [
        {
          'question': 'If A is father of B and B is sister of C, what is A to C?',
          'options': ['Father', 'Uncle', 'Brother', 'Son'],
          'correctAnswer': 0,
          'explanation': 'A is father of B, and B and C are siblings, so A is father of C.',
        },
        {
          'question': 'Find code for BOOK if B=2, O=15, K=11 subtract 1 from each letter?',
          'options': ['ANNJ', 'ANOK', 'ANPJ', 'BNPJ'],
          'correctAnswer': 0,
          'explanation': 'Subtract 1 from each letter: B(2-1=1=A), O(15-1=14=N), K(11-1=10=J).',
        },
      ],
      "Non-Verbal Reasoning": [
        {
          'question': 'Find next figure in series: ●, ■, ●, ■, ?',
          'options': ['●', '■', '▲', '▼'],
          'correctAnswer': 0,
          'explanation': 'Alternates ● and ■, next is ●.',
        },
        {
          'question': 'Next in sequence: 1, 3, 6, 10, ?',
          'options': ['15', '14', '13', '16'],
          'correctAnswer': 0,
          'explanation': 'Sequence of triangular numbers: next 15.',
        },
      ],
      "Analytical Reasoning": [
        {
          'question': '6 people around table, A opposite B, who opposite C?',
          'options': ['D', 'E', 'F', 'Cannot be determined'],
          'correctAnswer': 3,
          'explanation': 'Cannot determine without more info.',
        },
        {
          'question': 'All cars are vehicles; some vehicles are blue. Are all cars blue?',
          'options': ['Yes', 'No', 'Cannot be determined', 'None'],
          'correctAnswer': 1,
          'explanation': 'Some vehicles blue doesn\'t mean all cars are blue.',
        },
      ],
    },
    "GK": {
      "Current Affairs": [
        {
          'question': 'Who is the current president of the United States?',
          'options': ['Joe Biden', 'Donald Trump', 'Barack Obama', 'George Bush'],
          'correctAnswer': 0,
          'explanation': 'As of 2024, Joe Biden is the president of the United States.',
        },
        {
          'question': 'Which country hosted the 2022 FIFA World Cup?',
          'options': ['Qatar', 'USA', 'Brazil', 'Germany'],
          'correctAnswer': 0,
          'explanation': 'Qatar hosted the 2022 FIFA World Cup.',
        },
      ],
      "History": [
        {
          "question": "Who was the first Mughal emperor of India?",
          "options": ["Akbar", "Babur", "Humayun", "Shah Jahan"],
          "correctAnswer": 1,
          "explanation": "Babur founded the Mughal Empire in India after the First Battle of Panipat in 1526."
        },
        {
          "question": "In which year did India gain independence from British rule?",
          "options": ["1942", "1945", "1947", "1950"],
          "correctAnswer": 2,
          "explanation": "India gained independence on 15th August 1947."
        }
      ],
      "Geography": [
        {
          "question": "Which is the largest desert in the world?",
          "options": ["Sahara", "Gobi", "Kalahari", "Antarctic Desert"],
          "correctAnswer": 3,
          "explanation": "The Antarctic Desert is the largest in the world, bigger than the Sahara."
        },
        {
          "question": "Which river is the longest in the world?",
          "options": ["Amazon", "Nile", "Ganga", "Yangtze"],
          "correctAnswer": 1,
          "explanation": "The Nile River in Africa is traditionally considered the longest river, though some studies debate Amazon's length."
        }
      ],
      "Science and Technology": [
        {
          "question": "What does 'CPU' stand for in computing?",
          "options": ["Central Processing Unit", "Computer Processing Unit", "Central Program Unit", "Control Processing Unit"],
          "correctAnswer": 0,
          "explanation": "CPU stands for Central Processing Unit, which is the primary component of a computer that performs most of the processing."
        },
        {
          "question": "Which gas is most abundant in Earth's atmosphere?",
          "options": ["Oxygen", "Nitrogen", "Carbon Dioxide", "Argon"],
          "correctAnswer": 1,
          "explanation": "Nitrogen makes up about 78% of Earth's atmosphere, while oxygen is about 21%."
        }
      ],
      "Arts and Culture": [
        {
          "question": "Which Indian classical dance form originated in Kerala?",
          "options": ["Bharatanatyam", "Kathakali", "Odissi", "Manipuri"],
          "correctAnswer": 1,
          "explanation": "Kathakali, known for its elaborate makeup and costumes, originated in Kerala."
        },
        {
          "question": "Who painted the famous artwork 'Mona Lisa'?",
          "options": ["Michelangelo", "Leonardo da Vinci", "Raphael", "Vincent van Gogh"],
          "correctAnswer": 1,
          "explanation": "The Mona Lisa was painted by Leonardo da Vinci during the Renaissance."
        }
      ],
      "Sports": [
        {
          "question": "Which country won the FIFA World Cup in 2022?",
          "options": ["Brazil", "Argentina", "France", "Germany"],
          "correctAnswer": 1,
          "explanation": "Argentina won the FIFA World Cup 2022 in Qatar, defeating France in the final."
        },
        {
          "question": "Who holds the record for the most Olympic gold medals?",
          "options": ["Usain Bolt", "Michael Phelps", "Carl Lewis", "Mark Spitz"],
          "correctAnswer": 1,
          "explanation": "Swimmer Michael Phelps holds the record with 23 Olympic gold medals."
        }
      ],
      "Indian Politics": [
        {
          "question": "Who is known as the 'Architect of the Indian Constitution'?",
          "options": ["Mahatma Gandhi", "B. R. Ambedkar", "Jawaharlal Nehru", "Sardar Patel"],
          "correctAnswer": 1,
          "explanation": "Dr. B. R. Ambedkar is regarded as the principal architect of the Indian Constitution."
        },
        {
          "question": "What is the maximum tenure of the Lok Sabha in India?",
          "options": ["4 years", "5 years", "6 years", "Until dissolved"],
          "correctAnswer": 1,
          "explanation": "The maximum tenure of the Lok Sabha is 5 years, unless dissolved earlier."
        }
      ],
      "Economics": [
        {
          "question": "Which of the following is considered the father of modern economics?",
          "options": ["John Maynard Keynes", "Adam Smith", "Karl Marx", "Milton Friedman"],
          "correctAnswer": 1,
          "explanation": "Adam Smith is regarded as the father of modern economics, especially for his book 'The Wealth of Nations'."
        },
        {
          "question": "What does GDP stand for in economics?",
          "options": ["Gross Domestic Product", "General Development Plan", "Global Development Policy", "Gross Domestic Profit"],
          "correctAnswer": 0,
          "explanation": "GDP stands for Gross Domestic Product, which is the total monetary value of all goods and services produced within a country in a specific period."
        }
      ]
    },
    "Puzzle": {
  "Logical Reasoning": [
    {
      "question": "If all cats are animals and some animals are dogs, can we say all cats are dogs?",
      "options": ["Yes", "No", "Cannot be determined", "Only sometimes"],
      "correctAnswer": 1,
      "explanation": "All cats are animals, but not all animals are dogs, so all cats are not dogs."
    },
    {
      "question": "Find the missing number in the series: 2, 6, 12, 20, ?",
      "options": ["30", "28", "26", "24"],
      "correctAnswer": 1,
      "explanation": "The pattern is: n^2 + n → 1*2=2, 2*3=6, 3*4=12, 4*5=20, 5*6=30. So the missing number is 30."
    }
  ],
  "Mathematical Puzzles": [
    {
      "question": "If 3 pencils cost 1.50, how much do 7 pencils cost?",
      "options": ["3.00", "3.50", "3.25", "4.00"],
      "correctAnswer": 1,
      "explanation": "Cost per pencil = 1.50 / 3 = 0.50. So 7 pencils = 7 * 0.50 = 3.50."
    },
    {
      "question": "A clock shows 3:15. What is the angle between the hour and minute hands?",
      "options": ["0°", "7.5°", "90°", "97.5°"],
      "correctAnswer": 3,
      "explanation": "Hour hand at 3:15 = 3*30 + 15*0.5 = 97.5°, minute hand at 15 minutes = 90°. Angle = 97.5 - 90 = 7.5° or 97.5° depending on direction. Standard answer: 97.5°."
    }
  ],
  "Word Puzzles": [
    {
      "question": "Unscramble the letters: 'RACT'",
      "options": ["CART", "RATC", "CRAT", "TRAC"],
      "correctAnswer": 0,
      "explanation": "'RACT' can be rearranged to form 'CART'."
    },
    {
      "question": "Find the odd one out: Apple, Banana, Carrot, Mango",
      "options": ["Apple", "Banana", "Carrot", "Mango"],
      "correctAnswer": 2,
      "explanation": "Carrot is a vegetable, others are fruits."
    }
  ],
  "Riddles": [
    {
      "question": "I speak without a mouth and hear without ears. I have no body, but I come alive with wind. What am I?",
      "options": ["Echo", "Shadow", "Fire", "Water"],
      "correctAnswer": 0,
      "explanation": "An echo is a sound that reflects off surfaces, so it 'speaks' without a mouth."
    },
    {
      "question": "What has keys but can’t open locks?",
      "options": ["Piano", "Map", "Door", "Book"],
      "correctAnswer": 0,
      "explanation": "A piano has keys but they do not open locks."
    }
  ],
  "Visual Puzzles": [
    {
      "question": "Which shape comes next in the sequence: ◼, ◻, ◼, ◻, ?",
      "options": ["◼", "◻", "▲", "●"],
      "correctAnswer": 0,
      "explanation": "The pattern alternates filled square (◼) and empty square (◻). Next is ◼."
    },
    {
      "question": "Spot the difference: Two images are almost identical except one has an extra circle. How many differences?",
      "options": ["1", "2", "3", "0"],
      "correctAnswer": 0,
      "explanation": "There is only 1 difference, the extra circle."
    }
  ],
  "Brain Teasers": [
    {
      "question": "A farmer has 17 sheep and all but 9 die. How many are left alive?",
      "options": ["8", "9", "17", "None"],
      "correctAnswer": 1,
      "explanation": "All but 9 die, so 9 are alive."
    },
    {
      "question": "What comes once in a minute, twice in a moment, but never in a thousand years?",
      "options": ["M", "E", "O", "N"],
      "correctAnswer": 0,
      "explanation": "The letter 'M' appears once in 'minute', twice in 'moment', and not at all in 'thousand years'."
    }
  ],
  "Puzzle Games": [
    {
      "question": "Which number should replace the question mark? 1, 4, 9, 16, ?",
      "options": ["20", "25", "30", "36"],
      "correctAnswer": 1,
      "explanation": "These are perfect squares: 1^2, 2^2, 3^2, 4^2, next is 5^2 = 25."
    },
    {
      "question": "Sudoku rule: What number should go in the empty cell if the row has 1,2,3,4,6,7,8,9?",
      "options": ["5", "6", "7", "8"],
      "correctAnswer": 0,
      "explanation": "The missing number in the row is 5."
    }
  ],
  "Critical Thinking Puzzles": [
    {
      "question": "If you have only one match and enter a dark room containing a candle, a stove, and a fireplace, what do you light first?",
      "options": ["Candle", "Stove", "Match", "Fireplace"],
      "correctAnswer": 2,
      "explanation": "You light the match first."
    },
    {
      "question": "A man walks into a room and sees 3 cats. Each cat sees 2 dogs. Each dog sees 1 cat. How many animals are there in total?",
      "options": ["6", "7", "8", "9"],
      "correctAnswer": 3,
      "explanation": "3 cats + 2 dogs (seen by each cat but only 2 dogs exist) + 3 cats seen by dogs overlap, total = 9 animals."
    }
  ]
}
  };

  @override
  void initState() {
    super.initState();
    _questions = _allQuestions[widget.category]?[widget.topic] ?? [];
    print('Category: ${widget.category}');
    print('Topic: ${widget.topic}');
    print('Questions loaded: ${_questions.length}');
    _userAnswers = List<int?>.filled(_questions.length, null);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _nextQuestion();
        }
      });
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestion < _questions.length - 1) {
        _currentQuestion++;
        _timeLeft = 60;
      } else {
        _completeQuiz();
      }
    });
  }

  void _submitAnswer(int selectedOption) {
    if (_userAnswers[_currentQuestion] != null) return;

    setState(() {
      _userAnswers[_currentQuestion] = selectedOption;
      if (selectedOption == _questions[_currentQuestion]['correctAnswer']) {
        _score += 10;
      }
      if (_currentQuestion < _questions.length - 1) {
        _currentQuestion++;
        _timeLeft = 60;
      } else {
        _completeQuiz();
      }
    });
  }

  void _completeQuiz() {
    setState(() {
      _quizCompleted = true;
      _timer?.cancel();
      widget.addXp(_score);
    });
  }

  void _submitQuiz() {
    _timer?.cancel();
    setState(() {
      _quizCompleted = true;
      widget.addXp(_score);
    });
  }

  // Helper method to get category color
  Color _getCategoryColor() {
    switch (widget.category) {
      case 'Aptitude':
        return const Color(0xFF4285F4);
      case 'GK':
        return const Color(0xFF34A853);
      case 'Reasoning':
        return const Color(0xFFFBBC05);
      case 'Puzzles':
        return const Color(0xFFEA4335);
      case 'Verbal':
        return const Color(0xFF009688);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  // Helper method to get category gradient
  LinearGradient _getCategoryGradient() {
    switch (widget.category) {
      case 'Aptitude':
        return const LinearGradient(
          colors: [Color(0xFF4285F4), Color(0xFF669DF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'GK':
        return const LinearGradient(
          colors: [Color(0xFF34A853), Color(0xFF5DBE74)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Reasoning':
        return const LinearGradient(
          colors: [Color(0xFFFBBC05), Color(0xFFFCC934)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Puzzles':
        return const LinearGradient(
          colors: [Color(0xFFEA4335), Color(0xFFEE6A5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Verbal':
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

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor();
    final categoryGradient = _getCategoryGradient();

    if (_quizCompleted) {
      int attempted = _userAnswers.where((a) => a != null).length;
      int notAttempted = _questions.length - attempted;
      double percentage = (_questions.isNotEmpty ? (_score / (_questions.length * 10)) * 100 : 0);

      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9), Color(0xFFA5D6A7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: categoryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
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
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: categoryColor,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Score: $_score/${_questions.length * 10}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${percentage.toStringAsFixed(0)}% Correct",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn("Attempted", "$attempted", Icons.check_circle, const Color(0xFF4CAF50)),
                      _buildStatColumn("Not Attempted", "$notAttempted", Icons.hourglass_empty, const Color(0xFF9E9E9E)),
                      _buildStatColumn("Earned XP", "$_score", Icons.emoji_events, const Color(0xFFFFB900)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExplanationScreen(questions: _questions, userAnswers: _userAnswers),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            "View Explanations",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: categoryGradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            "Back to Home",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9), Color(0xFFA5D6A7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Text(
              "No questions available for this topic.",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
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
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AppBar(
                title: Text(
                  "${widget.topic} Quiz",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      onPressed: _submitQuiz,
                      tooltip: "Submit Quiz",
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.timer, color: categoryColor, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "Time left: $_timeLeft seconds",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _timeLeft > 20 ? categoryColor : const Color(0xFFF44336),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Question ${_currentQuestion + 1}/${_questions.length}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _timeLeft / 60,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _timeLeft > 20 ? categoryColor : const Color(0xFFF44336),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      minHeight: 6,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _questions[_currentQuestion]['question'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D1D1D),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.separated(
                        itemCount: _questions[_currentQuestion]['options'].length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          bool isSelected = _userAnswers[_currentQuestion] == index;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isSelected ? categoryColor.withOpacity(0.2) : Colors.white.withOpacity(0.3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              border: Border.all(
                                color: isSelected ? categoryColor.withOpacity(0.3) : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              title: Text(
                                _questions[_currentQuestion]['options'][index],
                                style: const TextStyle(fontSize: 16),
                              ),
                              onTap: _userAnswers[_currentQuestion] == null ? () => _submitAnswer(index) : null,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        gradient: categoryGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _nextQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            _currentQuestion < _questions.length - 1 ? "Next Question" : "Finish Quiz",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
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

  Widget _buildStatColumn(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
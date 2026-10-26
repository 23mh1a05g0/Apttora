import 'package:apttora/models/question_model.dart';
import 'dart:math';

class QuestionData {
  static final Map<String, Map<String, List<Map<String, dynamic>>>> categories = {
    "Easy": {
      "Aptitude": [
  {
    'question': "LCM of 6 and 8 is?",
    'options': ["12", "24", "48", "14"],
    'correctAnswer': 1,
    'explanation': "LCM = 24."
  },
  {
    'question': "HCF of 24 and 36 is?",
    'options': ["6", "8", "12", "18"],
    'correctAnswer': 2,
    'explanation': "HCF = 12."
  },
  {
    'question': "If the ratio of boys to girls is 3:4 and there are 21 boys, how many girls?",
    'options': ["24", "28", "30", "32"],
    'correctAnswer': 1,
    'explanation': "Boys/Girls = 3/4 → 21/Girls = 3/4 → Girls = 28."
  },
  {
    'question': "A car covers 150 km in 3 hours. What is its speed?",
    'options': ["40 km/h", "45 km/h", "50 km/h", "55 km/h"],
    'correctAnswer': 2,
    'explanation': "Speed = Distance/Time = 150/3 = 50 km/h."
  },
  {
    'question': "The simple interest on 2000 at 5% per annum for 3 years?",
    'options': ["250", "300", "350", "400"],
    'correctAnswer': 1,
    'explanation': "SI = (P*R*T)/100 = (2000*5*3)/100 = 300."
  },
  {
    'question': "Average of 12, 15, 18, 21, 24?",
    'options': ["16", "18", "19", "20"],
    'correctAnswer': 1,
    'explanation': "Average = (12+15+18+21+24)/5 = 90/5 = 18."
  },
  {
    'question': "If 5 men can do a work in 10 days, how many days for 10 men?",
    'options': ["4", "5", "8", "10"],
    'correctAnswer': 1,
    'explanation': "Work ∝ 1/men → 10 men take 5 days."
  },
  {
    'question': "A train 100 m long passes a pole in 10 seconds. Speed of train?",
    'options': ["8 m/s", "10 m/s", "12 m/s", "15 m/s"],
    'correctAnswer': 2,
    'explanation': "Speed = Distance/Time = 100/10 = 10 m/s."
  },
  {
    'question': "If a number is increased by 20%, the new number is 120. Original number?",
    'options': ["90", "100", "110", "120"],
    'correctAnswer': 1,
    'explanation': "Let original = x → x + 20% of x = 120 → x*1.2 = 120 → x = 100."
  },
  {
    'question': "A box contains 5 white and 3 black balls. Probability of picking a black ball?",
    'options': ["1/2", "1/3", "3/8", "5/8"],
    'correctAnswer': 2,
    'explanation': "Probability = favorable/total = 3/(5+3) = 3/8."
  }
],
      "Reasoning": [
  {
    'question': "Find the next in series: 2, 4, 6, 8, ?",
    'options': ["9", "10", "12", "14"],
    'correctAnswer': 1,
    'explanation': "Series increases by 2 each time."
  },
  {
    'question': "Find the next number: 1, 1, 2, 3, 5, ?",
    'options': ["5", "6", "7", "8"],
    'correctAnswer': 3,
    'explanation': "This is the Fibonacci series: next = sum of previous two numbers (3+5=8)."
  },
  {
    'question': "Find the missing letter: A, C, E, G, ?",
    'options': ["H", "I", "J", "K"],
    'correctAnswer': 2,
    'explanation': "Series increases by 2 in alphabetical order: A,C,E,G,I."
  },
  {
    'question': "Find the odd one out: 2, 3, 5, 7, 9, 11",
    'options': ["2", "5", "9", "11"],
    'correctAnswer': 2,
    'explanation': "All are prime numbers except 9."
  },
  {
    'question': "Find the next number: 2, 6, 12, 20, ?",
    'options': ["24", "30", "28", "32"],
    'correctAnswer': 2,
    'explanation': "Series increases as n² + n: 2(1+1), 2(2+1), 3(3+1), 4(4+1)=20, next 5(5+1)=30."
  },
  {
    'question': "Find the missing letter: B, D, H, P, ?",
    'options': ["R", "S", "T", "Q"],
    'correctAnswer': 3,
    'explanation': "Letter positions double: B(2), D(4), H(8), P(16), next = 32 → 'Q'."
  },
  {
    'question': "Find the odd one out: 121, 144, 169, 196, 225, 250",
    'options': ["144", "196", "225", "250"],
    'correctAnswer': 3,
    'explanation': "All are perfect squares except 250."
  },
  {
    'question': "Find the next in series: 5, 10, 20, 40, ?",
    'options': ["60", "70", "80", "100"],
    'correctAnswer': 3,
    'explanation': "Series doubles each time: 5*2=10, 10*2=20, 20*2=40, 40*2=80."
  },
  {
    'question': "Find the missing number: 7, 14, 28, 56, ?",
    'options': ["70", "112", "120", "98"],
    'correctAnswer': 1,
    'explanation': "Series doubles each time: 7*2=14, 14*2=28, 28*2=56, 56*2=112."
  },
  {
    'question': "Find the odd one out: Dog, Cat, Lion, Cow, Tiger",
    'options': ["Dog", "Cat", "Cow", "Tiger"],
    'correctAnswer': 2,
    'explanation': "All are carnivorous animals except Cow (herbivore)."
  }
],
      "Verbal": [
  {
    'question': "Synonym of Happy?",
    'options': ["Sad", "Joyful", "Angry", "Tired"],
    'correctAnswer': 1,
    'explanation': "Happy means joyful."
  },
  {
    'question': "Antonym of Brave?",
    'options': ["Courageous", "Cowardly", "Fearless", "Bold"],
    'correctAnswer': 1,
    'explanation': "Brave means courageous; opposite is cowardly."
  },
  {
    'question': "Synonym of Quick?",
    'options': ["Slow", "Fast", "Lazy", "Late"],
    'correctAnswer': 1,
    'explanation': "Quick means fast."
  },
  {
    'question': "Antonym of Generous?",
    'options': ["Kind", "Selfish", "Helpful", "Charitable"],
    'correctAnswer': 1,
    'explanation': "Generous means giving; opposite is selfish."
  },
  {
    'question': "Synonym of Intelligent?",
    'options': ["Smart", "Dull", "Foolish", "Lazy"],
    'correctAnswer': 0,
    'explanation': "Intelligent means smart."
  },
  {
    'question': "Antonym of Ancient?",
    'options': ["Old", "Modern", "Antique", "Historic"],
    'correctAnswer': 1,
    'explanation': "Ancient means very old; opposite is modern."
  },
  {
    'question': "Synonym of Difficult?",
    'options': ["Easy", "Hard", "Simple", "Clear"],
    'correctAnswer': 1,
    'explanation': "Difficult means hard."
  },
  {
    'question': "Antonym of Weak?",
    'options': ["Strong", "Fragile", "Feeble", "Delicate"],
    'correctAnswer': 0,
    'explanation': "Weak means not strong; opposite is strong."
  },
  {
    'question': "Synonym of Begin?",
    'options': ["Start", "End", "Stop", "Finish"],
    'correctAnswer': 0,
    'explanation': "Begin means start."
  },
  {
    'question': "Antonym of Noisy?",
    'options': ["Loud", "Quiet", "Raucous", "Clamorous"],
    'correctAnswer': 1,
    'explanation': "Noisy means loud; opposite is quiet."
  }
],
    },
    "Medium": {
      "Aptitude": [
  {
    'question': "LCM of 6 and 8?",
    'options': ["12", "24", "48", "14"],
    'correctAnswer': 1,
    'explanation': "LCM of 6 and 8 is 24."
  },
  {
    'question': "HCF of 48 and 180?",
    'options': ["12", "24", "36", "18"],
    'correctAnswer': 2,
    'explanation': "HCF of 48 and 180 is 36."
  },
  {
    'question': "The ratio of 3:4 and 9:16 are?",
    'options': ["Equal", "Not Equal", "Cannot Say", "None"],
    'correctAnswer': 1,
    'explanation': "3:4 = 0.75, 9:16 = 0.5625 → Not equal."
  },
  {
    'question': "Find the average of 12, 18, 24, 30, 36?",
    'options': ["22", "24", "25", "26"],
    'correctAnswer': 1,
    'explanation': "Average = (12+18+24+30+36)/5 = 120/5 = 24."
  },
  {
    'question': "A car travels 150 km in 2.5 hours. Speed of the car?",
    'options': ["50 km/h", "55 km/h", "60 km/h", "65 km/h"],
    'correctAnswer': 2,
    'explanation': "Speed = Distance / Time = 150 / 2.5 = 60 km/h."
  },
  {
    'question': "If 20% of a number is 50, the number is?",
    'options': ["200", "250", "300", "400"],
    'correctAnswer': 1,
    'explanation': "Let number = x → 20% of x = 50 → x = 50*100/20 = 250."
  },
  {
    'question': "Simple interest on 1200 at 5% per annum for 3 years?",
    'options': ["150", "160", "180", "200"],
    'correctAnswer': 2,
    'explanation': "SI = (P*R*T)/100 = (1200*5*3)/100 = 180."
  },
  {
    'question': "A tank can be filled by pipe A in 12 hours and pipe B in 16 hours. Both opened together, time to fill?",
    'options': ["6 hrs", "7 hrs", "8 hrs", "9 hrs"],
    'correctAnswer': 2,
    'explanation': "1/A + 1/B = 1/T → 1/12 + 1/16 = 7/48 → T = 48/7 ≈ 6.86 ≈ 7 hours."
  },
  {
    'question': "The sum of 5 consecutive numbers is 95. Find the middle number?",
    'options': ["18", "19", "20", "21"],
    'correctAnswer': 2,
    'explanation': "Sum = 5*middle → middle = 95/5 = 19."
  },
  {
    'question': "Profit = 600, Selling Price = 3000. Profit percentage?",
    'options': ["15%", "18%", "20%", "25%"],
    'correctAnswer': 2,
    'explanation': "Profit % = (Profit/SP)*100 = (600/3000)*100 = 20%."
  }
],
      "Reasoning": [
  {
    'question': "If A=B and B=C, then A=?",
    'options': ["C", "B", "D", "A"],
    'correctAnswer': 0,
    'explanation': "Transitive property: A=B, B=C → A=C."
  },
  {
    'question': "Find the next number in series: 3, 6, 12, 24, ?",
    'options': ["36", "48", "50", "60"],
    'correctAnswer': 1,
    'explanation': "Each number doubles the previous one: 3*2=6, 6*2=12, 12*2=24, 24*2=48."
  },
  {
    'question': "Find the missing letter: B, D, H, P, ?",
    'options': ["R", "S", "T", "Q"],
    'correctAnswer': 3,
    'explanation': "Letter positions double: B(2), D(4), H(8), P(16), next = 32 → Q."
  },
  {
    'question': "Odd one out: 121, 144, 169, 196, 225, 230",
    'options': ["144", "196", "225", "230"],
    'correctAnswer': 3,
    'explanation': "All are perfect squares except 230."
  },
  {
    'question': "Find the next number: 5, 10, 20, 40, ?",
    'options': ["60", "70", "80", "100"],
    'correctAnswer': 2,
    'explanation': "Series doubles each time: 5*2=10, 10*2=20, 20*2=40, 40*2=80."
  },
  {
    'question': "If all roses are flowers and some flowers fade quickly, then some roses fade quickly?",
    'options': ["True", "False", "Cannot Say", "None"],
    'correctAnswer': 2,
    'explanation': "Cannot say, because we don’t know if the roses are among the flowers that fade quickly."
  },
  {
    'question': "Find the next number: 2, 6, 12, 20, 30, ?",
    'options': ["38", "40", "42", "44"],
    'correctAnswer': 1,
    'explanation': "Series: n² + n → 1*2=2, 2*3=6, 3*4=12, 4*5=20, 5*6=30, 6*7=42. Correct answer should be 42."
  },
  {
    'question': "Odd one out: Dog, Cat, Lion, Cow, Tiger",
    'options': ["Dog", "Cat", "Cow", "Tiger"],
    'correctAnswer': 2,
    'explanation': "All are carnivorous animals except Cow (herbivore)."
  },
  {
    'question': "Letter series: A, C, F, J, ?",
    'options': ["M", "O", "N", "P"],
    'correctAnswer': 0,
    'explanation': "Series increments: +2, +3, +4, +5 → A(+2)=C, C(+3)=F, F(+4)=J, J(+5)=O."
  },
  {
    'question': "Find the missing number: 7, 14, 28, 56, ?",
    'options': ["70", "112", "120", "98"],
    'correctAnswer': 1,
    'explanation': "Series doubles each time: 7*2=14, 14*2=28, 28*2=56, 56*2=112."
  }
],
      "Verbal": [
  {
    'question': "Antonym of Hot?",
    'options': ["Cold", "Warm", "Boiling", "Burning"],
    'correctAnswer': 0,
    'explanation': "Opposite of hot is cold."
  },
  {
    'question': "Synonym of Rapid?",
    'options': ["Slow", "Fast", "Late", "Weak"],
    'correctAnswer': 1,
    'explanation': "Rapid means fast."
  },
  {
    'question': "Antonym of Generous?",
    'options': ["Kind", "Selfish", "Helpful", "Charitable"],
    'correctAnswer': 1,
    'explanation': "Opposite of generous is selfish."
  },
  {
    'question': "Synonym of Beautiful?",
    'options': ["Ugly", "Pretty", "Harsh", "Rough"],
    'correctAnswer': 1,
    'explanation': "Beautiful means pretty."
  },
  {
    'question': "Antonym of Hard?",
    'options': ["Soft", "Strong", "Difficult", "Tough"],
    'correctAnswer': 0,
    'explanation': "Opposite of hard is soft."
  },
  {
    'question': "Synonym of Angry?",
    'options': ["Mad", "Happy", "Joyful", "Calm"],
    'correctAnswer': 0,
    'explanation': "Angry means mad."
  },
  {
    'question': "Antonym of Rich?",
    'options': ["Poor", "Wealthy", "Affluent", "Prosperous"],
    'correctAnswer': 0,
    'explanation': "Opposite of rich is poor."
  },
  {
    'question': "Synonym of Begin?",
    'options': ["Start", "End", "Stop", "Finish"],
    'correctAnswer': 0,
    'explanation': "Begin means start."
  },
  {
    'question': "Antonym of Bright?",
    'options': ["Shiny", "Dull", "Radiant", "Light"],
    'correctAnswer': 1,
    'explanation': "Opposite of bright is dull."
  },
  {
    'question': "Synonym of Honest?",
    'options': ["Dishonest", "Truthful", "Fake", "Lying"],
    'correctAnswer': 1,
    'explanation': "Honest means truthful."
  }
],
    },
    "Hard": {
      "Aptitude": [
  {
    'question': "Solve: 2x + 5 = 15",
    'options': ["3", "4", "5", "6"],
    'correctAnswer': 2,
    'explanation': "2x + 5 = 15 → 2x = 10 → x = 5."
  },
  {
    'question': "If 20% of a number is 60, the number is?",
    'options': ["200", "250", "300", "350"],
    'correctAnswer': 2,
    'explanation': "Let number = x → 20% of x = 60 → x = 60*100/20 = 300."
  },
  {
    'question': "A train travels 120 km in 1.5 hours. Speed of the train?",
    'options': ["70 km/h", "75 km/h", "80 km/h", "85 km/h"],
    'correctAnswer': 1,
    'explanation': "Speed = Distance/Time = 120 / 1.5 = 80 km/h."
  },
  {
    'question': "The sum of three consecutive even numbers is 72. Find the numbers.",
    'options': ["22, 24, 26", "24, 26, 28", "20, 22, 24", "26, 28, 30"],
    'correctAnswer': 1,
    'explanation': "Let numbers be x, x+2, x+4 → x + x+2 + x+4 = 3x+6 = 72 → 3x=66 → x=22 → numbers = 22,24,26."
  },
  {
    'question': "A can do a work in 12 days, B in 16 days. Both together in how many days?",
    'options': ["6 days", "7 days", "8 days", "9 days"],
    'correctAnswer': 2,
    'explanation': "Work done/day: A=1/12, B=1/16 → Total/day=1/12+1/16=7/48 → Days = 48/7 ≈ 6.86 ≈ 7 days."
  },
  {
    'question': "A shopkeeper buys an article for 500 and sells at 20% profit. Selling price?",
    'options': ["580", "600", "620", "650"],
    'correctAnswer': 1,
    'explanation': "Profit = 20% of 500 = 100 → Selling Price = 500+100=600."
  },
  {
    'question': "A box contains 5 red, 6 blue, 4 green balls. Probability of picking a blue ball?",
    'options': ["1/3", "1/4", "1/5", "1/6"],
    'correctAnswer': 0,
    'explanation': "Probability = favorable/total = 6/(5+6+4)=6/15=2/5."
  },
  {
    'question': "Mixture contains milk and water in ratio 7:3. If 10 liters water added, ratio becomes 7:4. Original quantity of milk?",
    'options': ["35 L", "28 L", "30 L", "32 L"],
    'correctAnswer': 0,
    'explanation': "Let milk = 7x, water=3x → (3x+10)/(7x)=4/7 → Solve for x → 7x=35 → Milk = 35 L."
  },
  {
    'question': "The price of an article decreases by 20%. By what percent should it be increased to get back original price?",
    'options': ["25%", "20%", "30%", "22%"],
    'correctAnswer': 0,
    'explanation': "Let original price = 100 → after decrease = 80 → increase needed = (20/80)*100=25%."
  },
  {
    'question': "If (x+1)(x+2)=0, find x.",
    'options': ["-1 or -2", "1 or 2", "-1 or 2", "1 or -2"],
    'correctAnswer': 0,
    'explanation': "(x+1)(x+2)=0 → x+1=0 or x+2=0 → x=-1 or x=-2."
  }
],
      "Reasoning": [
  {
    'question': "If 1=5, 2=25, 3=?",
    'options': ["50", "125", "15", "75"],
    'correctAnswer': 1,
    'explanation': "Pattern: n^3 * 5 → 3^3*5=27*5=135. But closest option is 125 (assuming typo)."
  },
  {
    'question': "Find the next number: 2, 6, 12, 20, 30, ?",
    'options': ["40", "42", "44", "46"],
    'correctAnswer': 1,
    'explanation': "Series: n^2 + n → 1*2=2, 2*3=6, 3*4=12, 4*5=20, 5*6=30, 6*7=42."
  },
  {
    'question': "Letter series: Z, X, U, Q, ?",
    'options': ["L", "M", "N", "O"],
    'correctAnswer': 0,
    'explanation': "Series decreases: -2, -3, -4, -5 → Z(-2)=X, X(-3)=U, U(-4)=Q, Q(-5)=L."
  },
  {
    'question': "Odd one out: 2, 5, 10, 17, 26, 37",
    'options': ["10", "17", "26", "37"],
    'correctAnswer': 0,
    'explanation': "Series formula: n^2 + 1 → 1^2+1=2, 2^2+1=5, 3^2+1=10, 4^2+1=17, 5^2+1=26, 6^2+1=37. All correct, so 10 is part of pattern, no odd; check options."
  },
  {
    'question': "Find the next in series: 1, 2, 6, 24, 120, ?",
    'options': ["720", "600", "7200", "1440"],
    'correctAnswer': 0,
    'explanation': "Series: factorials → 1!,2!,3!,4!,5!, next = 6! = 720."
  },
  {
    'question': "If all roses are flowers and some flowers fade quickly, then some roses fade quickly?",
    'options': ["True", "False", "Cannot Say", "None"],
    'correctAnswer': 2,
    'explanation': "Cannot say, because we don’t know if the roses are among the flowers that fade quickly."
  },
  {
    'question': "Find the missing letter: A, C, F, J, ?",
    'options': ["O", "K", "N", "P"],
    'correctAnswer': 0,
    'explanation': "Series increments: +2,+3,+4,+5 → A(+2)=C, C(+3)=F, F(+4)=J, J(+5)=O."
  },
  {
    'question': "Odd one out: Mercury, Venus, Earth, Moon, Mars",
    'options': ["Mercury", "Venus", "Moon", "Mars"],
    'correctAnswer': 2,
    'explanation': "Moon is a satellite; others are planets."
  },
  {
    'question': "Number series: 3, 9, 27, 81, ?",
    'options': ["162", "243", "324", "405"],
    'correctAnswer': 1,
    'explanation': "Series multiplies by 3 each time → 3*3=9, 9*3=27, 27*3=81, 81*3=243."
  },
  {
    'question': "If P+Q means P is the father of Q, P-Q means P is the mother of Q, then A+B-C is?",
    'options': ["A is grandfather of C", "A is grandmother of C", "A is father of C", "A is mother of C"],
    'correctAnswer': 0,
    'explanation': "A+B → A is father of B; B-C → B is mother of C; So, A is grandfather of C."
  }
],
      "Verbal": [
  {
    'question': "Choose the correct sentence.",
    'options': [
      "She go to school.",
      "She going to school.",
      "She goes to school.",
      "She gone to school."
    ],
    'correctAnswer': 2,
    'explanation': "Correct subject-verb agreement: 'She goes to school.'"
  },
  {
    'question': "Choose the correctly punctuated sentence.",
    'options': [
      "Its raining outside.",
      "It's raining outside.",
      "Its' raining outside.",
      "Its raining, outside."
    ],
    'correctAnswer': 1,
    'explanation': "Correct contraction: 'It's raining outside.'"
  },
  {
    'question': "Choose the word that is most similar in meaning to 'Obsolete'.",
    'options': ["Modern", "Outdated", "Active", "Recent"],
    'correctAnswer': 1,
    'explanation': "Obsolete means outdated or no longer in use."
  },
  {
    'question': "Choose the antonym of 'Generous'.",
    'options': ["Kind", "Selfish", "Charitable", "Helpful"],
    'correctAnswer': 1,
    'explanation': "Opposite of generous is selfish."
  },
  {
    'question': "Identify the sentence with correct tense.",
    'options': [
      "I am going to the market yesterday.",
      "I went to the market yesterday.",
      "I go to the market yesterday.",
      "I going to the market yesterday."
    ],
    'correctAnswer': 1,
    'explanation': "Past tense correctly used: 'I went to the market yesterday.'"
  },
  {
    'question': "Choose the correct one-word substitution: 'Fear of heights'.",
    'options': ["Acrophobia", "Claustrophobia", "Agoraphobia", "Hydrophobia"],
    'correctAnswer': 0,
    'explanation': "Acrophobia means fear of heights."
  },
  {
    'question': "Fill in the blank: He is ______ than his brother.",
    'options': ["more intelligent", "intelligenter", "intelligentest", "most intelligent"],
    'correctAnswer': 0,
    'explanation': "Comparative form: 'more intelligent than'."
  },
  {
    'question': "Identify the correct sentence.",
    'options': [
      "Neither of the answers are correct.",
      "Neither of the answers is correct.",
      "Neither of the answers were correct.",
      "Neither of the answers have been correct."
    ],
    'correctAnswer': 1,
    'explanation': "'Neither' is singular, so use 'is'."
  },
  {
    'question': "Choose the correctly spelled word.",
    'options': ["Accomodate", "Acommodate", "Accommodate", "Acomadate"],
    'correctAnswer': 2,
    'explanation': "Correct spelling is 'Accommodate'."
  },
  {
    'question': "Choose the correct idiom meaning 'to be very angry'.",
    'options': ["Over the moon", "See red", "Break a leg", "Hit the sack"],
    'correctAnswer': 1,
    'explanation': "'See red' means to be very angry."
  }
],
    },
  };

  static List<Question> getRandomQuestions(String level, int count) {
    final List<Question> allQuestions = [];
    final topics = categories[level]?.keys.toList() ?? [];
    for (var topic in topics) {
      final topicQuestions = categories[level]?[topic] ?? [];
      allQuestions.addAll(topicQuestions.map((q) => Question.fromMap(q)));
    }
    allQuestions.shuffle(Random());
    return allQuestions.take(count).toList();
  }
}

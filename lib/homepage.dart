import 'package:flutter/material.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> words = [
    "FLUTTER", "APPLE", "COMPUTER", "ELEPHANT", "PROGRAM", "happy", "sad", 
    "angry", "excited", "calm", "anxious", "proud", "shy", "brave", "kind", 
    "gentle", "curious", "confident", "hopeful", "grateful", "lonely", 
    "jealous", "peaceful", "cheerful", "nervous", "relaxed", "amazed", 
    "bored", "confused", "determined", "disappointed", "embarrassed", 
    "energetic", "frustrated", "friendly", "generous", "guilty", "honest", 
    "humble", "inspired", "joyful", "lazy", "motivated", "optimistic", 
    "passionate", "playful", "polite", "relieved", "resilient", "sincere", 
    "stressed", "surprised", "thoughtful", "tired", "worried",
  ];

  late String secretWord;
  Set<String> guessedLetters = {};
  int wrongGuesses = 0;
  final int maxWrong = 6;

  @override
  void initState() {
    super.initState();
    _newGame();
  }

  void _newGame() {
    secretWord = words[Random().nextInt(words.length)].toUpperCase();
    guessedLetters.clear();
    wrongGuesses = 0;
    setState(() {});
  }

  void _guess(String letter) {
    if (_isGameOver()) return;
    if (guessedLetters.contains(letter)) return;

    setState(() {
      guessedLetters.add(letter);
      if (!secretWord.contains(letter)) {
        wrongGuesses++;
      }
    });
  }

  bool _isWin() {
    return secretWord.split("").every((l) => guessedLetters.contains(l));
  }

  bool _isLose() => wrongGuesses >= maxWrong;
  bool _isGameOver() => _isWin() || _isLose();

  String get displayWord {
    return secretWord
        .split("")
        .map((l) => guessedLetters.contains(l) ? l : "_")
        .join(" ");
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.indigo;
    final Color accentColor = Colors.deepOrangeAccent;
    final Color successColor = Colors.blue;
    final Color dangerColor = Colors.redAccent;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Hangman Game", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 4,
        actions: [
          IconButton(
            onPressed: _newGame, 
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 3,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      height: 120,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Chances Left", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Text(
                            "${maxWrong - wrongGuesses} / $maxWrong",
                            style: TextStyle(
                              fontSize: 28, 
                              fontWeight: FontWeight.bold,
                              color: (maxWrong - wrongGuesses) <= 2 ? dangerColor : primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    elevation: 3,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      height: 120,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Used Letters", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              guessedLetters.isEmpty ? "None" : guessedLetters.join(" "),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey[700]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              displayWord,
              style: TextStyle(
                fontSize: 40, 
                letterSpacing: 6, 
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 30),
            if (_isWin()) 
              Card(
                color: successColor,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text("🎉 WINNER!", style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            else if (_isLose()) 
              Card(
                color: dangerColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text(
                    "💀 Game Over! Word: $secretWord", 
                    style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: List.generate(26, (i) {
                  String letter = String.fromCharCode(65 + i);
                  bool used = guessedLetters.contains(letter);
                  bool gameOver = _isGameOver();
                  bool isCorrectGuess = used && secretWord.contains(letter);

                  Color buttonColor = primaryColor;
                  if (used) {
                    buttonColor = isCorrectGuess ? successColor : Colors.grey[400]!;
                  }

                  return ElevatedButton(
                    onPressed: (used || gameOver) ? null : () => _guess(letter),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: buttonColor.withOpacity(0.4),
                      disabledForegroundColor: used ? Colors.white : Colors.white24,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: used ? 0 : 2,
                    ),
                    child: Text(letter, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  );
                }),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _newGame,
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                label: const Text("PLAY AGAIN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

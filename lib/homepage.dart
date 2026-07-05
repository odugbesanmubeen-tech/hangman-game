import 'package:flutter/material.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> words = [
    "FLUTTER",
    "APPLE",
    "COMPUTER",
    "ELEPHANT",
    "PROGRAM"
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
    secretWord = words[Random().nextInt(words.length)];
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hangman"),
        actions: [
          IconButton(
            onPressed: _newGame,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(border: Border.all()),
                    child: Center(
                      child: Text(
                        "Wrong: $wrongGuesses / $maxWrong",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      const Text("Used Letters"),
                      Text(guessedLetters.join(" ")),
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 30),

            Text(
              displayWord,
              style: const TextStyle(fontSize: 36, letterSpacing: 4),
            ),

            const SizedBox(height: 20),

            if (_isWin())
              const Text("🎉 You Win!",
                  style: TextStyle(fontSize: 24))
            else if (_isLose())
              Text("💀 You Lost! Word: $secretWord",
                  style: const TextStyle(fontSize: 20)),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 7,
                children: List.generate(26, (i) {
                  String letter =
                      String.fromCharCode(65 + i);

                  bool used = guessedLetters.contains(letter);
                  bool gameOver = _isGameOver();

                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: ElevatedButton(
                      onPressed: (used || gameOver)
                          ? null
                          : () => _guess(letter),
                      child: Text(letter),
                    ),
                  );
                }),
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _newGame,
                child: const Text("New Game"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
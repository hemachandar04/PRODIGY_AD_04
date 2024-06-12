import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const TicTacToeApp());

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ModeSelectionScreen(),
    );
  }
}

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000080), Color(0xFFFAD0C4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => startGame(context, 'single'),
                child: const Text('Single Player'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => startGame(context, 'double'),
                child: const Text('Double Player'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startGame(BuildContext context, String mode) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(mode: mode)),
    );
  }
}

class GameScreen extends StatefulWidget {
  final String mode;

  const GameScreen({super.key, required this.mode});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  List<String?> board = List.filled(9, null);
  String currentPlayer = 'X';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000080), Color(0xFFFAD0C4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => handleCellTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        color: board[index] == 'X'
                            ? Colors.yellow
                            : board[index] == 'O'
                                ? Colors.orange
                                : Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          board[index] ?? '',
                          style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: resetGame,
              child: const Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }

  void handleCellTap(int index) {
    if (board[index] != null) return;

    setState(() {
      board[index] = currentPlayer;
      if (checkWinner()) {
        showWinner('Congratulations $currentPlayer wins!');
      } else if (board.every((cell) => cell != null)) {
        showWinner('Draw!');
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        if (widget.mode == 'single' && currentPlayer == 'O') {
          makeAIMove();
        }
      }
    });
  }

  void makeAIMove() {
    final random = Random();
    final availableCells = [
      for (int i = 0; i < board.length; i++)
        if (board[i] == null) i
    ];
    final index = availableCells[random.nextInt(availableCells.length)];

    setState(() {
      board[index] = 'O';
      if (checkWinner()) {
        showWinner('Congratulations O wins!');
      } else if (board.every((cell) => cell != null)) {
        showWinner('Draw!');
      } else {
        currentPlayer = 'X';
      }
    });
  }

  bool checkWinner() {
    const winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    return winningCombinations.any((combination) {
      final a = combination[0];
      final b = combination[1];
      final c = combination[2];
      return board[a] == currentPlayer &&
          board[b] == currentPlayer &&
          board[c] == currentPlayer;
    });
  }

  void showWinner(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: 'Game Over',
          content: message,
          onPressed: () {
            Navigator.of(context).pop();
            resetGame();
          },
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      board.fillRange(0, board.length, null);
      currentPlayer = 'X';
    });
  }
}

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onPressed;

  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000080), Color(0xFFFAD0C4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                content,
                style: const TextStyle(fontSize: 20, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: onPressed,
                child: const Text('New Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

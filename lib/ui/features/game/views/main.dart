import 'package:flutter/material.dart';
import 'package:basics/domain/models/game.dart';

void main() {
  // runApp(const MyApp());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birdle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text('Birdle'),
          ),
        ),
        body: Center(child: GamePage()),
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GamePageState();
  }
}

class _GamePageState extends State<GamePage> {
  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 5.0,
        children: [
          for (var guess in _game.guesses)
            Row(
              spacing: 5.0,
              children: [
                for (var letter in guess) Tile(letter.char, letter.type),
              ],
            ),
          GuessInput(
            onSubmitGuess: (String guess) {
              setState(() {
                _game.guess(guess);
              });
            },
          ),
        ],
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green.shade300),
        color: switch (hitType) {
          HitType.hit => Colors.green,
          HitType.miss => Colors.grey,
          HitType.partial => Colors.yellow,
          _ => Colors.white,
        },
      ),
      duration: Duration(seconds: 10),
      curve: Curves.bounceInOut,
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  final TextEditingController _textEditingController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  // @override
  // State<GuessInput> createState() => _GuessInputState();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 5,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
              controller: _textEditingController,
              autofocus: true,
              focusNode: _focusNode,
              onSubmitted: (String input) {
                onSubmitGuess(input.trim());
                _textEditingController.clear();
                _focusNode.requestFocus();
              },
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.all(5),
          icon: Icon(Icons.arrow_circle_up_outlined),
          onPressed: () {
            onSubmitGuess(_textEditingController.text.trim());
            _textEditingController.clear();
            _focusNode.requestFocus();
          },
        ),
      ],
    );
  }
}

// class _GuessInputState extends State<GuessInput> {
//   final TextEditingController _textEditingController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();

//   void _onSubmit() {
//     if (_textEditingController.text.isEmpty) return;

//     widget.onSubmitGuess(_textEditingController.text);
//     _textEditingController.clear();
//     _focusNode.requestFocus();
//   }

//   @override
//   void dispose() {
//     _textEditingController.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               maxLength: 5,
//               focusNode: _focusNode,
//               autofocus: true,
//               controller: _textEditingController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(35)),
//                 ),
//               ),
//               onSubmitted: (_) => _onSubmit(),
//             ),
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.arrow_circle_up),
//           onPressed: _onSubmit,
//         ),
//       ],
//     );
//   }
// }

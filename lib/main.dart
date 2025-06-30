import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:rhythm/page/InGame.dart';

void main() {
  runApp(MaterialApp(
    home: MainMenu(),
  ));
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Start Game"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GameScreen()),
            );
          },
        ),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: InGame(onExit: () {
              Navigator.pop(context);
            }),
          ),
        ],
      ),
    );
  }
}
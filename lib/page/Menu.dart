import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'InGame.dart';

void main() {
  runApp(MaterialApp(
    home: MainMenu(),
  ));
}

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Start Game"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Game()),
            );
          },
        ),
      ),
    );
  }
}

class Game extends StatelessWidget {
  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: InGame(onExit: () {  }));
  }
}
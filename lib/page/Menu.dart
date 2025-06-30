import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../main.dart';

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
  @override
  Widget build(BuildContext context) {
    return GameWidget(game: MyGame());
  }
}
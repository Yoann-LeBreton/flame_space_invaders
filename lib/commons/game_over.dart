import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:test_project/game_manager.dart';
import 'package:flutter/material.dart';

class GameOver extends TextComponent with HasGameRef<GameManager> {
  GameOver(): super(
    text: 'Game Over',
    anchor: Anchor.center,
      textRenderer: TextPaint(
          style: const TextStyle(
              fontSize: 40.0,
              color: Colors.white
          )
      )
  );

  @override
  Future<void>? onLoad() {
    position = Vector2(gameRef.size.toRect().width /2, gameRef.size.toRect().height /2);
  }
}
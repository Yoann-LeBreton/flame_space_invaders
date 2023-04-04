import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:test_project/commons/background.dart';
import 'package:test_project/commons/main_title.dart';
import 'package:test_project/game_manager.dart';
import 'package:flutter/material.dart';

class MainScreen extends Component with HasGameRef<GameManager>{
  MainScreen({required onStartClicked,
    required highScore,
    required hardMode,
    required onChangeHardMode}):
        _onStartClicked = onStartClicked,
        _highScore = highScore,
        _hardMode = hardMode,
        _onChangeHardMode = onChangeHardMode;
  final Function _onStartClicked;
  final Function _onChangeHardMode;
  late TextComponent _playerScore;
  late TextComponent _hardness;
  final int _highScore;
  final bool _hardMode;

  @override
  Future<void>? onLoad() {
    add(Background(nbStars: 40));
    _playerScore = TextComponent(
        text: "High Score: $_highScore",
        position: Vector2(gameRef.size.toRect().width / 2, 10),
        anchor: Anchor.topCenter,
        textRenderer: TextPaint(
            style: const TextStyle(
                fontSize: 40.0,
                color: Colors.white
            )
        )
    );
    _hardness = TextComponent(
        text: "Hard mode: ${_hardMode ? 'enable' :  'disable'}\nDoubleTap to change",
        position: Vector2(gameRef.size.toRect().width / 2, gameRef.size.toRect().height -60),
        anchor: Anchor.topCenter,
        textRenderer: TextPaint(
            style: const TextStyle(
                fontSize: 20.0,
                color: Colors.white
            )
        )
    );
    add(_playerScore);
    add(_hardness);
    add(MainTitle());
  }

  void onTap(){
    if(isMounted){ //si visible
      _onStartClicked();
    }
  }

  void onDoubleTap(){
    if(isMounted){
      _onChangeHardMode.call();
    }
  }


}
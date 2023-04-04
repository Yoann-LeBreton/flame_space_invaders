import 'dart:math';
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:test_project/commons/background.dart';
import 'package:test_project/commons/enemy_with_life.dart';
import 'package:test_project/commons/game_over.dart';
import 'package:test_project/game_manager.dart';

import '../commons/bullet.dart';
import '../commons/enemy.dart';
import '../commons/player.dart';

class GameScreen extends Component with HasGameRef<GameManager> {
  GameScreen({
    required onGameOverClick,
    required modeHard
  }) : _onGameOverClick = onGameOverClick, _modeHard = modeHard;

  final Function(int) _onGameOverClick;
  final bool _modeHard;
  static const int playerLevelByScore = 10;
  late Player _player;
  late TextComponent _playerScore;
  late Timer _enemySpawner;
  late Timer _bulletSpawner;
  late GameOver _gameOver;
  int score = 0;

  @override
  Future<void>? onLoad() {
    _enemySpawner = Timer(
        _modeHard ? 2.5 : 1.8,
        onTick: _modeHard ? _spawnEnemyWithLife : _spawnEnemy,
        repeat: true
    );

    _bulletSpawner = Timer(
        _modeHard ? 0.8 : 1.2,
        onTick: _spawnBullet,
        repeat: true);
    add(Background(nbStars: 45));
    _playerScore = TextComponent(
      text: "Score: $score",
      position: Vector2(gameRef.size.toRect().width / 2, 10),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 40.0,
          color: Colors.white
        )
      )
    );
    _gameOver = GameOver();
    add(_playerScore);
    _player = Player(onHit: _onPlayerHit);
    add(_player);
    return null;
  }

  void _onPlayerHit(){
    _bulletSpawner.stop();
    _enemySpawner.stop();
    _player.destroy();

    add(_gameOver);
  }
  void _onEnemyHit(){
    score++;
    _playerScore.text = "Score: $score";
    if(score % playerLevelByScore == 0){
      //en fonction du score et quantité d'ennemis, vitesse de tir augmenté
      _bulletSpawner.stop();
      var speed = min(score ~/ playerLevelByScore, 1);
      _bulletSpawner = Timer(
        speed.toDouble(),
        onTick: _spawnBullet,
        repeat: true
      );
      _bulletSpawner.start();
    }
  }

  void _spawnEnemy(){
    // score entre 0 et 20 --> 1 ennemi
    // score entre 20 et 40 --> 2 ennemis
    final int hardness = min(score ~/ playerLevelByScore, 1);
    for(int i=0; i <= hardness; i++){
      add(Enemy(onHit: _onEnemyHit));
    }
  }
  void _spawnEnemyWithLife(){
    // score entre 0 et 20 --> 1 ennemi
    // score entre 20 et 40 --> 2 ennemis
    final int hardness = min(score ~/ playerLevelByScore, 1);

    for(int i=0; i <= hardness; i++){
      add(EnemyWithLife(onKill: _onEnemyHit));
    }
  }
  void _spawnBullet(){
    var bullet = Bullet();
    bullet.position = _player.position.clone();
    add(bullet);
  }

  void onPanUpdate(DragUpdateInfo info){
    if(isMounted){
      _player.move(info.delta.game);
    }
  }

  void onDoubleTap(){
    if(_gameOver.isMounted){
      _onGameOverClick.call(score);
    }
  }

  @override
  void onMount() {
    super.onMount();
    _enemySpawner.start();
    _bulletSpawner.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _enemySpawner.update(dt);
    _bulletSpawner.update(dt);
  }

  @override
  void onRemove() {
    super.onRemove();
    _enemySpawner.stop();
    _bulletSpawner.stop();
  }
}
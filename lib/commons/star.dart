import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:test_project/game_manager.dart';

class Star extends SpriteAnimationComponent with HasGameRef<GameManager>{

  @override
  Future<void>? onLoad() async {
    var sprideSheet = SpriteSheet(image: await Images().load("stars.png"), srcSize: Vector2(9.0, 9.0)); //9x9 taille de l'image
    animation = sprideSheet.createAnimation
      (row: Random().nextInt(3) +1, stepTime: (Random().nextInt(50)/10) +0.2); //steptime interval changement image
    var size = Random().nextInt(10).toDouble() + 10;
    var positionX = Random()
        .nextInt((gameRef.size.toRect().width - size/2).toInt())
        .toDouble();
    var positionY = Random()
        .nextInt((gameRef.size.toRect().height - size/2).toInt())
        .toDouble();
    width = size;
    height = size;
    position = Vector2(positionX, positionY);
    anchor = Anchor.center; //fixé par rapport au centre de l'image
  }
}
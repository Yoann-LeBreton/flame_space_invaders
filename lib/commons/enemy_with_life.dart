import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:test_project/game_manager.dart';

import 'explosion.dart';

class EnemyWithLife extends SpriteAnimationComponent
  with HasGameRef<GameManager>, CollisionCallbacks {

  EnemyWithLife({required onKill}) : _onKill = onKill;

  final Function _onKill;

  static const double _speed = 170;
  static const maxPointLife = 3;
  int lifePoint = maxPointLife;

  late RectangleComponent lifeBar;

  @override
  Future<void>? onLoad() async {
    var spriteSheet = SpriteSheet(
        image: await Images().load('enemy.png'),
        srcSize: Vector2(16, 16)
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.2);
    width = 40;
    height = 40;
    position = Vector2(Random().nextInt((gameRef.size.toRect().width - width).toInt()).toDouble(), height);
    anchor = Anchor.center;
    //add(PositionComponent(size: Vector2(100, 100)));
    lifeBar = RectangleComponent(
      anchor: Anchor.bottomLeft,
      size: Vector2((13.33*lifePoint).toDouble() ,8),
      paint: BasicPalette.lightGreen.paint()
    );
    add(lifeBar);
    add(CircleHitbox()..collisionType = CollisionType.passive);
  }

  void move(Vector2 delta){
    position.add(delta);
    //lifeBar.position.add(delta);
  }

  @override
  void update(double dt) {
    //dt --> deltatime
    super.update(dt);
    position += Vector2(0, 1) * _speed * dt;
    //lifeBar.position += Vector2(0, 1) * _speed * dt;
    if(position.y > gameRef.size.y){ //si il sort de l'écran, effacer le composant
      removeFromParent();
    }
  }

  void takeHit(){
    lifePoint --;
    lifeBar.size = Vector2((10*lifePoint).toDouble() ,8);
    if(lifePoint == 0){
      removeFromParent();
      _onKill.call();
      gameRef.add(Explosion(position: position));
    }
  }
}
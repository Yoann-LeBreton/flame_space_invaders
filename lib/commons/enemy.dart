import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:test_project/commons/explosion.dart';
import 'package:test_project/game_manager.dart';

class Enemy extends SpriteAnimationComponent
    with HasGameRef<GameManager>, CollisionCallbacks{

  Enemy({required onHit}) : _onHit = onHit;

  final Function _onHit;
  static const double _speed = 250;

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
    add(CircleHitbox()..collisionType = CollisionType.passive);
  }

  void move(Vector2 delta){
    position.add(delta);
  }

  @override
  void update(double dt) {
    //dt --> deltatime
    super.update(dt);
    position += Vector2(0, 1) * _speed * dt;
    if(position.y > gameRef.size.y){ //si il sort de l'écran, effacer le composant
      removeFromParent();
    }
  }

  void takeHit(){
    removeFromParent();
    _onHit.call();
    gameRef.add(Explosion(position: position));
  }

}
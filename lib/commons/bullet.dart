import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:test_project/commons/enemy_with_life.dart';
import 'package:test_project/game_manager.dart';

import 'enemy.dart';

class Bullet extends SpriteComponent
    with HasGameRef<GameManager>, CollisionCallbacks{
  static const double _speed = 450;

  @override
  Future<void>? onLoad() async {
    sprite = await gameRef.loadSprite('bullet.png');
    width = 32;
    height = 16;

    anchor = Anchor.center;
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    //dt --> deltatime
    super.update(dt);
    position += Vector2(0, -1) * _speed * dt;
    if(position.y < 0){ //si il sort de l'écran, effacer le composant
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if(other is Enemy){
      (other).takeHit();
      removeFromParent();
    }
    if(other is EnemyWithLife){
      (other).takeHit();
      removeFromParent();
    }
  }
}
import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:test_project/commons/enemy.dart';
import 'package:test_project/commons/enemy_with_life.dart';
import 'package:test_project/commons/explosion.dart';
import 'package:test_project/game_manager.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef<GameManager>, CollisionCallbacks{

  Player({required onHit}) : _onHit = onHit;

  final Function _onHit;

  @override
  Future<void>? onLoad() async {
    add(RectangleHitbox());
    var spriteSheet = SpriteSheet(
      image: await Images().load('player.png'),
      srcSize: Vector2(32, 48)
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.2);
    position = gameRef.size /2;
    width = 80;
    height = 120;
    anchor = Anchor.center;
  }

  void move(Vector2 delta){
    position.add(delta);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if(other is Enemy){
      _onHit.call();
    }
    if(other is EnemyWithLife){
      _onHit.call();
    }
  }

  void destroy(){
    gameRef.add(Explosion(position: position));
    removeFromParent();
  }
}
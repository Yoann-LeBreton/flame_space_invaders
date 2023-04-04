import 'package:flame/components.dart';

class Explosion extends SpriteAnimationComponent with HasGameRef {
  Explosion({super.position}) : super(
    size: Vector2.all(50),
    anchor: Anchor.center,
    removeOnFinish: true
  );

  @override
  Future<void> onLoad() async {
    animation = await gameRef.loadSpriteAnimation(
        'explosion.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2.all(32),
          loop: false)
    );
  }
}
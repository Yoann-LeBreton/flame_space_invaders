import 'package:flame/components.dart';
import 'package:test_project/game_manager.dart';

class MainTitle extends SpriteComponent with HasGameRef<GameManager>{

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load("start.png");
    anchor = Anchor.center; //référence position de l'image
    position = gameRef.size/2; //fixe l'image au centre de l'écran

    var originalSize = sprite?.originalSize;
    if(originalSize == null ) return;
    //calcul et application d'un ratio de l'image proportionnel à l'écran
    var width = gameRef.size.toSize().width / 1.5;
    var height = originalSize.toSize().height * (width / originalSize.toSize().width);
    size = Vector2(width, height);
  }
}
import 'package:flame/components.dart';
import 'package:test_project/commons/star.dart';
import 'package:test_project/game_manager.dart';

class Background extends Component with HasGameRef<GameManager>{
  final int nbStars;
  Background({required this.nbStars});

  @override
  Future<void>? onLoad() {
    for(int i=0; i<nbStars; i++){
      add(Star()); //ajout d'un élément Star sur le composant
    }
  }
}
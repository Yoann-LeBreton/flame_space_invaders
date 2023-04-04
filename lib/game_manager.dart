import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/screens/game_screen.dart';
import 'package:test_project/screens/main_screen.dart';

class GameManager extends FlameGame with PanDetector,TapDetector, DoubleTapDetector,HasCollisionDetection{
  late GameScreen _gameScreen;
  late MainScreen _mainScreen;
  late SharedPreferences sharedPref;
  var highScore = 0;
  var hardMode = false;

  GameManager(){
    _gameScreen = GameScreen(onGameOverClick: _displayMainScreen, modeHard: hardMode);
    _mainScreen = MainScreen(
        onStartClicked: _displayScreenGame,
        highScore: highScore,
        hardMode: hardMode,
        onChangeHardMode: onChangeHardMode
    );
  }

  @override
  Future<void>? onLoad() async {
    sharedPref = await SharedPreferences.getInstance();
    final int? highScorePref = sharedPref.getInt('high_score');
    if(highScorePref != null) highScore = highScorePref;
    _displayMainScreen(0);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    super.onPanUpdate(info);
    _gameScreen.onPanUpdate(info);
  }


  @override
  void onDoubleTap() {
    super.onDoubleTap();
    if(_gameScreen.isMounted){
      _gameScreen.onDoubleTap();
    }
    if(_mainScreen.isMounted){
      _mainScreen.onDoubleTap();
    }
  }


  @override
  void onTap() {
    super.onTap();
    if(_mainScreen.isMounted){
      _mainScreen.onTap();
    }
  }

  void onChangeHardMode(){
    hardMode = !hardMode;
    remove(_mainScreen);
    _displayMainScreen(highScore);
  }

  void _displayScreenGame(){
    if(_mainScreen.isMounted){
      remove(_mainScreen);
      _mainScreen.removeFromParent();
    }
    _gameScreen = GameScreen(onGameOverClick: _displayMainScreen, modeHard: hardMode);
    add(_gameScreen);
  }
  void _displayMainScreen(int newScore){
    if(newScore > highScore){
      sharedPref.setInt('high_score', newScore);
      highScore = newScore;
    }
    _mainScreen = MainScreen(
        onStartClicked: _displayScreenGame,
        highScore: highScore,
        hardMode: hardMode,
        onChangeHardMode: onChangeHardMode
    );
    if(_gameScreen.isMounted){
      remove(_gameScreen);
      _gameScreen.removeFromParent();
    }
    add(_mainScreen);
  }
}
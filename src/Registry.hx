package ;

import cobraui.graphics.BitmapFont;
import screens.ScreenManager;

class Registry {
  public static var screenManager:ScreenManager;

  public static var spots:Int = 1;

  public static var NORMAL:Int = 0;
  public static var MIRRORS:Int = 1;
  public static var ROTATIONS:Int = 2;
  public static var ALL:Int = 3;
  public static var gameType:Int = NORMAL;

  public static var lastScore:Int;
  public static var highscoreManager:HighscoreManager;

  public static var font:BitmapFont;

  public static function getTime():Float {
#if (neko || cpp)
    return Sys.time();
#else
    return Date.now().getTime() / 1000;
#end
  }
}

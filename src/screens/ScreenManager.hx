package screens;

import nme.geom.Point;

class ScreenManager {
  public var screens:Hash<Screen>;
  public var screenPos:Hash<Point>;

  public var last:Screen;
  public var current:Screen;

  private var switching:Bool;
  private var switchingTime:Float;
  private var switchingTimeLeft:Float;

  public function new() {
    screens = new Hash<Screen>();

    current = null;
    last = null;

    switchingTime = 0.2;
    switchingTimeLeft = 0;

    switching = false;
  }

  public function addScreen(screen:Screen, name:String) {
    screens.set(name, screen);

    if (current == null) {
      current = screen;
      current.enter();
    } else {
      screen.visible = false;
    }
  }

  public function switchScreen(name:String) {
    if (screens.exists(name)) {
      last = current;
      current = screens.get(name);
      current.x = last.uWidth;
      switchingTimeLeft = switchingTime;
      switching = true;

      current.enter();
    }
  }
  
  public function update(dt:Float) {
    if (switching) {
      if ((switchingTimeLeft -= dt) <= 0) {
        switchingTimeLeft = 0;
        switching = false;
        last.exit();
      }
      var left = switchingTimeLeft / switchingTime;
      current.x =  left * last.uWidth;
      last.x = (1 - left) * -last.uWidth;
    } else {
      current.update(dt);
    } 
  }
}


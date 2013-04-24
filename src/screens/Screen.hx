package screens;

import nme.display.Sprite;

class Screen extends Sprite {
  public var uWidth:Float;
  public var uHeight:Float;
  public var pause:Bool;

  public function new(?uWidth:Float, ?uHeight:Float) {
    super();

    this.uWidth = uWidth;
    this.uHeight = uHeight;
    this.pause = false;
  }

  public function update(dt:Float) {
  }

  public function enter() {
    this.visible = true;
  }

  public function exit() {
    this.visible = false;
  }
}

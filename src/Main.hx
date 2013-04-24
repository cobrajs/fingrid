package ;

import screens.GameScreen;
import screens.MenuScreen;
import screens.HighscoreScreen;
import screens.ScreenManager;

import Gradient;
import cobraui.graphics.Color;

// CobraUI
import cobraui.components.Label;
import cobraui.graphics.BitmapFont;

// Libraries
import nme.display.Sprite;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.system.System;
import nme.ui.Keyboard;

class Main extends Sprite {

  private var lastTime:Float;
  private var game:GameScreen;
  private var menu:MenuScreen;
  private var score:HighscoreScreen;
  private var screenManager:ScreenManager;

  public function new() {
    super();

    addEventListener(Event.ADDED_TO_STAGE, addedToStage);

    Registry.font = new BitmapFont("profont_2x.png", 16, 8);
    Label.font = Registry.font;

    Registry.highscoreManager = new HighscoreManager();
  }

  private function construct():Void {
    addEventListener(Event.ENTER_FRAME, enterFrame);

    //var gameScreen = new GameScreen(stage.stageWidth, stage.stageHeight);

    stage.addEventListener(KeyboardEvent.KEY_DOWN, stageKeyDown);

    Registry.screenManager = new ScreenManager();

    menu = new MenuScreen(stage.stageWidth, stage.stageHeight);
    Registry.screenManager.addScreen(menu, "menu");

    addChild(menu);

    game = new GameScreen(stage.stageWidth, stage.stageHeight);
    Registry.screenManager.addScreen(game, "game");

    addChild(game);

    score = new HighscoreScreen(stage.stageWidth, stage.stageHeight);
    Registry.screenManager.addScreen(score, "score");

    addChild(score);

    lastTime = getTime();
  }

  private function getTime():Float {
#if (neko || cpp)
    return Sys.time();
#else
    return Date.now().getTime() / 1000;
#end
  }

  private function update():Void {
    var currentTime = getTime();
    var dt = currentTime - lastTime;
    lastTime = currentTime;

    Registry.screenManager.update(dt);
  }


  // -------------------------------------------------- 
  //                  Event Handlers
  // -------------------------------------------------- 

  private function addedToStage(event:Event):Void {
    construct();
  }

  private function enterFrame(event:Event):Void {
    update();
  }

  private function stageKeyDown(event:KeyboardEvent):Void {
    if (event.keyCode == Keyboard.ESCAPE) {
      System.exit(0);
    } else if (event.keyCode == Keyboard.SPACE) {
      game.reset(false);
    } else if (event.keyCode == Keyboard.R) {
      trace("full reset");
      game.reset(true);
    }
  }
}


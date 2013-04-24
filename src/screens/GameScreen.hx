package screens;

// TODO: Add high score screen and tracking and storing

import screens.Screen;

import GameOver;
import Gradient;
import Grid;
import ScoreBar;
import Target;

// CobraUI
import cobraui.components.Component;
import cobraui.components.Container;
import cobraui.components.Label;
import cobraui.components.SimpleButton;
import cobraui.graphics.BitmapFont;
import cobraui.graphics.Color;
import cobraui.layouts.BorderLayout;
import cobraui.layouts.GridLayout;
import cobraui.util.TouchManager;

// Libraries
import nme.display.Sprite;
import nme.display.Shape;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.geom.Point;
import nme.ui.Keyboard;
import nme.ui.Multitouch;
import nme.media.Sound;
import nme.Assets;

class GameScreen extends Screen {
  private static var buttonDownColor:Color;
  private static var buttonUpColor:Color;

  private var layout:BorderLayout;
  
  private var container:Container;
  private var grid:Grid<Int>;
  private var gridUpdate:Bool;
  private var touches:Int;

  private var miniViewHolder:Component;
  private var miniView:Shape;
  private var miniViewTarget:Target;
  private var miniViewSize:Float;

  private var timerBar:Component;
  private var origStartTime:Float;
  private var startTime:Float;
  private var decreaseTime:Float;
  private var timeLeft:Float;
  private var timerBarGradient:Gradient;

  private var score:Int;

  private var messageBar:Label<String>;
  private var scoreBar:ScoreBar;

  private var topStuffHolder:Container;

  private var overlay:Sprite;
  private var overlayStartTime:Float;
  private var overlayTimeLeft:Float;

  private var transformType:Int;

  private var gameOverPopup:GameOver;

  private var boop:Sound;

  public function new(?uWidth:Float, ?uHeight:Float) {
    super(uWidth, uHeight);

    // Game vars
    transformType = Grid.getRandomTransform();
    score = 0;

    boop = Assets.getSound("assets/sounds/boop.wav");

    //
    // Setup button grid
    //
    container = new Container();
    container.layout = new GridLayout(uWidth, uWidth, 3, 3);
    container.y = uHeight - uWidth;
    addChild(container);
    grid = new Grid<Int>(3, 3, 0);
    gridUpdate = true;

    buttonDownColor = new Color(0x999999);
    buttonUpColor = new Color(0xFFFFFF);
    var borderColor = new Color(0x999999);

    for (space in grid.iterPos()) {
      var tempButton = new Component();
      tempButton.border = borderColor;
      tempButton.borderWidth = 1;
      tempButton.background = buttonUpColor;
      var downFunc = genClickFunc(space[0], space[1], 1);
      var upFunc = genClickFunc(space[0], space[1], 0);
      var heldFunc = function(e:MouseEvent) {
        if (e.buttonDown) {
          downFunc(e);
        }
      };
      // Bind events for buttons
      tempButton.addEventListener(MouseEvent.MOUSE_DOWN, downFunc);
      tempButton.addEventListener(MouseEvent.MOUSE_UP, upFunc);
      tempButton.addEventListener(MouseEvent.MOUSE_OVER, heldFunc);
      tempButton.addEventListener(MouseEvent.MOUSE_OUT, upFunc);
      if (Multitouch.supportsTouchEvents) {
        tempButton.addEventListener(TouchEvent.TOUCH_BEGIN, downFunc);
        tempButton.addEventListener(TouchEvent.TOUCH_END, upFunc);
        tempButton.addEventListener(TouchEvent.TOUCH_MOVE, downFunc);
        tempButton.addEventListener(TouchEvent.TOUCH_OVER, downFunc);
        tempButton.addEventListener(TouchEvent.TOUCH_OUT, upFunc);
      }
      container.layout.addComponent(tempButton);
      container.addChild(tempButton);
    }

    container.layout.pack();

    //
    // Setup top display
    //

    topStuffHolder = new Container();
    topStuffHolder.layout = new BorderLayout(10, 10);
    addChild(topStuffHolder);

    miniViewHolder = new Component();
    miniViewHolder.background = null;
    topStuffHolder.addChild(miniViewHolder);

    var offset = 10;

    // Add view holder with custom resize function to redraw
    topStuffHolder.layout.assignComponent(miniViewHolder, BorderLayout.MIDDLE, 1, 0.7, percent, function() {

      miniViewSize = Math.min(miniViewHolder.uWidth, miniViewHolder.uHeight) - offset * 2;
      miniViewTarget.size = miniViewSize;

      miniView.x = (miniViewHolder.uWidth / 4) - miniViewSize / 2;
      miniView.y = miniViewHolder.uHeight / 2 - miniViewSize / 2;

      miniViewTarget.x = (miniViewHolder.uWidth / 4) * 3 - miniViewSize / 2;
      miniViewTarget.y = miniViewHolder.uHeight / 2 - miniViewSize / 2;
    });

    var viewPort = (uHeight - uWidth);

    miniViewSize = Math.min(uWidth / 2, viewPort) - offset * 2;

    miniView = new Shape();
    miniViewHolder.addChild(miniView);

    miniViewTarget = new Target();
    miniViewTarget.size = miniViewSize;
    miniViewHolder.addChild(miniViewTarget);

    // Add bar for displaying time left
    timerBar = new Component();
    timerBar.background = null;
    timerBar.borderWidth = 1;
    origStartTime = 10;
    decreaseTime = 0.1; // 10% time after each win
    startTime = origStartTime;
    timeLeft = startTime;

    topStuffHolder.layout.assignComponent(timerBar, BorderLayout.TOP, 1, 0.15, percent);
    topStuffHolder.addChild(timerBar);

    // Add container for holding message and score
    var messageContainer = new Container();
    messageContainer.layout = new GridLayout(10, 10, 0, 1);

    // Add bar for displaying message
    messageBar = new Label<String>(Grid.getTransformText(transformType));
    messageBar.background = null;
    messageBar.hAlign = center;

    messageBar.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent) {
      Registry.screenManager.switchScreen("menu");
    });

    messageContainer.layout.addComponent(messageBar);
    messageContainer.addChild(messageBar);

    // Add bar for displaying score
    scoreBar = new ScoreBar(); //Label<String>(Std.string(score));

    messageContainer.layout.addComponent(scoreBar);
    messageContainer.addChild(scoreBar);

    messageContainer.layout.pack();

    topStuffHolder.layout.assignComponent(messageContainer, BorderLayout.BOTTOM, 1, 0.15, percent);
    topStuffHolder.addChild(messageContainer);

    topStuffHolder.resize(uWidth, viewPort);
    topStuffHolder.layout.pack();

    //
    // Add overlay for flashing
    //
    overlay = new Sprite();
    var gfx = overlay.graphics;
    gfx.beginFill(0x555555);
    gfx.drawRect(0, 0, uWidth, uHeight);
    gfx.endFill();
    overlay.alpha = 0;
    overlay.mouseEnabled = false;
    overlayStartTime = 0.25;
    addChild(overlay);

    //
    // Add GameOver popup (with callback to reset)
    //
    gameOverPopup = new GameOver(function(){
      reset(true);
    });
    addChild(gameOverPopup);

    // Add gradient for timer bar
    timerBarGradient = new Gradient(new Color(0xFF0000), new Color(0xBBBBBB));
    timerBarGradient.addStop(new Color(0xBBBBBB), 0.7);

    // Setup timing and load first view
    reset(true, false);
  }

  // Closure generator
  private function genClickFunc(x:Int, y:Int, val:Int) {
    return function(e:MouseEvent) {
      if (grid.get(x, y) != val) {
        if (Std.is(e.currentTarget, Component)) {
          var comp = cast(e.currentTarget, Component);
          comp.background = val == 1 ? buttonDownColor : buttonUpColor;
          comp.redraw();
        }
        grid.set(val, x, y);
        gridUpdate = true;
      }
    };
  }

  public function reset(fullReset:Bool, ?showOverlay:Bool = true) {
    pause = false;
    transformType = Grid.getRandomTransform();
    messageBar.content = Grid.getTransformText(transformType);
    miniViewTarget.update();
    if (showOverlay) {
      overlay.alpha = 1;
      overlayTimeLeft = overlayStartTime;
    }
    if (fullReset) {
      score = 0;
      scoreBar.score = score;
      scoreBar.setAddScore(score);
      startTime = origStartTime;
    } else {
      var tempScore = Math.ceil((timeLeft / startTime) * 100) * Registry.spots * (Registry.gameType + 1);
      score += tempScore;
      scoreBar.setAddScore(tempScore);
      startTime -= startTime * decreaseTime;
      boop.play();

    }
    timeLeft = startTime;
  }

  public override function enter() {
    super.enter();

    reset(true, false);
  }

  public override function exit() {
    super.exit();
  }

  public override function update(dt:Float) {
    super.update(dt);
    if (this.pause) {
      return;
    }

    timeLeft -= dt;

    scoreBar.update(dt);

    if (overlayTimeLeft > 0) {
      overlayTimeLeft -= dt;
      overlay.alpha = 0.5 * (overlayTimeLeft / overlayStartTime);
    }

    if (timeLeft > 0) {
      var gfx = timerBar.graphics;
      gfx.clear();
      var borderOffset = 1;
      gfx.lineStyle(borderOffset, 0xBBBBBB);
      gfx.moveTo(0, timerBar.uHeight);
      gfx.lineTo(timerBar.uWidth, timerBar.uHeight);
      gfx.lineStyle();
      gfx.beginFill(timerBarGradient.getColor(timeLeft / startTime).colorInt);
      gfx.drawRect(0, 0, timerBar.uWidth * (timeLeft / startTime), timerBar.uHeight - borderOffset);
      gfx.endFill();
    } else {
      var place = Registry.highscoreManager.addScore(score, "");
      gameOverPopup.popupScore(score, place);
      this.pause = true;
    }

    if (gridUpdate) {
      var size = miniViewSize / 3;
      var gfx = miniView.graphics;
      gfx.clear();
      gfx.lineStyle(1, 0x999999);
      gfx.moveTo(0, 0);
      gfx.lineTo(0, size * grid.width);
      gfx.moveTo(0, 0);
      gfx.lineTo(size * grid.width, 0);
      for (x in 0...grid.width) {
        gfx.moveTo((x + 1) * size, 0);
        gfx.lineTo((x + 1) * size, size * grid.width);
        gfx.moveTo(0, (x + 1) * size);
        gfx.lineTo(size * grid.width, (x + 1) * size);
      }
      gfx.beginFill(0x99FF99);
      for (space in grid.iterPos()) {
        if (grid.get(space[0], space[1]) == 1) {
          gfx.drawRect(size * space[0], size * space[1], size, size);
        }
      }
      gfx.lineStyle();
      gfx.endFill();
      gridUpdate = false;

      if (miniViewTarget.checkGrid(grid.transform(transformType))) {
        reset(false);
      }
    }
  }
}

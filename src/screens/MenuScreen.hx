package screens;

import screens.Screen;

import Grid;
import Target;

// CobraUI
import cobraui.components.Component;
import cobraui.components.Container;
import cobraui.components.Label;
import cobraui.components.Selector;
import cobraui.components.SimpleButton;
import cobraui.graphics.BitmapFont;
import cobraui.graphics.Color;
import cobraui.layouts.BorderLayout;
import cobraui.layouts.GridLayout;

// Libraries
import nme.display.Sprite;
import nme.display.Shape;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.ui.Keyboard;
import nme.ui.Multitouch;

class MenuScreen extends Screen {
  private static var buttonDownColor:Color;
  private static var buttonUpColor:Color;

  private var layout:BorderLayout;

  private var buttonContainer:Container;

  public function new(?uWidth:Float, ?uHeight:Float) {
    super(uWidth, uHeight);

    //
    // Setup buttons 
    //
    buttonContainer = new Container();
    buttonContainer.layout = new GridLayout(uWidth, uHeight, 1, 0);
    //buttonContainer.y = uHeight - uWidth;
    addChild(buttonContainer);

    buttonDownColor = new Color(0x999999);
    buttonUpColor = new Color(0xFFFFFF);
    var borderColor = new Color(0x999999);

    // Title Label
    var titleLabel = new Label<String>("FINGRID");
    titleLabel.hAlign = center;
    titleLabel.background = new Color("white");

    buttonContainer.layout.addComponent(titleLabel);
    buttonContainer.addChild(titleLabel);

    // Start Button
    var startButton = new SimpleButton<String>("Start");
    startButton.borderWidth = 1;
    startButton.background = new Color(0xCCCCCC);
    startButton.onClick = function(e:MouseEvent) {
      Registry.screenManager.switchScreen("game");
    };

    buttonContainer.layout.addComponent(startButton);
    buttonContainer.addChild(startButton);

    // Spots Level
    var spotSelector = new Selector<String>(["Spots: 1", "Spots: 2", "Spots: 3", "Spots: 4"]);
    spotSelector.hAlign = center;
    spotSelector.borderWidth = 1;
    spotSelector.addEventListener(Event.CHANGE, function(e:Event) {
      Registry.spots = spotSelector.selectedIndex + 1;
    });

    buttonContainer.layout.addComponent(spotSelector);
    buttonContainer.addChild(spotSelector);

    // Game Type
    var gameSelector = new Selector<String>([
      "Game Type: Normal", 
      "Game Type: Mirrored Only", 
      "Game Type: Rotations Only", 
      "Game Type: All"
    ]);
    gameSelector.hAlign = center;
    gameSelector.borderWidth = 1;
    gameSelector.addEventListener(Event.CHANGE, function(e:Event) {
      Registry.gameType = gameSelector.selectedIndex;
    });

    buttonContainer.layout.addComponent(gameSelector);
    buttonContainer.addChild(gameSelector);

    // Scores Button
    var scoresButton = new SimpleButton<String>("Highscores");
    scoresButton.borderWidth = 1;
    scoresButton.background = new Color(0xCCCCCC);
    scoresButton.onClick = function(e:MouseEvent) {
      Registry.screenManager.switchScreen("score");
    };

    buttonContainer.layout.addComponent(scoresButton);
    buttonContainer.addChild(scoresButton);


    buttonContainer.layout.pack();
  }
  
  public override function enter() {
    super.enter();
  }

  public override function exit() {
    super.exit();
  }

  public override function update(dt:Float) {
    super.update(dt);
  }
}


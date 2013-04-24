package screens;

import screens.Screen;

import Grid;
import HighscoreManager;
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

class HighscoreScreen extends Screen {
  private var buttonContainer:Container;
  private var scoresDisplay:Container;

  private var scoreLabels:Array<Array<Label<String>>>;

  private var layout:BorderLayout;

  public function new(?uWidth:Float, ?uHeight:Float) {
    super(uWidth, uHeight);

    layout = new BorderLayout(uWidth, uHeight);

    //
    // Add title
    //
    var titleLabel = new Label<String>("High Scores");
    titleLabel.borderWidth = 1;
    titleLabel.hAlign = center;
    addChild(titleLabel);
    layout.assignComponent(titleLabel, BorderLayout.TOP, 1, 0.15, percent);

    //
    // Setup buttons 
    //
    buttonContainer = new Container();
    buttonContainer.layout = new GridLayout(10, 10, 0, 1);
    buttonContainer.borderWidth = 1;
    //buttonContainer.y = uHeight - uWidth;
    addChild(buttonContainer);
    layout.assignComponent(buttonContainer, BorderLayout.BOTTOM, 1, 0.15, percent);

    var borderColor = new Color(0x999999);

    // Clear Button
    var clearButton = new SimpleButton<String>("Clear");
    clearButton.borderWidth = 1;
    clearButton.background = new Color(0xCCCCCC);
    clearButton.onClick = function(e:MouseEvent) {
      Registry.highscoreManager.clearScores();
      updateScores();
    };

    buttonContainer.layout.addComponent(clearButton);
    buttonContainer.addChild(clearButton);
    
    // Menu Button
    var menuButton = new SimpleButton<String>("Menu");
    menuButton.borderWidth = 1;
    menuButton.background = new Color(0xCCCCCC);
    menuButton.onClick = function(e:MouseEvent) {
      Registry.screenManager.switchScreen("menu");
    };

    buttonContainer.layout.addComponent(menuButton);
    buttonContainer.addChild(menuButton);

    buttonContainer.layout.pack();

    scoreLabels = new Array<Array<Label<String>>>();

    scoresDisplay = new Container();
    scoresDisplay.borderWidth = 2;
    scoresDisplay.layout = new GridLayout(10, 10, 3, 0);
    addChild(scoresDisplay);
    layout.assignComponent(scoresDisplay, BorderLayout.MIDDLE, 1, 0.7, percent);

    var evenColor = new Color(0xEEEEEE);

    for (i in 0...HighscoreManager.scoreLength) {
      var score:Score = Registry.highscoreManager.list[i];

      var numLabel = new Label<String>(Std.string(i + 1));
      numLabel.hAlign = center;
      scoresDisplay.addChild(numLabel);
      scoresDisplay.layout.addComponent(numLabel);

      var nameLabel = new Label<String>(score == null ? '' : score.name);
      scoresDisplay.addChild(nameLabel);
      scoresDisplay.layout.addComponent(nameLabel);

      var scoreLabel = new Label<String>(score == null ? '' : Std.string(score.score));
      scoresDisplay.addChild(scoreLabel);
      scoresDisplay.layout.addComponent(scoreLabel);

      var list = new Array<Label<String>>();
      list.push(numLabel);
      list.push(nameLabel);
      list.push(scoreLabel);

      if (i % 2 == 0) {
        numLabel.background = evenColor;
        nameLabel.background = evenColor;
        scoreLabel.background = evenColor;
      }

      scoreLabels.push(list);
    }

    scoresDisplay.layout.pack();

    layout.pack();
  }

  private function updateScores() {
    for (i in 0...HighscoreManager.scoreLength) {
      var score:Score = Registry.highscoreManager.list[i];
      var labelSet = scoreLabels[i];
      var nameLabel = labelSet[1];
      nameLabel.content = score == null ? '' : score.name;
      var scoreLabel = labelSet[2];
      scoreLabel.content = score == null ? '' : Std.string(score.score);
    }
  }
  
  public override function enter() {
    super.enter();
    updateScores();
  }

  public override function exit() {
    super.exit();
  }

  public override function update(dt:Float) {
    super.update(dt);
  }
}



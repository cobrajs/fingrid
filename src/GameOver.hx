package ;

// CobraUI
import cobraui.components.Container;
import cobraui.components.Label;
import cobraui.components.SimpleButton;
import cobraui.popup.Popup;
import cobraui.layouts.BorderLayout;
import cobraui.layouts.GridLayout;

// NME
import nme.events.MouseEvent;

class GameOver extends Popup {
  public var display:Label<String>;
  public var highscoreDisplay:Label<String>;
  public var restartCallback:Void->Void;

  public function new(restartCallback:Void->Void) {
    super(0.8, 0.4, '', BorderLayout.MIDDLE, false);

    this.restartCallback = restartCallback;

    window.borderWidth = 2;

    layout = new GridLayout(this.uWidth, this.uHeight, 1, 0);

    // Message
    var message = new Label<String>("Game over man!");
    message.hAlign = center;

    layout.addComponent(message); //, BorderLayout.TOP, 1, 0.6, percent);
    window.addChild(message);

    // Display
    display = new Label<String>("Final score: ");
    display.hAlign = center;

    layout.addComponent(display); //, BorderLayout.TOP, 1, 0.6, percent);
    window.addChild(display);

    // Highscore
    highscoreDisplay = new Label<String>("");
    highscoreDisplay.hAlign = center;

    layout.addComponent(highscoreDisplay); //, BorderLayout.TOP, 1, 0.6, percent);
    window.addChild(highscoreDisplay);

    // Container for buttons
    var buttonContainer = new Container();
    buttonContainer.layout = new GridLayout(10, 10, 0, 1);

    var restartButton = new SimpleButton<String>("Restart");
    restartButton.borderWidth = 1;
    restartButton.onClick = function(e:MouseEvent) {
      hide();
      restartCallback();
    };

    buttonContainer.addChild(restartButton);
    buttonContainer.layout.addComponent(restartButton);

    var mainMenuButton = new SimpleButton<String>("Menu");
    mainMenuButton.borderWidth = 1;
    mainMenuButton.onClick = function(e:MouseEvent) {
      hide();
      Registry.screenManager.switchScreen("menu");
    };

    buttonContainer.addChild(mainMenuButton);
    buttonContainer.layout.addComponent(mainMenuButton);

    buttonContainer.layout.pack();

    layout.addComponent(buttonContainer); //, BorderLayout.BOTTOM, 1, 0.4, percent);
    window.addChild(buttonContainer);

    // Finish up
    layout.pack();
  }

  public function popupScore(score:Int, place:Int) {
    display.content = "Final score: " + Std.string(score);
    if (place > -1) {
      highscoreDisplay.content = getPlaceLabel(place) + " place";
    }
    popup();
  }

  private function getPlaceLabel(place) {
    switch(place) {
      case 0:
        return "1st";
      case 1:
        return "2nd";
      case 2:
        return "3rd";
      default:
        return Std.string(place + 1) + "th";
    }
  }
}

package ;

import cobraui.components.Container;
import cobraui.components.Label;
import cobraui.layouts.GridLayout;

class ScoreBar extends Container {
  public var score(default, setScore):Int;
  public var addScore(default, null):Int;

  private var scoreMessage:Label<String>;
  private var addMessage:Label<String>;

  private var decreaseStartTime:Float;
  private var decreaseTime:Float;

  public function new() {
    super();

    layout = new GridLayout(10, 10, 0, 1);

    scoreMessage = new Label<String>("");
    scoreMessage.background = null;

    layout.addComponent(scoreMessage);
    addChild(scoreMessage);

    addMessage = new Label<String>("");
    addMessage.background = null;

    layout.addComponent(addMessage);
    addChild(addMessage);

    score = 0;
    addScore = 0;
    addMessage.visible = false;

    decreaseStartTime = 0.5;
    decreaseTime = 0;

    layout.pack();
  }

  public function update(dt:Float) {
    if (decreaseTime <= 0) {
      if (addScore > 0) {
        addScore -= 1;
        score += 1;
        addMessage.content = "+ " + Std.string(addScore);
        if (addScore <= 0) {
          addMessage.visible = false;
        }
      }
    } else {
      decreaseTime -= dt;
    }
  }

  public function setScore(score:Int):Int {
    this.score = score;
    scoreMessage.content = Std.string(score);
    return score;
  }

  public function setAddScore(score:Int):Int {
    if (addMessage.visible == false) { 
      addMessage.visible = true;
    }
    if (score == 0) {
      addMessage.visible = false;
    }
    this.score += addScore;
    this.addScore = score;
    addMessage.content = "+ " + Std.string(addScore);
    decreaseTime = decreaseStartTime;
    return score;
  }

}

package ;

import nme.net.SharedObject;

typedef Score = {
  var score:Float;
  var name:String;
  var time:Float;
};

class HighscoreManager {
  public static var scoreLength:Int = 10;

  //
  // Scores closer to the head of the list are higher
  //
  public var list:Array<Score>;

  private var so:SharedObject;

  private var dirty:Bool;

  public function new() {
    dirty = false;

    so = SharedObject.getLocal("fingrid-highscores");

    if (so.data.list == null) {
      so.data.list = new Array<Score>();
      dirty = true;
    }

    list = so.data.list;

    if (dirty) {
      so.flush();
    }
  }

  public function addScore(score:Float, name:String):Int {
    var tempScore:Score = {
      score: score,
      name: name,
      time: Registry.getTime()
    };
    var insert:Int = 0;
    for (i in 0...list.length) {
      if (tempScore.score < list[i].score) {
        insert = i + 1;
      }
    }

    if (insert < scoreLength) {
      dirty = true;
      list.insert(insert, tempScore);
    } else {
      insert = -1;
    }

    if (list.length > scoreLength) {
      dirty = true;
      list.pop();
    }

    sync();

    return insert;
  }

  public function clearScores() {
    for (i in 0...list.length) {
      list.pop();
    }
    dirty = true;
    sync();
  }

  public function print() {
    for (score in list) {
      trace(score.name +":  " + score.score);
    }
  }

  public function getNewest():Score {
    var max:Float = 0;
    var newest:Score = null;
    for (score in list) {
      if (score.time > max) {
        max = score.time;
        newest = score;
      }
    }
    return newest;
  }

  private function sync() {
    if (dirty) {
      try {
        so.flush();
      } catch(e:Dynamic) {
        trace("Error writing high scores: " + e);
      }
    }
  }
}


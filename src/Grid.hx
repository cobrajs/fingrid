package ;

import nme.geom.Point;

class Grid<T> {
  public static var NORMAL:Int = 0;
  public static var MIRRORX:Int = 1;
  public static var MIRRORY:Int = 2;
  public static var ROTATE90:Int = 3;
  public static var ROTATE180:Int = 4;
  public static var ROTATE270:Int = 5;

  public var data:Array<Array<T>>;
  public var width:Int;
  public var height:Int;
  public var defaultValue:T;

  public static function getTransformText(type:Int):String {
    if (type >=NORMAL && type <= ROTATE270) {
      return ["Normal", "Mirror X", "Mirror Y", "Rotate Left", "Rotate 180", "Rotate Right"][type];
    } 
    return "";
  }

  public static function getRandomTransform():Int {
    var randList = null;
    switch(Registry.gameType) {
      case Registry.NORMAL:
        return NORMAL;
      case Registry.MIRRORS:
        randList = [MIRRORX, MIRRORY];
      case Registry.ROTATIONS:
        randList = [ROTATE90, ROTATE180, ROTATE270];
      case Registry.ALL:
        randList = [NORMAL, MIRRORX, MIRRORY, ROTATE90, ROTATE180, ROTATE270];
    }
    if (randList != null) {
      return randList[Std.int(Math.random() * randList.length)];
    }
    return NORMAL;
  }

  public function new(?width:Int, ?height:Int, ?defaultValue:T) {
    data = new Array<Array<T>>();

    if (width != null && height != null) {
      this.width = width;
      this.height = height;
      this.defaultValue = defaultValue;
      for (y in 0...height) {
        data.push(new Array<T>());
        for (x in 0...width) {
          data[y].push(defaultValue);
        }
      }
    }
  }

  public function set(t:T, x:Int, y:Int) {
    if (y >= data.length) {
      for (i in 0...(y - data.length + 1)) {
        data.push(new Array<T>());
      }
      this.height = data.length;
    }

    if (x >= data[y].length) {
      for (i in 0...(x - data[y].length + 1)) {
        data[y].push(defaultValue);
      }
      this.width = data[y].length;
    }

    data[y][x] = t;
  }

  public function get(x:Int, y:Int):T {
    if (y < 0 || x < 0) {
      return defaultValue;
    }
    if (y >= data.length || x >= data[0].length) {
      return defaultValue;
    }
    return data[y][x];
  }


  public function find(t:T):Point {
    for (v in iterPos()) {
      if (data[v[1]][v[0]] == t) {
        return new Point(v[0], v[1]);
      }
    }
    return null;
  }

  public function clone(?deep:Bool = false):Grid<T> {
    var ret = new Grid<T>(width, height, defaultValue);
    for (cell in this.iterPos()) {
      ret.set(this.get(cell[0], cell[1]), cell[0], cell[1]);
    }
    return ret;
  }

  public function transform(type:Int):Grid<T> {
    var ret = new Grid<T>(width, height, defaultValue);
    var transformFunc:Int->Int->Array<Int> = null;
    switch(type) {
      case NORMAL:
        transformFunc = function(x:Int, y:Int) { return [x, y]; }
      case MIRRORX:
        transformFunc = function(x:Int, y:Int) { return [ret.width - x - 1, y]; }
      case MIRRORY:
        transformFunc = function(x:Int, y:Int) { return [x, ret.height - y - 1]; }
      case ROTATE90:
        transformFunc = function(x:Int, y:Int) { return [ret.width - y - 1, x]; }
      case ROTATE180:
        transformFunc = function(x:Int, y:Int) { return [ret.width - x - 1, ret.height - y - 1]; }
      case ROTATE270:
        transformFunc = function(x:Int, y:Int) { return [y, ret.height - x - 1]; }
    }
    for (space in ret.iterPos()) {
      var temp = transformFunc(space[0], space[1]);
      ret.set(this.get(space[0], space[1]), temp[0], temp[1]);
    }
    return ret;
  }

  //
  // Iterator generators
  //
  public function iter() {
    return new GridIterator(this);
  }

  public function iterPos() {
    return new GridIteratorPos(this);
  }
}


private class GridIterator<T> {
  var i:Int;
  var grid:Grid<T>;

  public function new(grid:Grid<T>) {
    i = -1;
    this.grid = grid;
  }

  public function hasNext() { i++; return (Std.int(i / grid.width) < grid.height); }
  public function next() { return grid.data[Std.int(i / grid.width)][(i++) % grid.width]; }
}


private class GridIteratorPos<T> {
  var i:Int;
  var grid:Grid<T>;

  public function new(grid:Grid<T>) {
    i = -1;
    this.grid = grid;
  }

  public function hasNext() { i++; return (Std.int(i / grid.width) < grid.height); }
  public function next():Array<Int> { return [i % grid.width, Std.int((i) / grid.width)]; }
}

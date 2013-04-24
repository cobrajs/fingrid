package ;

import Grid;

import nme.display.Shape;

// Handles the display of the target as well as generating itself and checking against it

class Target extends Shape {
  private var grid:Grid<Int>;
  private var gridDisplay:Grid<Int>;

  public var size:Float;

  public function new() {
    super();

    size = 10;

    grid = new Grid<Int>(3, 3, 0);
    gridDisplay = new Grid<Int>(3, 3, 0);
  }

  public function checkGrid(check:Grid<Int>) {
    var expect = Registry.spots;
    for (space in check.iterPos()) {
      if (grid.get(space[0], space[1]) + check.get(space[0], space[1]) == 2) {
        expect--;
      }
    }
    return expect == 0;
  }

  public function update() {
    for (space in grid.iterPos()) {
      grid.set(0, space[0], space[1]);
    }
    var times = Registry.spots;
    while (times > 0) {
      var p = Std.int(Math.random() * (grid.width * grid.height));
      var x = Std.int(p % grid.width);
      var y = Std.int(p / grid.width);
      if (grid.get(x, y) != 1) {
        grid.set(1, x, y);
        times--;
      }
    }
    var size = size / 3;
    var gfx = this.graphics;
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
    gfx.beginFill(0xFF9999);
    for (space in grid.iterPos()) {
      if (grid.get(space[0], space[1]) == 1) {
        gfx.drawRect(size * space[0], size * space[1], size, size);
      }
    }
    gfx.lineStyle();
    gfx.endFill();
  }

}

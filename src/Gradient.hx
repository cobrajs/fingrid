package ;

import cobraui.graphics.Color;

typedef Stop = {
  var color : Color;
  var pos : Float;
}

class Gradient {
  public var colorStops:Array<Stop>;

  public function new(startColor:Color, endColor:Color) {
    colorStops = new Array<Stop>();

    addStop(startColor, 0);
    addStop(endColor, 1);
  }

  public function addStop(color:Color, pos:Float) {
    var insertPos:Int = -1;
    var tempStop:Stop = {
      color : color,
      pos   : pos
    };
    for (i in 0...colorStops.length) {
      if (colorStops[i].pos > pos) {
        insertPos = i;
      }
    }
    if (insertPos != -1) {
      colorStops.insert(insertPos, tempStop);
    } else {
      colorStops.push(tempStop);
    }
  }

  public function getColor(pos:Float):Color {
    for (i in 0...colorStops.length) {
      if (pos == colorStops[i].pos) {
        return colorStops[i].color;
      } else if (pos < colorStops[i].pos) {
        return getColorPart(colorStops[i - 1].color, colorStops[i].color, (colorStops[i - 1].pos - pos) / (colorStops[i].pos - colorStops[i - 1].pos));
      }
    }
    return colorStops[colorStops.length - 1].color;
  }

  public function getColorPart(color1:Color, color2:Color, percent:Float):Color {
    var retColor = new Color(0x000000);
    retColor.r = Std.int(color1.r + ((color1.r - color2.r) * percent));
    retColor.g = Std.int(color1.g + ((color1.g - color2.g) * percent));
    retColor.b = Std.int(color1.b + ((color1.b - color2.b) * percent));
    return retColor;
  }
}

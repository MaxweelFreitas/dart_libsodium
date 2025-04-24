void main() {
  print('colors 0-16 correspond to the ANSI and aixterm naming');
  for (var code = 0; code < 16; code++) {
    int level;
    if (code > 8) {
      level = 255;
    } else if (code == 7) {
      level = 229;
    } else {
      level = 205;
    }

    int r, g, b;

    if (code == 8) {
      r = g = b = 127;
    } else if (code == 4) {
      r = 238;
      g = 0;
      b = 0;
    } else if (code == 12) {
      r = g = 92;
      b = 0;
    } else {
      r = (code & 1) != 0 ? level : 0;
      g = (code & 2) != 0 ? level : 0;
      b = (code & 4) != 0 ? level : 0;
    }

    var color =
        '\x1B[38;2;$r;$g;${b}m██\x1B[0m'; // ANSI escape sequence for color
    print(
      "${code.toString().padLeft(3, '0')} $color ${r.toRadixString(16).padLeft(2, '0').toUpperCase()} "
      "${g.toRadixString(16).padLeft(2, '0').toUpperCase()} "
      "${b.toRadixString(16).padLeft(2, '0').toUpperCase()}",
    );
  }

  print('colors 16-231 are a 6x6x6 color cube');
  for (var red = 0; red < 6; red++) {
    for (var green = 0; green < 6; green++) {
      for (var blue = 0; blue < 6; blue++) {
        var code = 16 + (red * 36) + (green * 6) + blue;
        var r = red != 0 ? red * 40 + 55 : 0;
        var g = green != 0 ? green * 40 + 55 : 0;
        var b = blue != 0 ? blue * 40 + 55 : 0;

        var color =
            '\x1B[38;2;$r;$g;${b}m██\x1B[0m'; // ANSI escape sequence for color
        print(
          "${code.toString().padLeft(3, '0')} $color ${r.toRadixString(16).padLeft(2, '0').toUpperCase()} "
          "${g.toRadixString(16).padLeft(2, '0').toUpperCase()} "
          "${b.toRadixString(16).padLeft(2, '0').toUpperCase()}",
        );
      }
    }
  }

  print(
    'colors 232-255 are a grayscale ramp, intentionally leaving out black and white',
  );
  for (var gray = 0; gray < 24; gray++) {
    var level = gray * 10 + 8;
    var code = 232 + gray;
    var color =
        '\x1B[38;2;$level;$level;${level}m██\x1B[0m'; // ANSI escape sequence for color
    print(
      "${code.toString().padLeft(3, '0')} $color ${level.toRadixString(16).padLeft(2, '0').toUpperCase()} "
      "${level.toRadixString(16).padLeft(2, '0').toUpperCase()} "
      "${level.toRadixString(16).padLeft(2, '0').toUpperCase()}",
    );
  }
}

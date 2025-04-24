///## XTermColor
///
///
/// ```dart
/// [XTermColor]
/// ```
/// The class provides a comprehensive set of named colors in the xterm-256color
/// palette and utility methods to convert RGB and HEX colors into ANSI escape
/// sequences for coloring text in terminals.
// ignore_for_file: avoid_classes_with_only_static_members

library;
// ignore_for_file: unintended_html_in_doc_comment

class XTermColor {
  /// Represents the ANSI escape sequence for reset colors.
  static const reset = '\x1B[0m';

  // ForegroundColors

  //~~~~~~~~~~~ Default elegant colors codes ~~~~~~~~~~~~~
  /// Represents the ANSI escape sequence for the foreground color  bright orang.
  static const main = '\x1B[38;2;255;165;0m';

  /// Represents the ANSI escape sequence for the foreground color orangeRed.
  static const orangeRed = '\x1B[38;2;255;135;0m';

  /// Represents the ANSI escape sequence for the foreground color limeGreen.
  static const limeGreen = '\x1B[38;2;50;205;50m';

  //~~~~~~~~~~~ Default colors codes ~~~~~~~~~~~~~~~~~~~~~
  /// Represents the ANSI escape sequence for the foreground color black.
  static const black = '\x1B[30m';

  /// Represents the ANSI escape sequence for the foreground color red.
  static const red = '\x1B[31m';

  /// Represents the ANSI escape sequence for the foreground color green.
  static const green = '\x1B[32m';

  /// Represents the ANSI escape sequence for the foreground color yellow.
  static const yellow = '\x1B[33m';

  /// Represents the ANSI escape sequence for the foreground color blue.
  static const blue = '\x1B[34m';

  /// Represents the ANSI escape sequence for the foreground color magenta.
  static const magenta = '\x1B[35m';

  /// Represents the ANSI escape sequence for the foreground color cyan.
  static const cyan = '\x1B[36m';

  /// Represents the ANSI escape sequence for the foreground color white.
  static const white = '\x1B[37m';

  // Bright Colors
  /// Represents the ANSI escape sequence for the foreground color bright black.
  static const blackBright = '\x1B[90m';

  /// Represents the ANSI escape sequence for the foreground color bright red.
  static const redBright = '\x1B[91m';

  /// Represents the ANSI escape sequence for the foreground color bright green.
  static const greenBright = '\x1B[92m';

  /// Represents the ANSI escape sequence for the foreground color bright yellow.
  static const yellowBright = '\x1B[93m';

  /// Represents the ANSI escape sequence for the foreground color bright blue.
  static const blueBright = '\x1B[94m';

  /// Represents the ANSI escape sequence for the foreground color bright magenta.
  static const magentaBright = '\x1B[95m';

  /// Represents the ANSI escape sequence for the foreground color bright cyan. -> \x1B[38;2;0;255;255m
  static const cyanBright = '\x1B[96m';

  /// Represents the ANSI escape sequence for the foreground color bright white.
  static const whiteBright = '\x1B[97m';

  //BackgroundColors
  /// Represents the ANSI escape sequence for the background color black.
  static const blackBg = '\x1B[40m';

  /// Represents the ANSI escape sequence for the background color red.
  static const redBg = '\x1B[41m';

  /// Represents the ANSI escape sequence for the background color green.
  static const greenBg = '\x1B[42m';

  /// Represents the ANSI escape sequence for the background color yellow.
  static const yellowBg = '\x1B[43m';

  /// Represents the ANSI escape sequence for the background color blue.
  static const blueBg = '\x1B[44m';

  /// Represents the ANSI escape sequence for the background color magenta.
  static const magentaBg = '\x1B[45m';

  /// Represents the ANSI escape sequence for the background color cyan.
  static const cyanBg = '\x1B[46m';

  /// Represents the ANSI escape sequence for the background color white.
  static const whiteBg = '\x1B[47m';

  // Bright
  /// Represents the ANSI escape sequence for the background color bright black.
  static const blackBrightBg = '\x1B[100m';

  /// Represents the ANSI escape sequence for the background color bright red.
  static const redBrightBg = '\x1B[101m';

  /// Represents the ANSI escape sequence for the background color bright green.
  static const greenBrightBg = '\x1B[102m';

  /// Represents the ANSI escape sequence for the background color bright yellow.
  static const yellowBrightBg = '\x1B[103m';

  /// Represents the ANSI escape sequence for the background color bright blue.
  static const blueBrightBg = '\x1B[104m';

  /// Represents the ANSI escape sequence for the background color bright magenta.
  static const magentaBrightBg = '\x1B[105m';

  /// Represents the ANSI escape sequence for the background color bright cyan.
  static const cyanBrightBg = '\x1B[106m';

  /// Represents the ANSI escape sequence for the background color bright white.
  static const whiteBrightBg = '\x1B[107m';

  /// Converts a color code from the xterm-256color palette to a foreground ANSI escape sequence.
  ///
  /// [codeColor] - The color code (0-255) from the xterm-256color palette.
  /// Returns a string representing the ANSI escape sequence for the specified foreground color.
  /// Like this:
  ///
  /// \x1B[38;5;<FG COLOR>m
  ///
  static String std256FG(final int codeColor) {
    if (codeColor < 0) {
      return 'std256FG color is invalid! [needs to be Grater and then 0]';
    } else if (codeColor > 255) {
      return 'std256FG color is invalid![needs to be less than 256]';
    } else {
      return '\x1B[38;5;${codeColor}m';
    }
  }

  /// Converts a color code from the xterm-256color palette to a background ANSI escape sequence.
  ///
  /// [codeColor] - The color code (0-255) from the xterm-256color palette.
  /// Returns a string representing the ANSI escape sequence for the specified background color.
  ///
  /// \x1B[48;5;<BG COLOR>m
  ///
  static String std256BG(final int codeColor) {
    if (codeColor < 0) {
      return 'std256BG color is invalid! [needs to be Grater and then 0]';
    } else if (codeColor > 255) {
      return 'std256BG color is invalid![needs to be less than 256]';
    } else {
      return '\x1B[48;5;${codeColor}m';
    }
  }

  /// Converts RGB values to a foreground ANSI escape sequence.
  ///
  /// [red]   - The red component of the color (0-255).
  /// [green] - The green component of the color (0-255).
  /// [blue]  - The blue component of the color (0-255).
  /// Returns a string representing the ANSI escape sequence for the specified RGB foreground color.
  ///
  /// '\x1B[38;2;<red>;<green>;<blue>m'
  ///
  static String rgbFg(final int red, final int green, final int blue) {
    if (red < 0) {
      return 'Red color is invalid! [needs to be Grater and then 0]';
    } else if (red > 255) {
      return 'Red color is invalid![needs to be less than 256]';
    } else if (green < 0) {
      return 'Green color is invalid! [needs to be Grater and then 0]';
    } else if (green > 255) {
      return 'Green color is invalid![needs to be less than 256]';
    } else if (blue < 0) {
      return 'Blue color is invalid! [needs to be Grater and then 0]';
    } else if (blue > 255) {
      return 'Blue color is invalid![needs to be less than 256]';
    } else {
      return '\x1B[38;2;$red;$green;${blue}m';
    }
  }

  /// Converts RGB values to a background ANSI escape sequence.
  ///
  /// [red] - The red component of the color (0-255).
  /// [green] - The green component of the color (0-255).
  /// [blue] - The blue component of the color (0-255).
  /// Returns a string representing the ANSI escape sequence for the specified RGB background color.
  ///
  /// '\x1B[48;2;<red>;<green>;<blue>m'
  ///
  static String rgbBg(final int red, final int green, final int blue) {
    if (red < 0) {
      return 'Red color is invalid! [needs to be Grater and then 0]';
    } else if (red > 255) {
      return 'Red color is invalid![needs to be less than 256]';
    } else if (green < 0) {
      return 'Green color is invalid! [needs to be Grater and then 0]';
    } else if (green > 255) {
      return 'Green color is invalid![needs to be less than 256]';
    } else if (blue < 0) {
      return 'Blue color is invalid! [needs to be Grater and then 0]';
    } else if (blue > 255) {
      return 'Blue color is invalid![needs to be less than 256]';
    } else {
      return '\x1B[48;2;$red;$green;${blue}m';
    }
  }

  /// Converts a HEX color code to a foreground ANSI escape sequence.
  ///
  /// [hexColor] - The HEX color code (e.g., '#FF5733', '0xFF5733', etc.).
  /// Returns a string representing the ANSI escape sequence for the specified HEX foreground color.
  /// from following formats
  /// #RRGGBB, 0xRRGGBB, &HRRGGBB, RRGGBBh, #RGB, 0xRGB, 0xAARRGGBB
  ///
  static String hexFg(final String hexColor) {
    String cleanedColor = hexColor;

    // Remove diferentes prefixos e caracteres não essenciais
    if (hexColor.startsWith('#')) {
      cleanedColor = hexColor.substring(1);
    } else if (hexColor.startsWith('0x')) {
      cleanedColor = hexColor.substring(2);
    } else if (hexColor.startsWith('&H')) {
      cleanedColor = hexColor.substring(2);
    } else if (hexColor.endsWith('h')) {
      cleanedColor = hexColor.substring(0, hexColor.length - 1);
    } else {
      return 'FormatException: Invalid hexdecimal format';
    }

    // Expand shorthand #RGB to #RRGGBB
    if (cleanedColor.length == 3) {
      cleanedColor = cleanedColor.split('').map((final c) => '$c$c').join();
    }

    // Handle #RGBA and #RRGGBBAA formats by stripping the alpha channel
    if (cleanedColor.length == 4) {
      cleanedColor = cleanedColor
          .split('')
          .map((final c) => '$c$c')
          .join()
          .substring(0, 6); // Ignore the first two characters (alpha)
    } else if (cleanedColor.length == 8) {
      cleanedColor = cleanedColor.substring(
        2,
      ); // Ignore the first two characters (alpha)
    }

    // Ensure the cleanedColor is now 6 characters long
    if (cleanedColor.length != 6) {
      throw ArgumentError('Invalid hexColor format');
    }

    // Convert hex to RGB
    int red = int.parse(cleanedColor.substring(0, 2), radix: 16);
    int green = int.parse(cleanedColor.substring(2, 4), radix: 16);
    int blue = int.parse(cleanedColor.substring(4, 6), radix: 16);

    return '\x1B[38;2;$red;$green;${blue}m';
  }

  /// Converts a HEX color code to a background ANSI escape sequence.
  ///
  /// [hexColor] - The HEX color code (e.g., '#FF5733', '0xFF5733', etc.).
  /// Returns a string representing the ANSI escape sequence for the specified HEX background color.
  /// /// from following formats
  /// #RRGGBB, 0xRRGGBB, &HRRGGBB, RRGGBBh, #RGB, 0xRGB, 0xAARRGGBB
  ///
  static String hexBg(final String hexColor) {
    String cleanedColor = hexColor;

    // Remove diferentes prefixos e caracteres não essenciais
    if (hexColor.startsWith('#')) {
      cleanedColor = hexColor.substring(1);
    } else if (hexColor.startsWith('0x')) {
      cleanedColor = hexColor.substring(2);
    } else if (hexColor.startsWith('&H')) {
      cleanedColor = hexColor.substring(2);
    } else if (hexColor.endsWith('h')) {
      cleanedColor = hexColor.substring(0, hexColor.length - 1);
    } else {
      return 'FormatException: Invalid hexdecimal format';
    }

    // Expand shorthand #RGB to #RRGGBB
    if (cleanedColor.length == 3) {
      cleanedColor = cleanedColor.split('').map((final c) => '$c$c').join();
    }

    // Handle #RGBA and #RRGGBBAA formats by stripping the alpha channel
    if (cleanedColor.length == 4) {
      cleanedColor = cleanedColor
          .split('')
          .map((final c) => '$c$c')
          .join()
          .substring(0, 6); // Ignore the first two characters (alpha)
    } else if (cleanedColor.length == 8) {
      cleanedColor = cleanedColor.substring(
        2,
      ); // Ignore the first two characters (alpha)
    }

    // Ensure the cleanedColor is now 6 characters long
    if (cleanedColor.length != 6) {
      throw ArgumentError('Invalid hexColor format');
    }

    // Convert hex to RGB
    int red = int.parse(cleanedColor.substring(0, 2), radix: 16);
    int green = int.parse(cleanedColor.substring(2, 4), radix: 16);
    int blue = int.parse(cleanedColor.substring(4, 6), radix: 16);

    return '\x1B[48;2;$red;$green;${blue}m';
  }

  static String printColors() {
    var tableColor = StringBuffer();
    //Standard Colors
    tableColor.writeln(
      'Standard Colors                             High-intensity Colors',
    );
    for (var i = 0; i <= 7; i++) {
      if (i < 10) {
        tableColor.write('${std256BG(i)}  ${std256FG(7)}$i  $reset');
      }
    }
    tableColor.write('    ');
    //High-intensity Colors
    for (var i = 8; i <= 15; i++) {
      if (i < 10) {
        tableColor.write('${std256BG(i)}  ${std256FG(7)}$i  $reset');
      } else {
        tableColor.write('${std256BG(i)}  ${std256FG(7)}$i  $reset');
      }
    }
    tableColor.write('\n\n');

    //
    tableColor.writeln('Left');
    List<List<int>> rangesFirstLoop = [
      [16, 33], [52, 69], [88, 105], [124, 141], [160, 177], [196, 213], //
    ];

    for (var range in rangesFirstLoop) {
      for (var j = range[0]; j <= range[1]; j++) {
        var formattedNumber = j.toString().padLeft(3, '0');
        tableColor.write(
          '${std256BG(j)} ${std256FG(7)}$formattedNumber $reset',
        );
      }
      tableColor.write('\n');
    }
    tableColor.write('\n');
    tableColor.writeln('Right');
    List<List<int>> rangesSecondLoop = [
      [34, 51], [70, 87], [106, 123], [142, 159], [178, 195], [214, 231], //
    ];

    for (var range in rangesSecondLoop) {
      for (var j = range[0]; j <= range[1]; j++) {
        var formattedNumber = j.toString().padLeft(3, '0');
        tableColor.write(
          '${std256BG(j)} ${std256FG(0)}$formattedNumber $reset',
        );
      }
      tableColor.write('\n');
    }
    tableColor.write('\n');
    //GrayScale
    tableColor.writeln('Gray Scale Color');
    for (var i = 232; i <= 243; i++) {
      tableColor.write('${std256BG(i)}  ${std256FG(7)}$i  $reset');
    }
    tableColor.write('\n');
    for (var i = 244; i <= 255; i++) {
      tableColor.write('${std256BG(i)}  ${std256FG(0)}$i  $reset');
    }
    tableColor.write('\n\n');
    return tableColor.toString();
  }
}

import 'package:flutter/widgets.dart';

enum WindowSizeClass {
  compact, // < 600
  medium, // 600 - 839
  expanded, // >= 840
}

class WindowSizeHelper {
  static WindowSizeClass fromWidth(double width) {
    if (width < 600) {
      return WindowSizeClass.compact;
    } else if (width < 840) {
      return WindowSizeClass.medium;
    } else {
      return WindowSizeClass.expanded;
    }
  }

  static WindowSizeClass of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return fromWidth(width);
  }
}

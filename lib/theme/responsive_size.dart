import 'package:flutter/widgets.dart';

class ScreenUtils {
  static double getHeight(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }

  static double getWidth(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }
}

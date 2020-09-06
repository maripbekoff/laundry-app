import 'package:flutter/cupertino.dart';

class CustomThemeData {
  CupertinoThemeData theme = CupertinoThemeData(
      brightness: Brightness.light,
      barBackgroundColor: Color(0xFFFFFFFF),
      scaffoldBackgroundColor: Color(0xFFF8F8FB),
      textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(
          fontFamily: 'Museo Sans Cyrilic',
          color: Color(0xFF000000),
        ),
      ));

  TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  TextStyle description = TextStyle(
    fontSize: 14,
    color: CupertinoColors.inactiveGray,
  );

  TextStyle itemName = TextStyle(
    fontSize: 14,
    color: CupertinoColors.inactiveGray,
  );
}

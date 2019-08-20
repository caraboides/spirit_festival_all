import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

CrossAxisAlignment stageAlignment(String stage) {
  switch (stage) {
    case 'Mainstage':
      return CrossAxisAlignment.start;
    case 'Stage II':
      return CrossAxisAlignment.end;
    default:
      return CrossAxisAlignment.center;
  }
}

ImmortalList<DateTime> get days => ImmortalList<DateTime>([
      DateTime(2019, 8, 29),
      DateTime(2019, 8, 30),
      DateTime(2019, 8, 31),
    ]);

Duration daySwitchOffset = Duration(hours: 3);

const String festivalName = 'Spirit';
const String festivalFullName = 'Spirit Festival 2019';
const String festivalFirestoreKey = 'spirit_2019';

const String geoLocationQuery = 'lat=51.59&lon=12.59';
const String weatherCityId = '6547727';

class FestivalTheme {
  static final ThemeData theme = ThemeData(
    primaryColor: Color(0xFF15928c),
    accentColor: Color(0xFFbafb00),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.normal,
    ),
    textTheme: Typography.blackMountainView.copyWith(
      headline: TextStyle(
        fontFamily: 'No Continue',
        fontSize: 28,
        color: Colors.black,
      ),
      display1: TextStyle(
        fontFamily: 'No Continue',
        fontSize: 26,
        color: Colors.white,
        shadows: _createShadows(Colors.black),
      ),
      title: TextStyle(
        fontFamily: 'No Continue',
        fontSize: 24,
        color: Colors.black,
      ),
    ),
  );

  static final Color menuBackgroundColor = Colors.grey[850];
  static final Color dividerColor = Colors.grey[800];
  static final Color menuFontColor = Color(0xFFd6102b);
  static final Color menuIconColor = menuFontColor.withOpacity(0.87);
  static final Color aboutBackgroundColor = Colors.grey[850];

  static final TextStyle appBarTextStyle = theme.textTheme.display1;
  static final TextStyle bandNameTextStyle = theme.textTheme.headline;
  static final TextStyle bandDetailTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
  );
  static const TextStyle eventBandTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
  );
  static const TextStyle eventDateTextStyle = TextStyle(
    fontSize: 12,
    color: Colors.black54,
  );
  static const TextStyle eventStageTextStyle = TextStyle(
    fontSize: 12,
    color: Colors.black87,
  );
  static final TextStyle menuEntryTextStyle = theme.textTheme.title.copyWith(
    color: menuFontColor,
  );
  static final BoxDecoration menuDrawerDecoration = BoxDecoration(
    border: Border(
      right: BorderSide(width: 2, color: Colors.black),
    ),
    color: menuBackgroundColor,
  );

  static List<Shadow> _createShadows(Color color) => [
        Shadow(
          blurRadius: 1.0,
          color: color,
          offset: Offset(1.0, 1.0),
        ),
        Shadow(
          blurRadius: 1.0,
          color: color,
          offset: Offset(1.0, -1.0),
        ),
        Shadow(
          blurRadius: 1.0,
          color: color,
          offset: Offset(-1.0, 1.0),
        ),
        Shadow(
          blurRadius: 1.0,
          color: color,
          offset: Offset(2.0, 2.0),
        ),
        Shadow(
          blurRadius: 1.0,
          color: color,
          offset: Offset(-1.0, -1.0),
        ),
      ];

  static MaterialButton primaryButton({String label, VoidCallback onPressed}) =>
      FlatButton(
        shape: Border(
          top: BorderSide(color: Colors.black, width: 1),
          left: BorderSide(color: Colors.black, width: 1),
          bottom: BorderSide(color: Colors.black, width: 2),
          right: BorderSide(color: Colors.black, width: 2),
        ),
        color: theme.accentColor,
        onPressed: onPressed,
        child: Text(label),
      );

  static AppBar appBar(String title) => AppBar(
        title: Text(
          title,
          style: FestivalTheme.appBarTextStyle,
        ),
        //elevation: 0,
        shape: Border(
          bottom: BorderSide(color: Colors.black, width: 2),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

CrossAxisAlignment stageAlignment(String stage) =>
    stage == 'Mainstage' ? CrossAxisAlignment.start : CrossAxisAlignment.end;

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
    primaryColor: Color(0xFFa5ab62),
    accentColor: Color(0xFFffa035),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
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
}

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
    primaryColor: Colors.grey[850],
    accentColor: Color(0xFFD2D522),
    textTheme: Typography.blackMountainView.copyWith(
      headline: TextStyle(
        fontFamily: 'Pirata One',
        fontSize: 28,
        color: Colors.black,
      ),
      display1: TextStyle(
        fontFamily: 'Pirata One',
        fontSize: 26,
        color: Colors.white,
      ),
      title: TextStyle(
        fontFamily: 'Pirata One',
        fontSize: 24,
        color: Colors.black,
      ),
    ),
  );

  static final Color menuBackgroundColor = theme.primaryColor;
  static final Color menuIconColor = theme.accentColor.withOpacity(0.87);
  static final Color dividerColor = Colors.grey[800];

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
    color: theme.accentColor,
  );
}

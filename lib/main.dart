import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'about.dart';
import 'band.dart';
import 'drive.dart';
import 'faq.dart';
import 'festival_config.dart';
import 'home.dart';
import 'i18n.dart';
import 'initialization.dart';
import 'my_schedule.dart';
import 'notifications.dart';
import 'schedule.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp();

  void _precacheImages(BuildContext context) {
    precacheImage(
      AssetImage('assets/icon_menu.png'),
      context,
      size: Size(304, 152),
    );
  }

  @override
  Widget build(BuildContext context) {
    _precacheImages(context);
    initializeNotifications();
    return ScheduleProvider(
      child: MyScheduleProvider(
        child: BandsProvider(
          child: MaterialApp(
            title: festivalName,
            theme: FestivalTheme.theme,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('de', 'DE'),
            ],
            home: InitializationWidget(
              child: HomeScreen(),
            ),
            routes: {
              'home': (context) => HomeScreen(),
              'mySchedule': (context) => HomeScreen(favoritesOnly: true),
              'drive': (context) => Drive(),
              'faq': (context) => FAQ(),
              'about': (context) => About(),
            },
          ),
        ),
      ),
    );
  }
}

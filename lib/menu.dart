import 'package:flutter/material.dart';
import 'package:spirit/festival_config.dart';
import 'package:url_launcher/url_launcher.dart';

import 'i18n.dart';

class Menu extends StatelessWidget {
  const Menu();

  bool _isHomeScreen(Route route) =>
      route.settings.name == '/' ||
      route.settings.name == 'home' ||
      route.settings.name == 'mySchedule';

  void _pushOnHome(NavigatorState navigator, String routeName) {
    navigator.pop();
    navigator.pushNamedAndRemoveUntil(
      routeName,
      _isHomeScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    return Drawer(
      child: Container(
        color: FestivalTheme.menuBackgroundColor,
        child: ListView(
          children: <Widget>[
            Image.asset(
              'assets/icon_menu.png',
              height: 300,
            ),
            ListTile(
              title: Text(
                i18n.schedule,
                style: FestivalTheme.menuEntryTextStyle,
              ),
              leading: Icon(
                Icons.calendar_today,
                color: FestivalTheme.menuIconColor,
              ),
              onTap: () {
                navigator.popUntil(_isHomeScreen);
                navigator.pushReplacementNamed('home');
              },
            ),
            ListTile(
              title: Text(
                i18n.mySchedule,
                style: FestivalTheme.menuEntryTextStyle,
              ),
              leading: Icon(
                Icons.star,
                color: FestivalTheme.menuIconColor,
              ),
              onTap: () {
                navigator.popUntil(_isHomeScreen);
                navigator.pushReplacementNamed('mySchedule');
              },
            ),
            ListTile(
              title: Text(
                i18n.drive,
                style: FestivalTheme.menuEntryTextStyle,
              ),
              leading: Icon(
                Icons.map,
                color: FestivalTheme.menuIconColor,
              ),
              onTap: () => _pushOnHome(navigator, 'drive'),
            ),
            ListTile(
              title: Text(
                i18n.faq,
                style: FestivalTheme.menuEntryTextStyle,
              ),
              leading: Icon(
                Icons.help,
                color: FestivalTheme.menuIconColor,
              ),
              onTap: () => _pushOnHome(navigator, 'faq'),
            ),
            ListTile(
              title: Text(
                i18n.about,
                style: FestivalTheme.menuEntryTextStyle,
              ),
              leading: Icon(
                Icons.info,
                color: FestivalTheme.menuIconColor,
              ),
              onTap: () => _pushOnHome(navigator, 'about'),
            ),
            ListTile(
              title: Text(
                i18n.privacyPolicy,
                style: FestivalTheme.menuEntryTextStyle,
              ),
              leading: Icon(
                Icons.verified_user,
                color: FestivalTheme.menuIconColor,
              ),
              onTap: () => launch("https://bit.ly/2YNzXmR"),
            ),
          ],
        ),
      ),
    );
  }
}

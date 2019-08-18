import 'dart:async';

import 'package:flutter/material.dart';

import 'event_detail_view.dart';
import 'event_list_view.dart';
import 'festival_config.dart';
import 'i18n.dart';
import 'menu.dart';
import 'model.dart';
import 'schedule.dart';
import 'weather.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({this.favoritesOnly = false});

  final bool favoritesOnly;

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Timer _rebuildTimer;
  bool favoritesOnly = false;

  @override
  void initState() {
    super.initState();
    favoritesOnly = widget.favoritesOnly;
    WidgetsBinding.instance.addObserver(this);
    _rebuildTimer = _createTimer();
  }

  @override
  void dispose() {
    _rebuildTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.suspending:
        _rebuildTimer.cancel();
        break;
      case AppLifecycleState.resumed:
        _rebuild();
        _rebuildTimer = _createTimer();
        break;
    }
  }

  Timer _createTimer() =>
      Timer.periodic(Duration(minutes: 1), (_) => _rebuild());

  void _rebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onFavoritesFilterChange(bool newValue) {
    setState(() {
      favoritesOnly = newValue;
    });
  }

  void _openEventDetails(BuildContext context, Event event) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EventDetailView(event),
      fullscreenDialog: true,
    ));
  }

  Widget _buildEventList(BuildContext context, {DateTime date}) => Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (date != null) WeatherWidget(date),
          EventListView(
            eventFilter:
                date != null ? Schedule.dayOf(date) : Schedule.allBandsOf,
            bandView: date == null,
            openEventDetails: (event) => _openEventDetails(context, event),
            favoritesOnly: favoritesOnly,
          ),
        ],
      );

  int get _initialTab {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final index = days.indexOf(startOfDay);
    if (index >= 0) {
      return index + 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 4,
      initialIndex: _initialTab,
      child: Scaffold(
        drawer: const Menu(),
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: i18n.bands),
              ...List.generate(
                days.length,
                (index) => Tab(text: i18n.dayTitle(index + 1)),
              ),
            ],
          ),
          title: Image.asset(
            'assets/logo.png',
            width: 111,
            height: 56,
          ),
          /*Text(
            festivalName,
            style: FestivalTheme.appBarTextStyle,
          ),*/
          actions: <Widget>[
            Icon(favoritesOnly ? Icons.star : Icons.star_border),
            Switch(
              value: favoritesOnly,
              onChanged: _onFavoritesFilterChange,
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildEventList(context),
            ...days
                .map((date) => _buildEventList(context, date: date))
                .toMutableList(),
          ],
        ),
      ),
    );
  }
}

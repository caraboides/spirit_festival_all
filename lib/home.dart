import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spirit/utils.dart';

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
            date: date,
            openEventDetails: (event) => _openEventDetails(context, event),
            favoritesOnly: favoritesOnly,
          ),
        ],
      );

  int get _initialTab {
    final now = DateTime.now();
    return days.indexWhere(
          (day) => isSameDay(now, day, offset: daySwitchOffset),
        ) +
        1;
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
              Tab(
                child: Text(
                  i18n.bands,
                  style: FestivalTheme.tabTextStyle,
                ),
              ),
              ...List.generate(
                days.length,
                (index) => Tab(
                  child: Text(
                    i18n.dayTitle(index + 1),
                    style: FestivalTheme.tabTextStyle,
                  ),
                ),
              ),
            ],
          ),
          title: Image.asset(
            'assets/logo.png',
            width: 158,
            height: 40,
          ),
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

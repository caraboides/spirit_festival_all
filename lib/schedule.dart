import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';

import 'app_storage.dart' as appStorage;
import 'festival_config.dart';
import 'model.dart';
import 'utils.dart';

typedef EventFilter = ImmortalList<Event> Function(BuildContext context);

const appStorageKey = 'schedule.json';

class Schedule extends InheritedWidget {
  const Schedule({
    @required Widget child,
    Key key,
    this.events,
    this.updatedEvents,
  }) : super(key: key, child: child);

  final ImmortalList<Event> events;
  final ImmortalList<Event> updatedEvents;

  static Schedule of(BuildContext context) {
    final Schedule schedule = context.inheritFromWidgetOfExactType(Schedule);
    return schedule;
  }

  static ImmortalList<Event> allBandsOf(BuildContext context) =>
      of(context).events.sort((a, b) => a.bandName.compareTo(b.bandName));

  static EventFilter dayOf(DateTime date) => (context) => of(context)
      .events
      .where((item) => isSameDay(item.start, date, offset: daySwitchOffset))
      .sort((a, b) => a.start.compareTo(b.start));

  @override
  bool updateShouldNotify(Schedule oldWidget) => oldWidget.events != events;
}

class ScheduleProvider extends StatefulWidget {
  const ScheduleProvider({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  ScheduleProviderState createState() => ScheduleProviderState();
}

class ScheduleProviderState extends State<ScheduleProvider> {
  Future<ImmortalList<Event>> _loadInitialData() async {
    return appStorage.loadJson(appStorageKey).then((onValue) {
      if (onValue.isPresent) {
        return Future.value(_parseJsonEvents(onValue.value));
      }
      return _loadFallbackData();
    });
  }

  Future<ImmortalList<Event>> _loadFallbackData() =>
      DefaultAssetBundle.of(context)
          .loadString('assets/initial_schedule.json')
          .then<ImmortalList<Event>>((v) => _parseJsonEvents(jsonDecode(v)));

  Future<Optional<ImmortalList<Event>>> _loadRemoteData() async {
    final response = await http.get(
        'https://lilafestivalhub.herokuapp.com/schedule?festival=$festivalId');
    if (response.statusCode == 200) {
      final Map<String, dynamic> json =
          jsonDecode(utf8.decode(response.bodyBytes));
      appStorage.storeJson(appStorageKey, json);
      return Optional.of(_parseJsonEvents(json));
    }
    return Optional.empty();
  }

  ImmortalList<Event> _parseJsonEvents(Map<String, dynamic> jsonMap) =>
      ImmortalMap<String, dynamic>(jsonMap).mapEntries<Event>(_parseJsonEvent);

  Event _parseJsonEvent(String id, dynamic data) => Event(
        bandName: data['band'],
        id: id,
        stage: data['stage'],
        start: DateTime.parse(data['start']),
        end: DateTime.parse(data['end']),
      );

  /// List of events
  ImmortalList<Event> _events = ImmortalList<Event>.empty();
  ImmortalList<Event> _updatedEvents = ImmortalList<Event>.empty();

  @override
  void initState() {
    super.initState();
    _loadInitialData().then((newEvents) {
      _loadRemoteData().then((remoteEvents) {
        if (remoteEvents.isPresent) {
          setState(() {
            _events = remoteEvents.value;
          });
        }
      });
      setState(() {
        _events = newEvents;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Schedule(
        events: _events,
        updatedEvents: _updatedEvents,
        child: widget.child,
      );
}

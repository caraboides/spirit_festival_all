import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import 'festival_config.dart';
import 'firestore.dart';
import 'model.dart';
import 'utils.dart';

typedef EventFilter = ImmortalList<Event> Function(BuildContext context);

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
    this.firestore,
  }) : super(key: key);

  final Widget child;
  final Firestore firestore;

  @override
  ScheduleProviderState createState() => ScheduleProviderState();
}

class ScheduleProviderState extends State<ScheduleProvider> {
  Future<ImmortalList<Event>> _loadInitialData() async {
    final firebaseData = await loadData(widget.firestore, 'schedule');
    final events = firebaseData.collection.isEmpty
        ? await _loadFallbackData()
        : _parseEvents(firebaseData.collection);
    _updatedEvents = _parseEvents(firebaseData.updates);
    final updatedEventIds =
        _updatedEvents.map<String>((event) => event.id).toSet();
    return events
        .removeWhere((event) => updatedEventIds.contains(event.id))
        .addAll(_updatedEvents);
  }

  Future<ImmortalList<Event>> _loadFallbackData() =>
      DefaultAssetBundle.of(context)
          .loadString('assets/initial_schedule.json')
          .then<ImmortalList<Event>>((v) => _parseJsonEvents(jsonDecode(v)));

  Event _buildEventFromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data;
    return Event(
      bandName: data['band'],
      id: snapshot.documentID,
      stage: data['stage'],
      start: data['start'].toDate(),
      end: data['end'].toDate(),
    );
  }

  ImmortalList<Event> _parseEvents(List<DocumentSnapshot> snapshots) =>
      ImmortalList(snapshots.map(_buildEventFromSnapshot));

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

import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'app_storage.dart' as appStorage;
import 'i18n.dart';
import 'model.dart';
import 'notifications.dart';

const _myScheduleFileName = 'my_schedule.txt';
typedef ToggleEventFunction = void Function(AppLocalizations i18n, Event event);

class MyScheduleController extends InheritedWidget {
  const MyScheduleController({
    @required Widget child,
    Key key,
    this.mySchedule,
    this.toggleEvent,
  }) : super(key: key, child: child);

  final MySchedule mySchedule;
  final ToggleEventFunction toggleEvent;

  static MyScheduleController of(BuildContext context) {
    final MyScheduleController myScheduleWidget =
        context.inheritFromWidgetOfExactType(MyScheduleController);
    return myScheduleWidget;
  }

  @override
  bool updateShouldNotify(MyScheduleController oldWidget) =>
      mySchedule != oldWidget.mySchedule;
}

class MyScheduleProvider extends StatefulWidget {
  const MyScheduleProvider({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => MyScheduleProviderState();
}

class MyScheduleProviderState extends State<MyScheduleProvider> {
  MySchedule _mySchedule = MySchedule();
  Timer _debounce;

  @override
  void initState() {
    super.initState();
    _loadMySchedule();
  }

  Future<void> _loadMySchedule() async {
    final Map<String, dynamic> json =
        (await appStorage.loadJson(_myScheduleFileName))
            .orElse(<String, int>{});
    setState(() {
      _mySchedule = MySchedule(json.cast<String, int>());
    });
  }

  Future<void> _saveMySchedule() async {
    if (_debounce?.isActive ?? false) {
      _debounce.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 200), () {
      appStorage.storeJson(_myScheduleFileName, _mySchedule.toJson());
    });
  }

  Future<void> _toggleEvent(AppLocalizations i18n, Event event) async {
    _mySchedule.toggleEvent(
      event.id,
      onRemove: cancelNotification,
      getValueToInsert: () async => event.start.isAfter(DateTime.now())
          ? await scheduleNotificationForEvent(i18n, event)
          : 0,
      onUpdate: () {
        setState(() {
          _mySchedule = _mySchedule.createCopy();
        });
        _saveMySchedule();
      },
    );
  }

  @override
  Widget build(BuildContext context) => MyScheduleController(
        mySchedule: _mySchedule,
        child: widget.child,
        toggleEvent: _toggleEvent,
      );
}

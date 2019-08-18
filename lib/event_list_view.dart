import 'dart:math';

import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import 'festival_config.dart';
import 'i18n.dart';
import 'model.dart';
import 'my_schedule.dart';
import 'schedule.dart';

const double _listItemHeight = 70;

class EventListView extends StatefulWidget {
  const EventListView({
    Key key,
    this.eventFilter,
    this.bandView,
    this.openEventDetails,
    this.favoritesOnly,
  }) : super(key: key);

  final EventFilter eventFilter;
  final bool bandView;
  final ValueChanged<Event> openEventDetails;
  final bool favoritesOnly;

  @override
  State<StatefulWidget> createState() => EventListViewState();
}

class EventListViewState extends State<EventListView> {
  final _scrollController = ScrollController();
  bool _firstBuild = true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EventListView oldWidget) {
    if (mounted &&
        !widget.bandView &&
        widget.favoritesOnly != oldWidget.favoritesOnly) {
      _scrollToCurrentBand();
    }
    super.didUpdateWidget(oldWidget);
  }

  ImmortalList<Event> getEvents(MyScheduleController myScheduleController) =>
      widget.eventFilter(context).where((event) =>
          !widget.favoritesOnly ||
          myScheduleController.mySchedule.isEventLiked(event.id));

  void _scrollToCurrentBand(
      {Duration timeout = const Duration(milliseconds: 50)}) {
    Future.delayed(timeout, () {
      if (mounted) {
        final now = DateTime.now();
        final index = getEvents(MyScheduleController.of(context)).indexWhere(
            (event) => !now.isBefore(event.start) && !now.isAfter(event.end));
        if (index >= 0) {
          _scrollController.animateTo(
            max(index - 2, 0) * _listItemHeight,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final myScheduleController = MyScheduleController.of(context);
    final i18n = AppLocalizations.of(context);
    final now = DateTime.now();
    final events = getEvents(myScheduleController);
    final items = events.map((event) => CustomListItemTwo(
          key: Key(event.id),
          isLiked: myScheduleController.mySchedule.isEventLiked(event.id),
          bandname: event.bandName,
          start: event.start,
          stage: event.stage,
          toggleEvent: () => myScheduleController.toggleEvent(i18n, event),
          bandView: widget.bandView,
          openEventDetails: () => widget.openEventDetails(event),
          isPlaying: !now.isBefore(event.start) && !now.isAfter(event.end),
        ));
    if (widget.favoritesOnly && items.isEmpty) {
      return Expanded(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(i18n.emptyScheduleHeadline),
            ),
            Icon(Icons.star_border),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(i18n.emptySchedule),
            ),
          ],
        ),
      );
    }
    if (_firstBuild && !widget.bandView) {
      _firstBuild = false;
      _scrollToCurrentBand(timeout: Duration(milliseconds: 200));
    }
    return Expanded(
      child: ListView(
        controller: _scrollController,
        children: ListTile.divideTiles(
          context: context,
          tiles: items.toMutableList(),
        ).toList(),
      ),
    );
  }
}

class CustomListItemTwo extends StatelessWidget {
  const CustomListItemTwo({
    Key key,
    this.isLiked,
    this.bandname,
    this.start,
    this.stage,
    this.toggleEvent,
    this.bandView,
    this.openEventDetails,
    this.isPlaying,
  }) : super(key: key);

  final bool isLiked;
  final String bandname;
  final DateTime start;
  final String stage;
  final VoidCallback toggleEvent;
  final bool bandView;
  final VoidCallback openEventDetails;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Material(
      color: isPlaying ? theme.accentColor : theme.canvasColor,
      child: InkWell(
        onTap: openEventDetails,
        child: SafeArea(
          top: false,
          bottom: false,
          minimum: EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            height: _listItemHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(isLiked ? Icons.star : Icons.star_border),
                  tooltip: isLiked
                      ? i18n.removeEventFromSchedule
                      : i18n.addEventToSchedule,
                  onPressed: toggleEvent,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _EventDescription(
                      bandname: bandname,
                      start: start,
                      stage: stage,
                      bandView: bandView,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EventDescription extends StatelessWidget {
  const _EventDescription({
    Key key,
    this.bandname,
    this.start,
    this.stage,
    this.bandView,
  }) : super(key: key);

  final String bandname;
  final DateTime start;
  final String stage;
  final bool bandView;

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    final formatter = bandView ? i18n.dateTimeFormat : i18n.timeFormat;
    return Column(
      crossAxisAlignment:
          bandView ? CrossAxisAlignment.start : stageAlignment(stage),
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          bandname.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: FestivalTheme.eventBandTextStyle,
        ),
        const SizedBox(height: 4),
        Text(
          '${formatter.format(start.toLocal())}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: FestivalTheme.eventDateTextStyle,
        ),
        const SizedBox(height: 2),
        Text(
          stage,
          style: FestivalTheme.eventStageTextStyle,
        ),
      ],
    );
  }
}

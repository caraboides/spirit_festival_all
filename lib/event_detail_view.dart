import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'band.dart';
import 'festival_config.dart';
import 'i18n.dart';
import 'model.dart';
import 'my_schedule.dart';

class EventDetailView extends StatelessWidget {
  const EventDetailView(this.event);

  final Event event;

  String _buildFlag(String country) =>
      String.fromCharCodes(country.runes.map((code) => code + 127397));

  String _getDescription(AppLocalizations i18n, Locale locale, BandData data) {
    if (locale.languageCode == 'en' && data.textEn != null) {
      return data.textEn;
    }
    return data.text ?? i18n.noInfo;
  }

  List<Widget> _buildDetails(
    ThemeData theme,
    AppLocalizations i18n,
    Locale locale,
    BandData data,
  ) =>
      <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 15),
          child: Text(_getDescription(i18n, locale, data)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 75,
                child: Text(
                  '${i18n.origin}:',
                  style: FestivalTheme.bandDetailTextStyle,
                ),
              ),
              Text(data.origin != null ? _buildFlag(data.origin) : i18n.noInfo),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: data.style == null || data.style.trim() == "" ? Container(): Row(
            children: <Widget>[
              SizedBox(
                width: 75,
                child: Text(
                  '${i18n.style}:',
                  style: FestivalTheme.bandDetailTextStyle,
                ),
              ),
              Text(data.style ?? i18n.noInfo),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child:  data.roots == null || data.roots.trim() == "" ? Container():Row(
            children: <Widget>[
              SizedBox(
                width: 75,
                child: Text(
                  '${i18n.roots}:',
                  style: FestivalTheme.bandDetailTextStyle,
                ),
              ),
              Text(data.roots ?? i18n.noInfo),
            ],
          ),
        ),
        if (data.spotify != null)
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 15),
            child: FestivalTheme.primaryButton(
              label: i18n.playOnSpotify,
              onPressed: () {
                launch(data.spotify);
              },
            ),
          ),
        if (data.image != null)
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: CachedNetworkImage(
              imageUrl: data.image,
            ),
          ),
      ];

  @override
  Widget build(BuildContext context) {
    final myScheduleController = MyScheduleController.of(context);
    final i18n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final data = Bands.of(context, event.bandName);
    final isLiked = myScheduleController.mySchedule.isEventLiked(event.id);
    final locale = Localizations.localeOf(context);
    return Scaffold(
      appBar: FestivalTheme.appBar(i18n.eventDetailsHeader),
      body: Container(
        alignment: Alignment.topCenter,
        child: ListView(
          children: <Widget>[
            data
                .map<Widget>((d) => d.logo != "" && d.logo != null
                    ? Container(
                        color: Colors.black,
                        child: CachedNetworkImage(
                          imageUrl: d.logo,
                        ),
                        height: 100,
                      )
                    : Container())
                .orElse(Container()),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text(
                event.bandName.toUpperCase(),
                style: FestivalTheme.bandNameTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 20, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(isLiked ? Icons.star : Icons.star_border),
                    tooltip: isLiked
                        ? i18n.removeEventFromSchedule
                        : i18n.addEventToSchedule,
                    onPressed: () =>
                        myScheduleController.toggleEvent(i18n, event),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      '${i18n.dateTimeFormat.format(event.start.toLocal())}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FestivalTheme.eventDateTextStyle,
                    ),
                  ),
                  Text(
                    event.stage,
                    style: FestivalTheme.eventStageTextStyle,
                  ),
                ],
              ),
            ),
            ...data
                .map<List<Widget>>((d) => _buildDetails(theme, i18n, locale, d))
                .orElse(<Widget>[
              Container(
                padding: const EdgeInsets.only(
                    top: 10, left: 20, right: 20, bottom: 20),
                alignment: Alignment.center,
                child: Text(i18n.noInfo),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

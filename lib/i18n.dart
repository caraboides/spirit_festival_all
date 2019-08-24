import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const timeFormatString = 'HH:mm';
const dateTimeFormatString = 'E HH:mm';

class AppLocalizations {
  AppLocalizations({
    this.dayTitleFormat,
    this.bands,
    this.schedule,
    this.mySchedule,
    this.drive,
    this.faq,
    this.addEventToSchedule,
    this.removeEventFromSchedule,
    this.locale,
    this.eventDetailsHeader,
    this.eventNotificationFormat,
    this.about,
    this.privacyPolicy,
    this.aboutLicense,
    this.aboutCreated,
    this.noInfo,
    this.emptyScheduleHeadline,
    this.emptySchedule,
    this.origin,
    this.roots,
    this.style,
    this.playOnSpotify,
    this.weatherDataBy,
    this.fontByFormat,
    this.appDescriptionFormat,
    this.sourceCodeUnder,
    this.language,
  });
  /*: TODO(SF) why does this not work?
        this.timeFormat = DateFormat(timeFormatString, locale),
        this.dateTimeFormat = DateFormat(dateTimeFormatString, locale)*/

  final String dayTitleFormat;
  final String bands;
  final String schedule;
  final String mySchedule;
  final String drive;
  final String faq;
  final String addEventToSchedule;
  final String removeEventFromSchedule;
  final String locale;
  final String language;
  final String eventDetailsHeader;
  final String eventNotificationFormat;
  final String about;
  final String privacyPolicy;
  final String aboutLicense;
  final String aboutCreated;
  final String noInfo;
  final String emptyScheduleHeadline;
  final String emptySchedule;
  final String origin;
  final String roots;
  final String style;
  final String playOnSpotify;
  final String weatherDataBy;
  final String fontByFormat;
  final String appDescriptionFormat;
  final String sourceCodeUnder;

  // final DateFormat timeFormat;
  // final DateFormat dateTimeFormat;

  DateFormat get timeFormat => DateFormat(timeFormatString, locale);
  DateFormat get dateTimeFormat => DateFormat(dateTimeFormatString, locale);

  String eventNotification(String bandName, DateTime time, String stage) =>
      eventNotificationFormat
          .replaceAll('{band}', bandName)
          .replaceAll('{time}', timeFormat.format(time))
          .replaceAll('{stage}', stage);

  String dayTitle(int number) =>
      dayTitleFormat.replaceAll('{number}', number.toString());

  String fontBy(String fontName) => fontByFormat.replaceAll('{font}', fontName);

  String appDescription(String festivalName) =>
      appDescriptionFormat.replaceAll('{festival}', festivalName);

  static const delegate = AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture<AppLocalizations>(
          locale.languageCode == 'de' ? de : en);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

final AppLocalizations de = AppLocalizations(
  dayTitleFormat: 'Tag {number}',
  bands: 'Bands',
  schedule: 'Plan',
  mySchedule: 'Mein Plan',
  drive: 'Anfahrt',
  faq: 'FAQ',
  addEventToSchedule: 'Füge Auftritt zum Plan hinzu',
  removeEventFromSchedule: 'Entferne Auftritt vom Plan',
  locale: 'de_DE',
  language: 'de',
  eventDetailsHeader: 'Band Details',
  eventNotificationFormat: '{band} spielen um {time} auf der {stage}!',
  about: 'Über diese App',
  privacyPolicy: 'Datenschutzerklärung',
  aboutLicense: 'Copyright 2019 Projekt LilaHerz 💜',
  aboutCreated: 'Entwickelt von Projekt LilaHerz',
  noInfo: 'Sorry, keine Infos',
  emptyScheduleHeadline: 'Magst du keine Musik?',
  emptySchedule: 'Du hast noch keine Auftritte zu deinem Plan hinzugefügt!',
  origin: 'Herkunft',
  roots: 'Wurzeln',
  style: 'Stil',
  playOnSpotify: 'Reinhören bei Spotify',
  weatherDataBy: 'Wetterdaten von:',
  fontByFormat: 'Schriftart "{font}" von:',
  appDescriptionFormat: 'Dies ist eine inoffizielle App für das {festival}:',
  sourceCodeUnder: 'Der Quellcode ist hier zu finden:',
);

final AppLocalizations en = AppLocalizations(
  dayTitleFormat: 'Day {number}',
  bands: 'Bands',
  schedule: 'Schedule',
  mySchedule: 'My Schedule',
  drive: 'Location',
  faq: 'FAQ',
  addEventToSchedule: 'Add gig to schedule',
  removeEventFromSchedule: 'Remove gig from schedule',
  locale: 'en_US',
  language: 'en',
  eventDetailsHeader: 'Band Details',
  eventNotificationFormat: '{band} plays at {time} on the {stage}!',
  about: 'About',
  privacyPolicy: 'Privacy Policy',
  aboutLicense: 'Copyright 2019 Projekt LilaHerz 💜',
  aboutCreated: 'Created by Projekt LilaHerz',
  noInfo: 'Sorry, no info',
  emptyScheduleHeadline: "Don't you like music?",
  emptySchedule: 'You did not add any gigs to your schedule yet!',
  origin: 'Origin',
  roots: 'Roots',
  style: 'Style',
  playOnSpotify: 'Play on Spotify',
  weatherDataBy: 'Weather data provided by:',
  fontByFormat: 'Font "{font}" by:',
  appDescriptionFormat: 'This is an unofficial app for the {festival}:',
  sourceCodeUnder: 'Source code can be found under',
);

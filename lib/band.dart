import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional_internal.dart';

import 'app_storage.dart' as appStorage;
import 'model.dart';

class Bands extends InheritedWidget {
  const Bands({
    @required Widget child,
    Key key,
    this.bands,
  }) : super(key: key, child: child);

  final ImmortalMap<String, BandData> bands;

  @override
  bool updateShouldNotify(Bands oldWidget) => oldWidget.bands != bands;

  static Optional<BandData> of(BuildContext context, String id) {
    final Bands data = context.inheritFromWidgetOfExactType(Bands);
    return data.bands[id];
  }
}

class BandsProvider extends StatefulWidget {
  const BandsProvider({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  BandsProviderState createState() => BandsProviderState();
}

class BandsProviderState extends State<BandsProvider> {
  Future<ImmortalMap<String, BandData>> _loadInitialData() async {
    return appStorage.loadJson('bands.json').then((onValue) {
      if (onValue.isPresent) {
        return Future.value(_parseJsonBands(onValue.value));
      }
      return _loadFallbackData();
    });
  }

  Future<ImmortalMap<String, BandData>> _loadFallbackData() =>
      DefaultAssetBundle.of(context)
          .loadString('assets/bands.json')
          .then<ImmortalMap<String, BandData>>(
              (v) => _parseJsonBands(jsonDecode(v)));

  Future<Optional<ImmortalMap<String, BandData>>> _loadRemoteData() async {
    // final response = await http.get(
    //     'https://lilafestivalhub.herokuapp.com/bands?festival=$festivalId');
    // if (response.statusCode == 200) {
    //   final Map<String, dynamic> json = jsonDecode(response.body);
    //   appStorage.storeJson(appStorageKey, json);
    //   return Optional.of(_parseJsonBands(json));
    // }
    return Optional.empty();
  }

  ImmortalMap<String, BandData> _parseJsonBands(dynamic jsonMap) =>
      ImmortalMap<String, BandData>(
          jsonMap.map<String, BandData>(_parseJsonBand));

  MapEntry<String, BandData> _parseJsonBand(String bandName, dynamic data) =>
      MapEntry(
        bandName,
        BandData(
          name: bandName,
          image: data['img'],
          logo: data['logo'],
          origin: data['origin'],
          style: data['style'],
          roots: data['roots'],
          spotify: data['spotify'],
          text: data['description'],
          textEn: data['description_en'],
        ),
      );

  /// Map of bands by name
  ImmortalMap<String, BandData> _bands = ImmortalMap<String, BandData>.empty();

  @override
  void initState() {
    super.initState();
    _loadInitialData().then((bands) {
      _loadRemoteData().then((remoteBands) {
        if (remoteBands.isPresent) {
          setState(() {
            _bands = remoteBands.value;
          });
        }
      });
      setState(() {
        _bands = bands;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Bands(
        bands: _bands,
        child: widget.child,
      );
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional_internal.dart';

import 'firestore.dart';
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
    this.firestore,
  }) : super(key: key);

  final Widget child;
  final Firestore firestore;

  @override
  BandsProviderState createState() => BandsProviderState();
}

class BandsProviderState extends State<BandsProvider> {
  Future<ImmortalMap<String, BandData>> _loadInitialData() async {
    final firebaseData = await loadData(widget.firestore, 'bands');
    final bands = firebaseData.collection.isEmpty
        ? await _loadFallbackData()
        : _parseBands(firebaseData.collection);
    final updatedBands = _parseBands(firebaseData.updates);
    return bands.addAll(updatedBands);
  }

  Future<ImmortalMap<String, BandData>> _loadFallbackData() =>
      DefaultAssetBundle.of(context)
          .loadString('assets/bands.json')
          .then<ImmortalMap<String, BandData>>(
              (v) => _parseJsonBands(jsonDecode(v)));

  MapEntry<String, BandData> _parseBand(DocumentSnapshot snapshot) =>
      _parseJsonBand(snapshot.documentID, snapshot.data);

  ImmortalMap<String, BandData> _parseBands(List<DocumentSnapshot> snapshots) =>
      ImmortalMap.fromEntriesIterable(snapshots.map(_parseBand));

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

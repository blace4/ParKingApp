import 'package:flutter/material.dart';
import 'package:flutter_app3/geoLocator_service.dart';
import 'package:flutter_app3/map_display.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final geoService = GeolocatorService();

  @override
  Widget build(BuildContext context) {
    return FutureProvider(
      create: (context) => geoService.getInitialLocation(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.light(),
        //darkTheme: ThemeData.dark(),
        home: Map(),
      ),
    );
  }
}

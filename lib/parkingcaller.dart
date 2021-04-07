import 'package:flutter/material.dart';
import 'package:flutter_app3/geoLocator_service.dart';
import 'package:flutter_app3/places_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'ClosestParking.dart';
import 'place.dart';

void main() => runApp(MyParkingCaller());

class MyParkingCaller extends StatelessWidget {
  final locatorService = GeolocatorService();
  final placesService = PlacesService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider(create: (context) => locatorService.getLocation()),
        ProxyProvider<Position, Future<List<Place>>>(
            update: (context, position, places) {
          return (position != null)
              ? placesService.getPlaces(position.latitude, position.longitude)
              : null;
        })
      ],
      child: MaterialApp(
        title: 'Parking App',
        theme: ThemeData.light(),
        //darkTheme: ThemeData.dark(),
        home: Search(),
      ),
    );
  }
}

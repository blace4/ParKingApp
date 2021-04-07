import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app3/geoLocator_service.dart';
import 'package:flutter_app3/searchPlaces.dart';

class ParkatDestination extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ParkatDestinationState();
}

class _ParkatDestinationState extends State<ParkatDestination> {
  String heading;
  final GeolocatorService geoService = GeolocatorService();

  Future<void> getLocationResults(String textInput) async {
    if (textInput.isEmpty) {
      setState(() {
        heading = '';
      });
      return;
    }
    String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String key = 'AIzaSyBSbce98wfAFHs08hfr-OYsza9SHAh4_HU';
    String type = '';
    String request = '$url?input=$textInput&key=$key&type=$type';
    Response response = await Dio().get(request);
    final predictions = response.data['predictions'];
    print('The predictions are : \n $predictions\n');

    List<String> placeNames = [];

    setState(() {
      heading = 'Results';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Park at Destination",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: createSearch());
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: geoService.getCurrentLocation(),
        builder: (context, snapshot) {
          return Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
//              GoogleMap(
//                myLocationEnabled: true,
//                initialCameraPosition: CameraPosition(
//                    target:
//                        LatLng(snapshot.data.latitude, snapshot.data.longitude),
//                    zoom: 15),
//              ),
              Container(
                child: Text(
                  "Enter your Destination",
                  style: TextStyle(fontSize: 17),
                ),
                alignment: Alignment(0.0, -0.1),
              ),
            ],
          );
        },
      ),
    );
  }
}

class createSearch extends SearchDelegate<SearchPlace> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    IconButton(
      icon: Icon(Icons.keyboard_arrow_left),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //display suggestions

    return Card(
      child: Text(query),
    );
  }
}

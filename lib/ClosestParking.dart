import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app3/geoLocator_service.dart';
import 'package:flutter_app3/map_display.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import './place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    final currentPosition = Provider.of<Position>(context);
    final placesProvider = Provider.of<Future<List<Place>>>(context);
    final geoService = GeolocatorService();
    //Firebase.initializeApp();

    return FutureProvider(
      create: (context) => placesProvider,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Closest Parking",
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  (context),
                  MaterialPageRoute(builder: (context) => Map()),
                );
              },
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Parking Decks')
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? Center(child: CircularProgressIndicator())
                    : (currentPosition != null)
                        ? Consumer<List<Place>>(
                            builder: (_, places, __) {
                              return (places != null)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: GoogleMap(
                                            myLocationButtonEnabled: true,
                                            myLocationEnabled: true,
                                            initialCameraPosition:
                                                CameraPosition(
                                                    target: LatLng(
                                                        currentPosition
                                                            .latitude,
                                                        currentPosition
                                                            .longitude),
                                                    zoom: 16.0),
                                            zoomGesturesEnabled: true,
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                              itemCount: places.length,
                                              itemBuilder: (context, index) {
                                                return FutureProvider(
                                                  create: (context) =>
                                                      geoService.DistaceCalc(
                                                          currentPosition
                                                              .latitude,
                                                          currentPosition
                                                              .longitude,
                                                          places[index]
                                                              .geometry
                                                              .location
                                                              .lat,
                                                          places[index]
                                                              .geometry
                                                              .location
                                                              .lng),
                                                  child: Card(
                                                    child: ListTile(
                                                      title: Text(
                                                          places[index].name),
                                                      subtitle: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          (places[index]
                                                                      .rating !=
                                                                  null)
                                                              ? Row(
                                                                  children: <
                                                                      Widget>[
                                                                    RatingBarIndicator(
                                                                      rating: places[
                                                                              index]
                                                                          .rating,
                                                                      itemBuilder: (context, index) => Icon(
                                                                          Icons
                                                                              .star,
                                                                          color:
                                                                              Colors.amber),
                                                                      itemCount:
                                                                          5,
                                                                      itemSize:
                                                                          15,
                                                                      direction:
                                                                          Axis.horizontal,
                                                                    )
                                                                  ],
                                                                )
                                                              : Row(),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Consumer<double>(
                                                            builder: (context,
                                                                meters,
                                                                widget) {
                                                              return (snapshot.data.docs.firstWhere(
                                                                          (doc) =>
                                                                              doc.id ==
                                                                              places[index]
                                                                                  .name,
                                                                          orElse: () =>
                                                                              null) !=
                                                                      null)
                                                                  ? Text(
                                                                      '${places[index].vicinity} \u00b7 ${(meters / 1000).round()} Km \u00b7 ${(snapshot.data.docs.firstWhere((doc) => doc.id == places[index].name))['openSpots']} spots remaining',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                    )
                                                                  : Text(
                                                                      '${places[index].vicinity} \u00b7 ${(meters / 1000).round()} Km \u00b7 Parking data unavailable',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                    );
                                                            },
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                        ],
                                                      ),
                                                      trailing: IconButton(
                                                        icon: Icon(
                                                            Icons.directions),
                                                        alignment:
                                                            Alignment.center,
                                                        color: Colors.blue,
                                                        iconSize: 20,
                                                        onPressed: () {
                                                          launchMapDirection(
                                                              places[index]
                                                                  .geometry
                                                                  .location
                                                                  .lat,
                                                              places[index]
                                                                  .geometry
                                                                  .location
                                                                  .lng);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        )
                                      ],
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(),
                                    );
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          );
              })

          //return Container(width: 0.0, height: 0.0);
          ),
    );
  }

  void launchMapDirection(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Unable to launch url at the moment. $url';
    }
  }
}

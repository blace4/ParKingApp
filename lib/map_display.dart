import 'package:flutter/material.dart';
import 'package:flutter_app3/ParkAtDestination.dart';
import 'package:flutter_app3/geoLocator_service.dart';
import 'package:flutter_app3/parkingcaller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapState();
}

class _MapState extends State<Map> {
  final GeolocatorService geoService = GeolocatorService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: geoService.getCurrentLocation(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return Stack(
            children: [
              GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                padding: EdgeInsets.fromLTRB(0, 10, 0, 80) +
                    MediaQuery.of(context).padding,
                initialCameraPosition: CameraPosition(
                    target:
                        LatLng(snapshot.data.latitude, snapshot.data.longitude),
                    zoom: 15),
              ),
              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  child: Container(
                    color: (Colors.white).withOpacity(0.9),
                    height: 150,
                    child: Column(
                      children: <Widget>[
                        new SizedBox(height: 20),
                        // new MaterialButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) =>
                        //                   ParkatDestination()));
                        //     },
                        //     child: Text('Park at Destination',
                        //         style: TextStyle(fontSize: 20)),
                        //     textColor: Colors.blue),
                        SizedBox(height: 5),
                        new MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyParkingCaller()));
                            },
                            child: Text('Find Closest Parking',
                                style: TextStyle(fontSize: 20)),
                            textColor: Colors.blue),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

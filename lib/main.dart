import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:location/location.dart' as LocationManager;

const kGoogleApiKey = "YOUR API KEY";
GoogleMapsPlaces gPlaces = GoogleMapsPlaces(apiKey: kGoogleApiKey);

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Property Listing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  // Location Prompts
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Map Listing'),
      ),
      body: MapListing(),
    );
  }
}

class MapListing extends StatefulWidget {
  MapListingState createState() => MapListingState();
}

class MapListingState extends State<MapListing> {
  GoogleMapController mController;
  // get GPS position
  static const LatLng m_center = const LatLng(45.521563, -122.677433);
  List<PlacesSearchResult> mListing = [];

  void _onMapCreated(GoogleMapController controller) async {
    mController = controller;
    refresh();
  }

  void _onPressed() async{
    mController.clearMarkers();
    // getListing()
  }
  void refresh() async {
    final center = await getUserLocation();
    mController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: center, zoom: 15.0)));
    getListing(center);
  }

  Future<LatLng> getUserLocation() async {
    var currentLocation = <String, double>{};
    final location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation["latitude"];
      final lng = currentLocation["longitude"];
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }

  void getListing(LatLng center) async {
    final location = Location(center.latitude, center.longitude);
    final result = await gPlaces.searchNearbyWithRadius(location, 2500);
    setState(() {
      if (result.status == "OK") {
        mListing = result.results;

        result.results.forEach((f) {
          final markerOptions = MarkerOptions(
            position: LatLng(f.geometry.location.lat, f.geometry.location.lng),
            infoWindowText: InfoWindowText("${f.name}", "${f.types?.first}"),
            icon: BitmapDescriptor.defaultMarker,
          );
          mController.addMarker(markerOptions);
        });
      } else {
        print('error: ${result.errorMessage}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
            onMapCreated: _onMapCreated,
            options: GoogleMapOptions(
              cameraPosition: CameraPosition(target: LatLng(0, 0)),
              myLocationEnabled: true,
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
            )),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
              onPressed: () => _onPressed,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              backgroundColor: Colors.pink,
              child: const Icon(Icons.refresh, size: 36.0),
            ),
          ),
        ),
      ],
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  Completer<GoogleMapController> _controller = Completer();
  // get GPS position
  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
          myLocationEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          compassEnabled: true,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
              onPressed: () => print('button pressed'),
              materialTapTargetSize: MaterialTapTargetSize.padded,
              backgroundColor: Colors.green,
              child: const Icon(Icons.map, size: 36.0),
            ),
          ),
        ),
      ],
    );
  }
}

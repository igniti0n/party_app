import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final LatLng initialLocation;
  final bool isSelecting;
  MapScreen(
      {Key key,
      this.initialLocation = const LatLng(7.4220416, -102.0840848),
      this.isSelecting = false})
      : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop(_pickedLocation);
            },
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 16,
        ),
        buildingsEnabled: true,
        circles:
            null, //TODO: THINK ABOUT ADDING RADIUS AROUDN THE LOCATION OR SMTH
        onTap: widget.isSelecting == false
            ? null
            : (location) {
                setState(() {
                  _pickedLocation = location;
                });
              },
        markers: !widget.isSelecting
            ? {
                Marker(
                  markerId: MarkerId('m1'),
                  position: widget.initialLocation,
                )
              }
            : _pickedLocation == null
                ? null
                : {
                    Marker(
                      markerId: MarkerId('m1'),
                      position: _pickedLocation,
                    )
                  },
      ),
    );
  }
}

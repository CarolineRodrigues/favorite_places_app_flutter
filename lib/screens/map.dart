import 'package:favorite_places_app_flutter/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
      latitude: 38.7765262,
      longitude: -9.1198235,
      address: 'Rua General Silva Freire 55, Lisbon',
    ),
    this.isSelecting = true,
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick your Location' : 'Your location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
            ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 9.2,
          onLongPress: !widget.isSelecting
              ? null
              : (position, pickedLocation) {
                  setState(() {
                    _pickedLocation = pickedLocation;
                  });
                },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: (_pickedLocation == null && widget.isSelecting)
                ? []
                : [
                    Marker(
                      point: _pickedLocation ??
                          LatLng(widget.location.latitude,
                              widget.location.longitude),
                      width: 80,
                      height: 80,
                      builder: (context) => const Icon(Icons.pin_drop_rounded,
                          color: Colors.blue),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}

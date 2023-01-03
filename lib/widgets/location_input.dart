// AIzaSyCQDp1hfD27TWaEVplYzgHDuU3Jh5U3yq8 - API key
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';
import '../models/place.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectLocation;
  LocationInput(this.onSelectLocation);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;
  bool _isLoading = false;

  void _showPreview({double latitude, double longitude}) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: latitude,
      longitude: longitude,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final locData = await Location().getLocation();
      _showPreview(
        latitude: locData.latitude,
        longitude: locData.longitude,
      );
      setState(() {
        _isLoading = false;
      });

      widget.onSelectLocation(
        locData.latitude,
        locData.longitude,
      );
    } catch (error) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (ctx) => MapScreen(
        initialLocation:
            PlaceLocation(latitude: 30.245796, longitude: 75.842072),
        isSelecting: true,
      ),
    ));
    if (selectedLocation == null) {
      return;
    }
    await _showPreview(
      latitude: selectedLocation.latitude,
      longitude: selectedLocation.longitude,
    );

    widget.onSelectLocation(
      selectedLocation.latitude,
      selectedLocation.longitude,
    );
    // ...
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 190,
            width: double.infinity,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
            child: _isLoading
                ? CircularProgressIndicator()
                : _previewImageUrl == null
                    ? Text(
                        'No location chosen',
                        textAlign: TextAlign.center,
                      )
                    : Image.network(
                        _previewImageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
                onPressed: _getCurrentUserLocation,
                icon: Icon(Icons.location_on),
                label: Text('Current Location')),
            TextButton.icon(
                onPressed: _selectOnMap,
                icon: Icon(Icons.map),
                label: Text('Select On Map')),
          ],
        ),
      ],
    );
  }
}

// API key not found.  Check that <meta-data android:name="com.google.android.geo.API_KEY" android:value="your API key"/> is in the <application> element of AndroidManifest.xml

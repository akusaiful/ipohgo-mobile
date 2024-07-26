import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipohgo/models/place.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';

class Maps extends StatefulWidget {
  final Place? data;
  Maps({Key? key, required this.data}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    // final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      // for (final office in googleOffices.offices) {
      final marker = Marker(
          markerId: MarkerId(widget.data!.name.toString()),
          position: LatLng(widget.data!.latitude!, widget.data!.longitude!),
          infoWindow: InfoWindow(
            title: widget.data!.name,
            snippet: widget.data!.location,
          ));
      // );
      _markers[widget.data!.name.toString()] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      )).tr(),
                  new GestureDetector(
                    onTap: () {
                      MapsLauncher.launchCoordinates(widget.data!.latitude!,
                          widget.data!.longitude!, widget.data!.name);
                    },
                    child: new Text(
                      'See map',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                height: 3,
                width: 50,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(40)),
              ),
              Text(widget.data!.location!),
            ],
          ),
        ),
        Stack(
          children: [
            Center(
              child: Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  markers: _markers.values.toSet(),
                  initialCameraPosition: CameraPosition(
                    target:
                        LatLng(widget.data!.latitude!, widget.data!.longitude!),
                    zoom: 11.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

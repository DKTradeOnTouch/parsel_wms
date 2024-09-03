import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import 'package:parsel_flutter/utils/dialogs.dart';
import 'package:parsel_flutter/screens/in_progress/progress_page.dart';

import '../../../models/InvoiceList_model.dart';

class GoogleMap2 extends StatefulWidget {
  final LatLng currentLocation;
  final List<DeliveryPointModel> deliveryPoints;
  final void Function(ResultList order) startTrip;

  const GoogleMap2({
    Key? key,
    required this.currentLocation,
    required this.deliveryPoints,
    required this.startTrip,
  }) : super(key: key);

  @override
  _GoogleMap2State createState() => _GoogleMap2State();
}

class _GoogleMap2State extends State<GoogleMap2> {
  final _markers = <Marker>{};
  late final _centreLatitude =
      (widget.deliveryPoints.sumBy((element) => element.lat) +
              widget.currentLocation.latitude) /
          (widget.deliveryPoints.length + 1);
  late final _centreLongitude =
      (widget.deliveryPoints.sumBy((element) => element.lon) +
              widget.currentLocation.longitude) /
          (widget.deliveryPoints.length + 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _addMarkers());
  }

  Future<void> _addMarkers() async {
    await Future.wait(widget.deliveryPoints.mapIndexed(
      (index, e) {
        return _markers.addLabelMarker(
          LabelMarker(
            label: '${index + 1}',
            markerId: MarkerId(e.storeId.toString()),
            textStyle: const TextStyle(fontSize: 35),
            backgroundColor: Colors.red.shade700,
            position: LatLng(e.lat, e.lon),
            infoWindow: InfoWindow(
              title: e.main.store?.storeName ?? '',
              snippet: e.address,
              onTap: () async {
                final confirmed = await showConfirmationDialog(
                  context: context,
                  title: 'Start Trip',
                  content: 'Are you sure you want to start the trip?',
                  positiveButtonLabel: "Start",
                );
                if (confirmed == true) {
                  Navigator.pop(context);
                  widget.startTrip(e.main);
                }
              },
            ),
          ),
        );
      },
    ));
    setState(() {});
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map View"),
      ),
      body: GoogleMap(
        markers: _markers,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        compassEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(_centreLatitude, _centreLongitude),
          zoom: 12,
        ),
      ),
    );
  }
}

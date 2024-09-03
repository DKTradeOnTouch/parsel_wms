import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parsel_flutter/screens/AUth/prominent_Disclosure.dart';
import 'package:parsel_flutter/screens/in_progress/location_service.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/map/provider/map_provider.dart';
import 'package:parsel_flutter/src/widget/button/button.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!await LocationService.instance.isPermissionGranted() ||
          !await LocationService.instance.checkServiceEnabled()) {
        if (!await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ProminentDisclosure()))) {
          // Navigator.pop(context);
          return;
        }
      }
    });
    super.initState();
  }

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  List<LatLng> latLen = [
    const LatLng(19.0759837, 72.8776559),
    const LatLng(28.679079, 77.069710),
    const LatLng(26.850000, 80.949997),
    const LatLng(24.879999, 74.629997),
    const LatLng(16.166700, 74.833298),
    const LatLng(12.971599, 77.594563),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, MapProvider mapProvider, __) {
      return Scaffold(
        body: Container(
          color: ColorUtils.primaryColor,
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(AssetUtils.authBgImage),
                              fit: BoxFit.cover)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new,
                                    color: ColorUtils.whiteColor,
                                  )),
                              const SizedBox(width: 10),
                              Text(
                                'Map view',
                                style: FontUtilities.h20(
                                    fontColor: ColorUtils.whiteColor),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Image.asset(AssetUtils.arrivedIconImage,
                                    height: 25),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ]),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 12.0),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Hotel sadanand (CST)',
                                        maxLines: 2,
                                        style: FontUtilities.h20(
                                            fontColor: ColorUtils.whiteColor),
                                      ),
                                    ),
                                    Text(
                                      '#707766',
                                      style: FontUtilities.h20(
                                          fontColor: ColorUtils.whiteColor),
                                    ),
                                  ]),
                            ),
                            const SizedBox(height: 1),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: VariableUtilities.screenSize.height,
                        width: VariableUtilities.screenSize.width,
                        decoration: const BoxDecoration(
                            color: ColorUtils.colorF7F9FF,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                        child: const ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(19.228825, 72.854118),
                                      zoom: 15),
                                  myLocationEnabled: false,
                                  compassEnabled: false,
                                  mapToolbarEnabled: false,
                                  zoomControlsEnabled: false,
                                  myLocationButtonEnabled: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: DraggableScrollableSheet(
                    expand: true,
                    initialChildSize: 0.21,
                    minChildSize: 0.21,
                    maxChildSize: 0.5,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                            color: ColorUtils.whiteColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            )),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    height: 3,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        color: ColorUtils.colorD9D9D9,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    Text(
                                      '2 hr 44 min ',
                                      style: FontUtilities.h20(
                                          fontColor: ColorUtils.colorDD2424,
                                          fontWeight: FWT.semiBold),
                                    ),
                                    Text(
                                      '(69km)',
                                      style: FontUtilities.h20(
                                          fontColor: ColorUtils.colorAAAAAA),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Fastest route now, avoids congestion',
                                  style: FontUtilities.h16(
                                      fontColor: ColorUtils.colorA4A9B0),
                                ),
                                const SizedBox(height: 15),
                                PrimaryButton(
                                  onTap: () {},
                                  title: 'Start',
                                  borderRadius: 10,
                                  width: 100,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

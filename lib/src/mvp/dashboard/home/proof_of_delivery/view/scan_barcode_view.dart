import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/proof_of_delivery/view/scanner_error_widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class BarcodeScannerWithController extends StatefulWidget {
  const BarcodeScannerWithController({Key? key}) : super(key: key);

  @override
  _BarcodeScannerWithControllerState createState() =>
      _BarcodeScannerWithControllerState();
}

class _BarcodeScannerWithControllerState
    extends State<BarcodeScannerWithController>
    with SingleTickerProviderStateMixin {
  BarcodeCapture? barcode;

  final MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
    // formats: [BarcodeFormat.qrCode]
    // facing: CameraFacing.front,
    // detectionSpeed: DetectionSpeed.normal
    // detectionTimeoutMs: 1000,
    // returnImage: false,
  );

  bool isStarted = true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_sharp)),
            title: const Text('Scanner'),
            actions: [
              IconButton(
                color: Colors.white,
                icon: ValueListenableBuilder(
                  valueListenable: controller.cameraFacingState,
                  builder: (context, state, child) {
                    if (state == null) {
                      return const Icon(Icons.camera_front);
                    }
                    switch (state as CameraFacing) {
                      case CameraFacing.front:
                        return const Icon(Icons.camera_front);
                      case CameraFacing.back:
                        return const Icon(Icons.camera_rear);
                    }
                  },
                ),
                iconSize: 32.0,
                onPressed: () => controller.switchCamera(),
              ),
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.image),
                iconSize: 32.0,
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  // Pick an image
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    if (await controller.analyzeImage(image.path)) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Barcode found!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No barcode found!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ]),
        backgroundColor: Colors.black,
        body: Builder(
          builder: (context) {
            return Column(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: MobileScanner(
                      controller: controller,
                      errorBuilder: (context, error, child) {
                        return ScannerErrorWidget(error: error);
                      },
                      fit: BoxFit.cover,
                      onDetect: (barcode) {
                        setState(() {
                          this.barcode = barcode;
                        });
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 100,
                    color: Colors.black.withOpacity(0.4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: controller.hasTorchState,
                          builder: (context, state, child) {
                            if (state != true) {
                              return const SizedBox.shrink();
                            }
                            return IconButton(
                              color: Colors.white,
                              icon: ValueListenableBuilder(
                                valueListenable: controller.torchState,
                                builder: (context, state, child) {
                                  if (state == null) {
                                    return const Icon(
                                      Icons.flash_off,
                                      color: Colors.grey,
                                    );
                                  }
                                  switch (state as TorchState) {
                                    case TorchState.off:
                                      return const Icon(
                                        Icons.flash_off,
                                        color: Colors.grey,
                                      );
                                    case TorchState.on:
                                      return const Icon(
                                        Icons.flash_on,
                                        color: Colors.yellow,
                                      );
                                  }
                                },
                              ),
                              iconSize: 32.0,
                              onPressed: () => controller.toggleTorch(),
                            );
                          },
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: InkWell(
                              onTap: barcode?.barcodes.first.rawValue != null
                                  ? () {
                                      MixpanelManager.trackEvent(
                                          eventName: 'RedirectToUrl',
                                          properties: {'URL': 'Barcodes'});

                                      _launchUrl(
                                          barcode?.barcodes.first.rawValue ??
                                              '');
                                    }
                                  : null,
                              child: Container(
                                height: 100,
                                color: Colors.transparent,
                                child: Center(
                                  child: Text(
                                    barcode != null
                                        ? '${barcode?.barcodes.first.rawValue} ${barcode?.barcodes.first.format}'
                                        : 'Scan something!',
                                    overflow: TextOverflow.fade,
                                    style: FontUtilities.h16(
                                        fontColor: ColorUtils.whiteColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }
}

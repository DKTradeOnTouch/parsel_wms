import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/model/loaded_truck_model.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';

class PickUpLoadBottomSheet extends StatefulWidget {
  const PickUpLoadBottomSheet(
      {Key? key,
      required this.onOkPress,
      required this.loadedTruckModel,
      required this.warehouseName})
      : super(key: key);

  final VoidCallback onOkPress;
  final LoadedTruckModel loadedTruckModel;
  final String warehouseName;

  @override
  State<PickUpLoadBottomSheet> createState() => _PickUpLoadBottomSheetState();
}

class _PickUpLoadBottomSheetState extends State<PickUpLoadBottomSheet> {
  List<Map<String, dynamic>> loadedContainerCountList = [];
  List<Color> colorsList = [
    ColorUtils.colorFBD1B2,
    ColorUtils.colorA2E4E6,
    ColorUtils.colorE1BFFA
  ];

  @override
  void initState() {
    int total = 0;
    for (int i = 0; i < widget.loadedTruckModel.data.compartments.length; i++) {
      total = total +
          widget.loadedTruckModel.data.compartments[i].allocatedSpacePct;
      loadedContainerCountList.add({
        'count': widget.loadedTruckModel.data.compartments[i].allocatedSpacePct,
        'type': 'count'
      });
      if (widget.loadedTruckModel.data.compartments.length - 1 == i) {
        if (total < 100) {
          loadedContainerCountList.add({'count': 100 - total, 'type': 'image'});
        }
      }
    }
    if (loadedContainerCountList.isEmpty) {
      loadedContainerCountList.add({'count': 100, 'type': 'image'});
    }
    for (int i = 0; i < loadedContainerCountList.length; i++) {
      print('loadedContainerCountList[i] --> ${loadedContainerCountList[i]}');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      width: VariableUtilities.screenSize.width,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.pick_up_load.tr(),
                style: FontUtilities.h18(
                    fontColor: ColorUtils.color3F3E3E,
                    fontWeight: FWT.semiBold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Image.asset(AssetUtils.locationImage, height: 25, width: 25),
                  const SizedBox(width: 10),
                  Text(
                    widget.warehouseName,
                    style: FontUtilities.h16(fontColor: ColorUtils.colorAAAAAA),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${LocaleKeys.today.tr()} ',
                    style: FontUtilities.h18(fontColor: ColorUtils.color595959),
                  ),
                  Text(
                    // '${LocaleKeys.container.tr()},54,1 lbs',
                    widget.loadedTruckModel.status
                        ? '${widget.loadedTruckModel.data.weightMeta}, lbs'
                        : 'unknown weight',
                    style: FontUtilities.h18(fontColor: ColorUtils.colorC4C4C4),
                  )
                ],
              ),
              const SizedBox(height: 5),
              const Divider(thickness: 1),
              const SizedBox(height: 5),
              Text(
                LocaleKeys.load_details.tr(),
                style: FontUtilities.h18(fontColor: ColorUtils.color3F3E3E),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 150,
                child: Column(
                  children: [
                    Expanded(
                        // height: 150,
                        child: Stack(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Stack(
                              children: [
                                Image.asset(
                                  AssetUtils.truckBonnetIcon,
                                  width: 110,
                                  fit: BoxFit.fill,
                                  height: 150,
                                ),
                                Positioned(
                                    top: 80,
                                    left: 22,
                                    child: Text(
                                      '#${widget.loadedTruckModel.status ? widget.loadedTruckModel.data.vehicleNumber : 'unknown'}',
                                      style: FontUtilities.h15(
                                          fontColor: ColorUtils.color3F3E3E),
                                    )),
                              ],
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 150,
                                child: LayoutBuilder(
                                    builder: (context, constraint) {
                                  return Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Image.asset(AssetUtils.truckContainerIcon,
                                          width: constraint.maxWidth,
                                          height: constraint.maxHeight,
                                          fit: BoxFit.fill,
                                          alignment: Alignment.bottomCenter),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 3,
                                            bottom: 17,
                                            left: 2,
                                            right: 2),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: List.generate(
                                              loadedContainerCountList.length,
                                              (index) {
                                            print(
                                                'colorsList[index % ~colorsList.length] ${index % loadedContainerCountList.length} ');
                                            return loadedContainerCountList[
                                                        index]['type'] ==
                                                    'count'
                                                ? Container(
                                                    width: (((loadedContainerCountList[
                                                                        index]
                                                                    ['count'] *
                                                                constraint
                                                                    .maxWidth) /
                                                            100) -
                                                        (1 *
                                                            loadedContainerCountList
                                                                .length)),
                                                    color: colorsList[index %
                                                        colorsList.length],
                                                    child: Center(
                                                      child: Text(
                                                        '${loadedContainerCountList[index]['count']}%',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: FontUtilities.h15(
                                                            fontColor: ColorUtils
                                                                .color3F3E3E),
                                                      ),
                                                    ),
                                                  )
                                                : Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Image.asset(
                                                        AssetUtils
                                                            .emptyContainerIcon,
                                                        width: (((loadedContainerCountList[
                                                                            index]
                                                                        [
                                                                        'count'] *
                                                                    constraint
                                                                        .maxWidth) /
                                                                100) -
                                                            (loadedContainerCountList
                                                                        .length ==
                                                                    1
                                                                ? 4
                                                                : 1 *
                                                                    loadedContainerCountList
                                                                        .length)),
                                                        fit: BoxFit.fill,
                                                        height: getHeight(
                                                            maxHeight:
                                                                constraint
                                                                    .maxHeight),
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                      ),
                                                      Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              LocaleKeys.empty
                                                                  .tr(),
                                                              style: FontUtilities.h16(
                                                                  fontColor:
                                                                      ColorUtils
                                                                          .color3F3E3E)))
                                                    ],
                                                  );
                                          }),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            )
                            // Expanded(
                            //   child: LayoutBuilder(builder: (context, constraint) {
                            //     print(constraint);
                            //     return Container(
                            //       height: getHeight(maxHeight: constraint.maxHeight),
                            //       decoration: const BoxDecoration(
                            //         color: Colors.red,
                            //         image: DecorationImage(
                            //             image:
                            //                 AssetImage(AssetUtils.truckContainerIcon),
                            //             alignment: Alignment.bottomCenter),
                            //       ),
                            // child: Row(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //   children: List.generate(
                            //     loadedContainerCountList.length,
                            //     (index) => Padding(
                            //       padding: const EdgeInsets.only(
                            //           bottom: 17, top: 10, left: 1, right: 1),
                            //       child: loadedContainerCountList[index]
                            //                   ['type'] ==
                            //               'count'
                            //           ? Container(
                            //               width:
                            //                   (((loadedContainerCountList[index]
                            //                                   ['count'] *
                            //                               constraint.maxWidth) /
                            //                           100) -
                            //                       (1 *
                            //                           loadedContainerCountList
                            //                               .length)),
                            //               color: colorsList[
                            //                   index % ~colorsList.length],
                            //               child: Center(
                            //                 child: Text(
                            //                   '${loadedContainerCountList[index]['count']}%',
                            //                   textAlign: TextAlign.center,
                            //                   style: FontUtilities.h15(
                            //                       fontColor:
                            //                           ColorUtils.color3F3E3E),
                            //                 ),
                            //               ),
                            //             )
                            //           : Image.asset(
                            //               AssetUtils.emptyContainerIcon,
                            //               fit: BoxFit.cover,
                            //               width: (((loadedContainerCountList[
                            //                               index]['count'] *
                            //                           constraint.maxWidth) /
                            //                       100) -
                            //                   (loadedContainerCountList
                            //                               .length ==
                            //                           1
                            //                       ? 2
                            //                       : 1 *
                            //                           loadedContainerCountList
                            //                               .length)),
                            //               height: getHeight(
                            //                   maxHeight: constraint.maxHeight),
                            //               alignment: Alignment.bottomCenter,
                            //             ),
                            //     ),
                            //   ),
                            // ),
                            //     );
                            //   }),
                            // ),
                          ],
                        ),
                        // Image.asset(
                        //   AssetUtils.truckContainerIconImage,
                        //   fit: BoxFit.cover,
                        // ),

                        // Positioned(
                        //     top: 60,
                        //     bottom: 0,
                        //     right: 120,
                        //     child: Text(
                        //       '50%',
                        //       style: FontUtilities.h15(
                        //           fontColor: ColorUtils.color3F3E3E),
                        //     ))
                      ],
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.bottomRight,
                child: PrimaryButton(
                  borderRadius: 10,
                  height: 45,
                  width: 100,
                  onTap: widget.onOkPress,
                  title: LocaleKeys.ok.tr(),
                ),
              )
            ]),
      ),
    );
  }

  double getHeight({required double maxHeight}) {
    print(((maxHeight * 138) / 378));
    return ((maxHeight * 138 * 100) / 378);
  }
}

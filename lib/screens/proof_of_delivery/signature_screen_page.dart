import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_strings.dart';
import 'package:parsel_flutter/resource/app_styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

import '../../models/SalesOrderBYID_Model.dart' as SALES;
import '../../models/uploadsalesorder_model.dart' as uplds;
import '../../resource/app_fonts.dart';

import 'dart:ui' as ui;

class SignatureScreenPage extends StatefulWidget {
  final String Id;
  final String SalesOrderID;

  final List<SALES.ItemList> deliverOrdersList;
  final List<SALES.ItemList> dataList;
  final List<uplds.ItemList> dataup;
  final SALES.SalesOrderBYID_Model salesOrder;
  const SignatureScreenPage(
      {Key? key,
      required this.Id,
      required this.SalesOrderID,
      required this.deliverOrdersList,
      required this.dataList,
      required this.dataup,
      required this.salesOrder})
      : super(key: key);

  @override
  State<SignatureScreenPage> createState() => _SignatureScreenPageState();
}

class _SignatureScreenPageState extends State<SignatureScreenPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController signatureNameController = TextEditingController();
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.red,
    exportBackgroundColor: Colors.blue,
    exportPenColor: Colors.black,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print('Value changed'));
    signatureNameController.addListener(() => print('name changed'));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(AppStrings.strProofOfDelivery,
              style: AppStyles.appBarTitleStyle),
          leading: GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                height: 15,
                width: 15,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    iconSize: 20.0,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
            onTap: () {},
          ),
        ),
        body: ListView(
          children: <Widget>[
            //SIGNATURE CANVAS
            Signature(
              controller: _controller,
              height: 300,
              backgroundColor: Colors.lightBlueAccent,
            ),
            //OK AND CLEAR BUTTONS
            Container(
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter your name';
                      } else
                        return null;
                    },
                    onChanged: (text) {
                      setState(() {});
                    },
                    controller: signatureNameController,
                    style: const TextStyle(
                        color: AppColors.dashBoardText,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0),
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      hintStyle: const TextStyle(
                          color: AppColors.blackColor,
                          letterSpacing: 0.1,
                          fontFamily: appFontFamily,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold),
                      hintText: 'Please Type your name',
                      contentPadding: const EdgeInsets.only(
                          left: 15.0, right: 0.0, top: 0.0, bottom: 0.0),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                        borderSide: BorderSide(
                            width: 1,
                            color: AppColors.black2Color.withOpacity(0.25)),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(color: Colors.black),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        //SHOW EXPORTED IMAGE IN NEW ROUTE
                        IconButton(
                          icon: const Icon(Icons.check),
                          color: Colors.blue,
                          onPressed: () async {
                            if (_controller.isNotEmpty) {
                              final Uint8List? data =
                                  await _controller.toPngBytes();

                              print('signature file-->' + data.toString());

                              if (data != null &&
                                  _formKey.currentState!.validate()) {
                                await Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) {
                                      return Scaffold(
                                        appBar: AppBar(
                                          backgroundColor: Colors.black,
                                          leading: GestureDetector(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Container(
                                                height: 15,
                                                width: 15,
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: IconButton(
                                                    icon: const Icon(
                                                        Icons.arrow_back_ios),
                                                    iconSize: 20.0,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        body: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.grey[300],
                                                child: Image.memory(data),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: (() async {
                                                // AppHelper
                                                //     .changeScreenClearStack(
                                                //         context,
                                                //         ProofOfDeliveryPage(
                                                //           dataList:
                                                //               widget.dataList,
                                                //           dataup: widget.dataup,
                                                //           deliverOrdersList: widget
                                                //               .deliverOrdersList,
                                                //           salesOrder:
                                                //               widget.salesOrder,
                                                //           Id: widget.Id,
                                                //           SalesOrderID: widget
                                                //               .SalesOrderID,
                                                //         ));
                                                Uint8List? uint8list =
                                                    await _controller
                                                        .toPngBytes();
                                                if (uint8list != null) {
                                                  ui.Image image =
                                                      await decodeImageFromList(
                                                          uint8list);
                                                  ByteData? byteData =
                                                      await image.toByteData(
                                                          format: ui
                                                              .ImageByteFormat
                                                              .png);
                                                  Uint8List fileImageBytes =
                                                      byteData!.buffer
                                                          .asUint8List();
                                                  Directory fileDir =
                                                      await getTemporaryDirectory();

                                                  String filePath =
                                                      '${fileDir.path}/image.png'; // Replace with your desired file path

                                                  // Write the file
                                                  await File(filePath)
                                                      .writeAsBytes(
                                                          fileImageBytes);

                                                  // Optionally, you can show a confirmation or navigate to the saved image
                                                  print(
                                                      'Image saved to: $filePath');
                                                  Navigator.pop(context);
                                                  Navigator.pop(context, {
                                                    "file_path": filePath,
                                                    "sign_name":
                                                        signatureNameController
                                                            .text
                                                  });
                                                } else {
                                                  Navigator.pop(context);
                                                }
                                              }),
                                              child: Container(
                                                height: 60,
                                                decoration: const BoxDecoration(
                                                  color: AppColors.blackColor,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  10.0)),
                                                ),
                                                width: double.infinity,
                                                child: Center(
                                                  child: Text(
                                                    AppStrings.strSaveClose,
                                                    style: AppStyles
                                                        .buttonTextStyle,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.undo),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() => _controller.undo());
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.redo),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() => _controller.redo());
                          },
                        ),
                        //CLEAR CANVAS
                        IconButton(
                          icon: const Icon(Icons.clear),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() => _controller.clear());
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

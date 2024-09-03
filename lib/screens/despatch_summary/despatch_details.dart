/* created by Srini on 26-06-2022*/
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as im;
import 'package:image_picker/image_picker.dart';
import 'package:parsel_flutter/models/despatch_sum_item.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:parsel_flutter/resource/app_logs.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../Provider/Invoice_Controller.dart';
import '../../resource/app_styles.dart';

// ignore: must_be_immutable
class DespatchDetailsList extends StatefulWidget {
  const DespatchDetailsList(
      {Key? key, required List<DespatchSummaryItem> despatchValues})
      : _despatchValues = despatchValues,
        super(key: key);
  final List<DespatchSummaryItem> _despatchValues;

  @override
  State<DespatchDetailsList> createState() => _DespatchDetailsListState();
}

class _DespatchDetailsListState extends State<DespatchDetailsList> {
  List<TextEditingController> controllers = [];
  bool isDate = false;
  bool isImageAttached = false;
  var imageFile;

  getImagePicker() {
    showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
            onPopInvoked: (val) async => true,
            child: AlertDialog(
              title: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Choose Option',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            Navigator.of(context).pop();
                            imageAction('camera');
                          },
                          child: const Text(
                            'Camera ',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        InkWell(
                          onTap: () async {
                            Navigator.of(context).pop();
                            imageAction('Gallery');
                          },
                          child: const Text(
                            'Gallery ',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 90,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ColorUtils.kBottomButtonColor,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(5, 5),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: const Text(
                          'Close',
                          style: TextStyle(color: Colors.white),
                        ))),
              ],
            ));
      },
    );
  }

  void imageAction(String source) async {
    try {
      final image = await ImagePicker().pickImage(
          source:
              source == 'Gallery' ? ImageSource.gallery : ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);

      setState(() {
        imageFile = imageTemp;
        var list = Provider.of<InvoiceController>(context, listen: false);

        list.setFile(imageTemp);
      });
    } on PlatformException catch (e) {
      appLogs('Failed to pick image : $e');
    }
  }

  //Image Compression method - Srini
  void compressImage() async {
    appLogs('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    im.Image? image = im.decodeImage(imageFile.readAsBytesSync());
    im.copyResize(image!);

    var newIm2 = File('$path/img_$rand.jpg')
      ..writeAsBytesSync(im.encodeJpg(image, quality: 85));

    setState(() {
      imageFile = newIm2;
    });
    appLogs('image comparison completed');
  }

  DateTime selectedDate = DateTime.now();

  agingTextField() {
    return InkWell(
      onTap: () {
        setState(() {
          _selectDate(context);
        });
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.only(right: 10),
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(color: Colors.black12, spreadRadius: 1)
            ]),
        child: Text(
          "${selectedDate.toLocal()}".split(' ')[0],
          style: AppStyles.inwardTextSKUOrders,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2023));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget._despatchValues.isNotEmpty
        ? ListView.builder(
            itemCount: widget._despatchValues.length,
            itemBuilder: (context, index) {
              controllers.add(TextEditingController());

              //  list.setNoOfBox(int.parse(_controllers[4].toString()));
              //  list.setTemp(double.parse(_controllers[5].toString()));
              return singleItemList(index == widget._despatchValues.length - 1,
                  widget._despatchValues[index], controllers[index], isDate);
            })
        : const Center(child: CircularProgressIndicator());
  }

  Widget singleItemList(bool isPhotoTile, DespatchSummaryItem item,
      TextEditingController controllerTxt, bool isDatePicker) {
    controllerTxt.text = item.value;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Text(item.title,
                    style: const TextStyle(
                        fontFamily: appFontFamily,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blueColor))),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Container(
                color: ColorUtils.kTextFieldBorderColor,
                width: 2.0,
                height: 50.0,
              ),
            ),
            isPhotoTile
                ? Expanded(
                    flex: 4,
                    child: InkWell(
                      onTap: () {
                        getImagePicker();
                      },
                      child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: ColorUtils.kTextFieldBorderColor,
                            border:
                                Border.all(width: 1, style: BorderStyle.solid),
                          ),
                          child: imageFile != null
                              ? Image.file(
                                  imageFile,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.fill,
                                )
                              : const Icon(Icons.add_a_photo_outlined)),
                    ))
                : isDatePicker
                    ? agingTextField()
                    : Expanded(
                        flex: 4,
                        child: TextField(
                          controller: controllerTxt,
                          keyboardType: TextInputType.number,
                          onChanged: (text) {
                            item.value;
                          },
                          style: const TextStyle(
                            color: AppColors.dashBoardText,
                            fontFamily: appFontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: ColorUtils.kTextFieldBorderColor,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

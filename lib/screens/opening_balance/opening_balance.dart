import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parsel_flutter/screens/despatch_summary/despatch_summery_page.dart';
import 'package:parsel_flutter/screens/in_progress/progress_page.dart';

import '../../../resource/app_colors.dart';
import '../../../resource/app_helper.dart';
import '../../../resource/app_styles.dart';
import '../../resource/app_fonts.dart';

class OpeningBalanceScreen extends StatefulWidget {
  const OpeningBalanceScreen({Key? key}) : super(key: key);

  @override
  State<OpeningBalanceScreen> createState() => _OpeningBalanceScreenState();
}

class _OpeningBalanceScreenState extends State<OpeningBalanceScreen> {
  List<String> storageList = [
    'INR 1',
    'INR 2',
    'INR 5',
    'INR 10',
    'INR 20',
    'INR 50',
    'INR 100',
    'INR 200',
    'INR 500',
    'INR 2000'
  ];

  @override
  void initState() {
    super.initState();
  }

  textFieldValue() {
    return Container(
      height: 40,
      padding: EdgeInsets.only(right: 10),
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(left: 20, top: 10, bottom: 5),
      width: MediaQuery.of(context).size.width * 0.50,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1)]),
      child: Text(
        '',
        style: AppStyles.inwardTextDATAStyle,
      ),
    );
  }

  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: SvgPicture.asset("assets/logo.svg",
                        height: 40, width: 40, semanticsLabel: 'Acme Logo'),
                  )),
              const Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 8.0),
                child: Text(
                  "CONFIRM START TRIP",
                  style: TextStyle(
                      fontFamily: appFontFamily,
                      color: AppColors.blueColor,
                      fontSize: 13),
                ),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "Are you sure you want to start\n the trip to destination?",
                textAlign: TextAlign.center,
                style: AppStyles.blackTextStyle),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          height: 40,
                          width: 130,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(5, 5),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: const Text(
                            'CANCEL',
                            style: TextStyle(color: Colors.white),
                          ))),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) => const InProgressPage())
                        //         );
                      },
                      child: Container(
                          height: 40,
                          width: 130,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(5, 5),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Colors.white),
                          ))),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppHelper.appBar(
          context, 'OPENING BALANCE', DespatchSummary(), Icons.arrow_back_ios),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 23, vertical: 13),
              height: MediaQuery.of(context).size.height * 0.82,
              width: double.infinity,
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            storageList[0],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            textFieldValue()
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            storageList[1],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            textFieldValue()
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            storageList[2],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            textFieldValue()
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            storageList[3],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            textFieldValue()
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            storageList[4],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            textFieldValue()
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            storageList[5],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            textFieldValue()
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            storageList[6],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            textFieldValue()
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            storageList[7],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            textFieldValue()
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            storageList[9],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            textFieldValue()
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
      bottomNavigationBar: InkWell(
        onTap: () {
          showAlert(context);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            color: AppColors.blueColor,
          ),
          alignment: Alignment.center,
          height: 60,
          child: Text(
            'START TRIP',
            style: AppStyles.submitButtonStyle,
          ),
        ),
      ),
    );
  }
}

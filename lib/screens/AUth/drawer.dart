import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:parsel_flutter/resource/app_helper.dart';
import 'package:parsel_flutter/resource/app_icons.dart';
import 'package:parsel_flutter/screens/AUth/Signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../models/GetuserbyID_model.dart';
import '../../resource/app_strings.dart';
import '../../resource/app_styles.dart';
import '../dashboard.dart';

class DrawerScreen extends StatefulWidget {
  DrawerScreen({Key? key, required this.onLogoutTap}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
  final VoidCallback onLogoutTap;
}

class _DrawerScreenState extends State<DrawerScreen> {
  int isSelected = 1;

  List<String> listTitle = [
    'DASHBOARD',
    'SUMMARY',
    'ESCALATE',
    'TRAINING TUTORIAL',
  ];

  dashboard() {
    Navigator.pop(context);
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (_) => DashBoardScreen()));
  }

  // sortingNavigation(context) {
  //   Navigator.push(context, MaterialPageRoute(builder: (_) => SortingScreen()));
  // }

  // packingListnavigation(context) {
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (_) => PackingListPage()));
  // }

  // storageNavigation(context) {
  //   Navigator.push(context, MaterialPageRoute(builder: (_) => StorageScreen()));
  // }
  bool _isLoading = false;
  String? username;
  @override
  void initState() {
    // getData();
    getUSERbyID(context);
    super.initState();
  }

  getData() async {
    final preference = await SharedPreferences.getInstance();
    preference.getString('userID');
  }

  Future getUSERbyID(BuildContext context) async {
    final preference = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    return await API
        .getUserById(context,
            USERID: preference.getString('userID').toString(),
            Authtoken: preference.getString('token').toString())
        .then(
      (GetuserbyID_model? response) async {
        setState(() {
          _isLoading = false;
        });
        //  print('rsponse-->' + response.toString());
        if (response != null) {
          //   print('rsponselist-->' + jsonDecode(response.body!.userDetails!.selectedWarehouseDetail));
          username = response.body!.userDetails!.username.toString();

          //  print('rsponsedata-->' + _listSWHD.toString());
          //  AppHelper.showSnackBar(context, AppStrings.strLoginSucessFully);
        } else {
          AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SafeArea(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Image.asset(
                      AppIcons.icCloseGray,
                      height: 20,
                      width: 20,
                    )),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi!',
                            style: TextStyle(
                                fontFamily: appFontFamily,
                                fontWeight: FontWeight.w800,
                                fontSize: 40,
                                color: AppColors.blueColor),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            username == null ? '' : username.toString(),
                            style: TextStyle(
                                fontFamily: appFontFamily,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: AppColors.black2Color),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                  onTap: () {
                    setState(() {
                      isSelected = 1;
                    });
                    dashboard();
                  },
                  child: isSelected == 1
                      ? Card(
                          color: ColorUtils.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          elevation: 5,
                          child: Container(
                            child: ListTile(
                              leading: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: SvgPicture.asset(
                                  AppIcons.icDashboard,
                                  semanticsLabel: 'Acme Logo',
                                  color: Colors.yellow,
                                ),
                              ),
                              title: Text(
                                listTitle[0],
                                style: AppStyles.dashBoardTextStyle
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ))
                      : Card(
                          color: Colors.grey.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          elevation: 5,
                          child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: SvgPicture.asset(
                                AppIcons.icDashboard,
                                semanticsLabel: 'Acme Logo',
                                color: AppColors.blueColor,
                              ),
                            ),
                            title: Text(
                              listTitle[0],
                              style: TextStyle(color: HexColor('#202020')),
                            ),
                          ))),
              // InkWell(
              //   onTap: () {
              //     setState(() {
              //       isSelected = 2;
              //     });

              //     AppHelper.changeScreen(context, DashBoardScreen());
              //     // sortingNavigation(context);
              //   },
              //   child: isSelected == 2
              //       ? Card(
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(6.0),
              //           ),
              //           color: blueColor,
              //           margin:
              //               EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //           elevation: 5,
              //           child: ListTile(
              //             leading: Padding(
              //               padding: const EdgeInsets.only(top: 5),
              //               child: SvgPicture.asset(
              //                 AppIcons.icSummary,
              //                 semanticsLabel: 'Acme Logo',
              //                 color: Colors.yellow,
              //               ),
              //             ),
              //             title: Text(
              //               listTitle[1],
              //               style: AppStyles.dashBoardTextStyle
              //                   .copyWith(color: Colors.white),
              //             ),
              //           ))
              //       : Card(
              //           color: Colors.grey.shade200,
              //           margin:
              //               EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //           elevation: 5,
              //           child: ListTile(
              //             leading: Padding(
              //               padding: const EdgeInsets.only(top: 5),
              //               child: SvgPicture.asset(AppIcons.icSummary,
              //                   semanticsLabel: 'Acme Logo'),
              //             ),
              //             title: Text(
              //               listTitle[1],
              //               style: AppStyles.dashBoardTextStyle,
              //             ),
              //           ),
              //         ),
              // ),
              // InkWell(
              //     onTap: () {
              //       setState(() {
              //         isSelected = 3;
              //       });
              //       // packingListnavigation(context);
              //     },
              //     child: isSelected == 3
              //         ? Card(
              //             color: blueColor,
              //             margin: EdgeInsets.symmetric(
              //                 horizontal: 20, vertical: 10),
              //             elevation: 5,
              //             child: ListTile(
              //               leading: Padding(
              //                 padding: const EdgeInsets.only(top: 5),
              //                 child: SvgPicture.asset(
              //                   AppIcons.icEscalate,
              //                   semanticsLabel: 'Acme Logo',
              //                   color: Colors.yellow,
              //                 ),
              //               ),
              //               title: Text(
              //                 listTitle[2],
              //                 style: AppStyles.dashBoardTextStyle
              //                     .copyWith(color: Colors.white),
              //               ),
              //             ))
              //         : Card(
              //             color: Colors.grey.shade200,
              //             margin: EdgeInsets.symmetric(
              //                 horizontal: 20, vertical: 10),
              //             elevation: 5,
              //             child: ListTile(
              //               leading: Padding(
              //                 padding: const EdgeInsets.only(top: 5),
              //                 child: SvgPicture.asset(AppIcons.icEscalate,
              //                     semanticsLabel: 'Acme Logo'),
              //               ),
              //               title: Text(
              //                 listTitle[2],
              //                 style: AppStyles.dashBoardTextStyle,
              //               ),
              //             ))),
              // InkWell(
              //     onTap: () {
              //       setState(() {
              //         isSelected = 4;
              //       });
              //       // storageNavigation(context);
              //     },
              //     child: isSelected == 4
              //         ? Card(
              //             color: blueColor,
              //             margin: EdgeInsets.symmetric(
              //                 horizontal: 20, vertical: 10),
              //             elevation: 5,
              //             child: ListTile(
              //               leading: Padding(
              //                 padding: const EdgeInsets.only(top: 5),
              //                 child: SvgPicture.asset(
              //                   AppIcons.icTrainingTutorials,
              //                   semanticsLabel: 'Acme Logo',
              //                   color: Colors.yellow,
              //                 ),
              //               ),
              //               title: Text(
              //                 listTitle[3],
              //                 style: AppStyles.dashBoardTextStyle
              //                     .copyWith(color: Colors.white),
              //               ),
              //             ))
              //         : Card(
              //             color: Colors.grey.shade200,
              //             margin: EdgeInsets.symmetric(
              //                 horizontal: 20, vertical: 10),
              //             elevation: 5,
              //             child:
              //                 //  Row(children: [

              //                 // ],)

              //                 ListTile(
              //               leading: Padding(
              //                 padding: const EdgeInsets.only(top: 5),
              //                 child: SvgPicture.asset(
              //                     AppIcons.icTrainingTutorials,
              //                     semanticsLabel: 'Acme Logo'),
              //               ),
              //               title: Text(listTitle[3],
              //                   style: AppStyles.dashBoardTextStyle),
              //             ))),

              InkWell(
                onTap: () async {
                  widget.onLogoutTap();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove("userlogined");
                  prefs.clear();
                  if (GlobalVariablesUtils.globalLocationStreamSub != null) {
                    // if (_locationStreamSub.isPaused) {}
                    GlobalVariablesUtils.globalLocationStreamSub!.cancel();
                    GlobalVariablesUtils.globalLocationStreamSub = null;
                  }
                  if (GlobalVariablesUtils.globalUpdateTimer != null) {
                    GlobalVariablesUtils.globalUpdateTimer!.cancel();
                  }
                  GlobalVariablesUtils.globalUpdateTimer = null;
                  AppHelper.changeScreen(context, SignupScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28.0, vertical: 30),
                  child: Text("Logout"),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

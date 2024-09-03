import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivered/view/delivered_item_screen.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/home/view/home_screen.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/args/in_progress_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/profile/view/profile_screen.dart';
import 'package:parsel_flutter/src/widget/bottom_bar/persistent_tab_view.dart';
import 'package:parsel_flutter/utils/utils.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key, required this.tabIndex}) : super(key: key);
  final int tabIndex;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  DateTime? currentBackPressTime;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.tabIndex != 0) {
        selectedIndex = widget.tabIndex;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map> bottomBarTabList = [
      {
        'label': LocaleKeys.home.tr(),
        'image_path': AssetUtils.homeIconImage,
      },
      {
        'label': LocaleKeys.orders.tr(),
        'image_path': AssetUtils.orderIconImage,
      },
      // {
      //   'label': LocaleKeys.inventory.tr(),
      //   'image_path': AssetUtils.inventoryIconImage,
      // },
      {
        'label': LocaleKeys.profile.tr(),
        'image_path': AssetUtils.profileIconImage,
      },
    ];
    EasyLocalization.of(context)?.setLocale(context.locale);
    return PopScope(
      canPop: false,
      onPopInvoked: (val) async {
        if (selectedIndex != 0) {
          selectedIndex = 0;
          setState(() {});
          return;
        }
        DateTime now = DateTime.now();

        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = now;

          Fluttertoast.showToast(msg: LocaleKeys.swipe_again_to_exit_app.tr());
        } else {
          // Exit the app after two consecutive back swipes within two seconds
          await SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: getPage(selectedIndex),
        bottomNavigationBar: BottomNavStyle3(
            navBarEssentials: NavBarEssentials(
                backgroundColor: Colors.transparent,
                navBarHeight: 63,
                selectedIndex: selectedIndex,
                items: List.generate(
                  bottomBarTabList.length,
                  (index) => PersistentBottomNavBarItem(
                    onPressed: (context) {
                      setState(() {
                        selectedIndex = index;
                      });
                      MixpanelManager.trackEvent(
                          eventName: 'DashboardTabClick',
                          properties: {'Tab': getTab(index)});
                    },
                    icon: Image.asset(
                      bottomBarTabList[index]['image_path'],
                      height: 20,
                      width: 20,
                      color: selectedIndex == index
                          ? ColorUtils.primaryColor
                          : ColorUtils.color3F3E3E,
                    ),
                    title: bottomBarTabList[index]['label'],
                    // activeColorPrimary: ColorUtils.primaryColor,
                    // inactiveColorPrimary: ColorUtils.color3F3E3E,
                    inactiveColorSecondary: ColorUtils.color3F3E3E,
                    activeColorSecondary: ColorUtils.primaryColor,
                  ),
                ))),
      ),
    );
  }

  Widget getPage(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return DeliveredItemScreen(
          deliveredArgs:
              InProgressArgs(navigateFrom: RouteUtilities.dashboardScreen),
        );
      // case 2:
      //   return const InventoryScreen();
      case 2:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }

  String getTab(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return 'HomeScreen';
      case 1:
        return 'DeliveredItemScreen';
      case 2:
        return 'InventoryScreen';
      case 3:
        return 'ProfileScreen';
      default:
        return 'HomeScreen';
    }
  }
}

class BottomNavStyle3 extends StatelessWidget {
  final NavBarEssentials? navBarEssentials;

  const BottomNavStyle3({
    Key? key,
    this.navBarEssentials = const NavBarEssentials(items: null),
  }) : super(key: key);

  Widget _buildItem(
      PersistentBottomNavBarItem item, bool isSelected, double? height) {
    return navBarEssentials!.navBarHeight == 0
        ? const SizedBox.shrink()
        : AnimatedContainer(
            width: 100.0,
            height: height! / 1.0,
            duration: navBarEssentials!.itemAnimationProperties?.duration ??
                const Duration(milliseconds: 1000),
            curve:
                navBarEssentials!.itemAnimationProperties?.curve ?? Curves.ease,
            alignment: Alignment.center,
            child: AnimatedContainer(
              // color: ColorUtils.primaryColor,
              duration: navBarEssentials!.itemAnimationProperties?.duration ??
                  const Duration(milliseconds: 1000),
              curve: navBarEssentials!.itemAnimationProperties?.curve ??
                  Curves.ease,
              alignment: Alignment.center,
              height: height / 1.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 5),
                  Expanded(
                    child: IconTheme(
                      data: IconThemeData(
                          size: item.iconSize,
                          color: isSelected
                              ? ColorUtils.primaryColor
                              : ColorUtils.color3F3E3E),
                      child: isSelected
                          ? item.icon
                          : item.inactiveIcon ?? item.icon,
                    ),
                  ),
                  const SizedBox(height: 7),
                  item.title == null
                      ? const SizedBox.shrink()
                      : FittedBox(
                          child: Text(item.title!,
                              style: FontUtilities.h12(
                                  fontColor: isSelected
                                      ? ColorUtils.primaryColor
                                      : ColorUtils.blackColor,
                                  fontWeight: FWT.medium)),
                        ),
                ],
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    double itemWidth = ((MediaQuery.of(context).size.width -
            ((navBarEssentials!.padding?.left ??
                    MediaQuery.of(context).size.width * 0.05) +
                (navBarEssentials!.padding?.right ??
                    MediaQuery.of(context).size.width * 0.05))) /
        navBarEssentials!.items!.length);
    return Container(
      width: double.infinity,
      height: navBarEssentials!.navBarHeight,
      decoration: BoxDecoration(color: ColorUtils.whiteColor, boxShadow: [
        BoxShadow(
            color: ColorUtils.blackColor.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: -2,
            offset: const Offset(0, -1.5))
      ]),
      padding: EdgeInsets.only(
          top: navBarEssentials!.padding?.top ?? 0.0,
          left: navBarEssentials!.padding?.left ??
              MediaQuery.of(context).size.width * 0.05,
          right: navBarEssentials!.padding?.right ??
              MediaQuery.of(context).size.width * 0.05,
          bottom: navBarEssentials!.padding?.bottom ??
              navBarEssentials!.navBarHeight! * 0.1),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              AnimatedContainer(
                duration: navBarEssentials!.itemAnimationProperties?.duration ??
                    const Duration(milliseconds: 300),
                curve: navBarEssentials!.itemAnimationProperties?.curve ??
                    Curves.ease,
                color: Colors.transparent,
                width: navBarEssentials!.selectedIndex == 0
                    ? MediaQuery.of(context).size.width * 0.0
                    : itemWidth * navBarEssentials!.selectedIndex!,
                height: 4.0,
              ),
              Flexible(
                child: AnimatedContainer(
                  duration:
                      navBarEssentials!.itemAnimationProperties?.duration ??
                          const Duration(milliseconds: 300),
                  curve: navBarEssentials!.itemAnimationProperties?.curve ??
                      Curves.ease,
                  width: itemWidth,
                  height: 4.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorUtils.primaryColor,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: navBarEssentials!.items!.map((item) {
                  int index = navBarEssentials!.items!.indexOf(item);
                  return Flexible(
                    child: GestureDetector(
                      onTap: () {
                        if (navBarEssentials!.items![index].onPressed != null) {
                          navBarEssentials!.items![index].onPressed!(
                              navBarEssentials!.selectedScreenBuildContext);
                        } else {
                          navBarEssentials!.onItemSelected!(index);
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: _buildItem(
                            item,
                            navBarEssentials!.selectedIndex == index,
                            navBarEssentials!.navBarHeight),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

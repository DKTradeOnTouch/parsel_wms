import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:parsel_flutter/src/mvp/auth/change_password/view/change_password_screen.dart';
import 'package:parsel_flutter/src/mvp/auth/forget_password/view/forget_password_screen.dart';
import 'package:parsel_flutter/src/mvp/auth/sign_in/view/sign_in_screen.dart';
import 'package:parsel_flutter/src/mvp/auth/sign_up/view/sign_up_screen.dart';
import 'package:parsel_flutter/src/mvp/dashboard/dashboard_screen.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivered/view/delivered_item_screen.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders/args/delivery_orders_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders/view/delivery_orders_screen.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders_summary/args/delivery_summary_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/order_review/view/order_review_screen.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders_summary/view/delivery_orders_summary_screen.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/dispatch_summary/args/dispatch_summary_agrs.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/dispatch_summary/view/dispatch_summary_screen.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/args/in_progress_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/view/in_progress_screen.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/map/view/map_screen.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/view/payment_screen.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/pending_orders/view/pending_orders_screen.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/proof_of_delivery/view/proof_of_delivery_screen.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/return_orders/args/return_order_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/return_orders/view/return_orders_screen.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/model/get_sku_group_by_user_id_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/view/select_pending_orders_screen.dart';
import 'package:parsel_flutter/src/mvp/dashboard/profile/view/edit_profile_screen.dart';
import 'package:parsel_flutter/src/mvp/language/view/change_langauge_screen.dart';
import 'package:parsel_flutter/src/mvp/language/view/select_language_screen.dart';
import 'package:parsel_flutter/src/mvp/on_boarding/view/on_boarding_screen.dart';
import 'package:parsel_flutter/src/mvp/splash/view/splash_screen.dart';

/// Manage all the routes used in the application.
class RouteUtilities {
  /// first screen to open in the application.
  static const String root = '/';

  /// On boarding screen.
  static const String onBoardingScreen = '/onBoardingScreen';

  /// home screen.
  static const String homeScreen = '/homeScreen';

  /// select language screen.
  static const String selectLanguageScreen = '/selectLanguageScreen';

  /// splash screen.
  static const String splashScreen = '/splashScreen';

  /// sign in screen.
  static const String signInScreen = '/signInScreen';

  /// sign up screen.
  static const String signUpScreen = '/signUpScreen';

  /// forget password screen.
  static const String forgotPasswordScreen = '/forgotPasswordScreen';

  /// dash board screen.
  static const String dashboardScreen = '/dashboardScreen';

  /// pending orders screen
  static const String pendingOrdersScreen = '/pendingOrdersScreen';

  /// select pending orders screen
  static const String selectPendingOrdersScreen = '/selectPendingOrdersScreen';

  /// dispatch summary screen
  static const String dispatchSummaryScreen = '/dispatchSummaryScreen';

  /// In Progress screen
  static const String inProgressScreen = '/inProgressScreen';

  /// Delivered screen
  static const String deliveredScreen = '/deliveredScreen';

  /// Delivery Orders screen
  static const String deliveryOrdersScreen = '/deliveryOrdersScreen';

  /// Delivery Orders Details screen
  static const String deliveryOrdersDetailsScreen =
      '/deliveryOrdersDetailsScreen';

  /// Delivery Orders Summary screen
  static const String deliveryOrdersSummaryScreen =
      '/deliveryOrdersSummaryScreen';

  /// Return Orders screen
  static const String returnOrdersScreen = '/returnOrdersScreen';

  /// Proof of delivery screen
  static const String proofOfDeliveryScreen = '/proofOfDeliveryScreen';

  /// Payment screen
  static const String paymentScreen = '/paymentScreen';

  /// Payment screen
  static const String mapScreen = '/mapScreen';

  /// Change Language Screen
  static const String changeLanguageScreen = '/changeLanguageScreen';

  /// Change Password Screen
  static const String changePasswordScreen = '/changePasswordScreen';

  /// Edit Profile Screen
  static const String editProfileScreen = '/editProfileScreen';

  /// we are using named route to navigate to another screen,
  /// and while redirecting to the next screen we are using this function
  /// to pass arguments and other routing things..
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    String routeName = settings.name ?? RouteUtilities.root;

    /// this is the instance of arguments to pass data in other screens.
    dynamic arguments = settings.arguments;
    switch (routeName) {
      case RouteUtilities.root:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashScreen(),
        );
      case RouteUtilities.splashScreen:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const SplashScreen(),
        );
      case RouteUtilities.selectLanguageScreen:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const SelectLanguageScreen(),
        );
      case RouteUtilities.onBoardingScreen:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const OnBoardingScreen(),
        );
      case RouteUtilities.signInScreen:
        return PageTransition(
          // duration: const Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: const SignInScreen(),
        );
      case RouteUtilities.signUpScreen:
        return PageTransition(
          // duration: const Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: const SignUpScreen(),
        );
      case RouteUtilities.forgotPasswordScreen:
        return PageTransition(
          // duration: const Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: const ForgetPasswordScreen(),
        );
      case RouteUtilities.dashboardScreen:
        final selectedIndex = (arguments == null) ? 0 : arguments;
        return PageTransition(
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: DashboardScreen(tabIndex: selectedIndex),
        );
      case RouteUtilities.pendingOrdersScreen:
        return PageTransition(
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: const PendingOrdersScreen(),
        );
      case RouteUtilities.selectPendingOrdersScreen:
        String warehouseName = arguments is String ? arguments : '';
        return PageTransition(
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: SelectPendingOrdersScreen(warehouseName: warehouseName),
        );
      case RouteUtilities.dispatchSummaryScreen:
        final getSkuGroupData =
            (arguments is GetSkuGroupData) ? arguments : null;

        return PageTransition(
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: DispatchSummaryScreen(
              getSkuGroupData: getSkuGroupData as GetSkuGroupData),
        );
      case RouteUtilities.inProgressScreen:
        final inProgressArgs = (arguments is InProgressArgs) ? arguments : null;
        return PageTransition(
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: InProgressScreen(
              inProgressArgs: inProgressArgs as InProgressArgs),
        );
      case RouteUtilities.deliveredScreen:
        final deliveredArgs = (arguments is InProgressArgs) ? arguments : null;
        return PageTransition(
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: DeliveredItemScreen(
              deliveredArgs: deliveredArgs as InProgressArgs),
        );

      case RouteUtilities.deliveryOrdersScreen:
        final deliveryOrdersArgs =
            (arguments is DeliveryOrdersArgs) ? arguments : null;

        return PageTransition(
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: DeliveryOrdersScreen(
              deliveryOrdersArgs: deliveryOrdersArgs as DeliveryOrdersArgs),
        );
      case RouteUtilities.deliveryOrdersDetailsScreen:
        final deliveryOrdersArgs =
            (arguments is DeliveryOrdersArgs) ? arguments : null;
        return PageTransition(
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: OrderReviewScreen(
              deliveryOrdersArgs: deliveryOrdersArgs as DeliveryOrdersArgs),
        );
      case RouteUtilities.deliveryOrdersSummaryScreen:
        final deliverySummaryArgs =
            (arguments is DeliverySummaryArgs) ? arguments : null;
        return PageTransition(
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: DeliveryOrdersSummaryScreen(
              deliverySummaryArgs: deliverySummaryArgs as DeliverySummaryArgs),
        );

      case RouteUtilities.returnOrdersScreen:
        final returnOrdersArgs =
            (arguments is ReturnOrdersArgs) ? arguments : null;
        return PageTransition(
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: ReturnOrdersScreen(
              returnOrdersArgs: returnOrdersArgs as ReturnOrdersArgs),
        );

      case RouteUtilities.proofOfDeliveryScreen:
        final deliveryOrdersArgs =
            (arguments is DeliveryOrdersArgs) ? arguments : null;
        return PageTransition(
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: ProofOfDeliveryScreen(
              deliveryOrdersArgs: deliveryOrdersArgs as DeliveryOrdersArgs),
        );
      case RouteUtilities.paymentScreen:
        final deliveryOrdersArgs =
            (arguments is DeliveryOrdersArgs) ? arguments : null;
        return PageTransition(
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: PaymentScreen(
              deliveryOrdersArgs: deliveryOrdersArgs as DeliveryOrdersArgs),
        );
      case RouteUtilities.mapScreen:
        return PageTransition(
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: const MapScreen(),
        );
      case RouteUtilities.changeLanguageScreen:
        return PageTransition(
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: const ChangeLanguageScreen(),
        );
      case RouteUtilities.changePasswordScreen:
        return PageTransition(
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: const ChangePasswordScreen(),
        );
      case RouteUtilities.editProfileScreen:
        return PageTransition(
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.fade,
          child: const EditProfileScreen(),
        );
    }
  }
}

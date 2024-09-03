import 'package:parsel_flutter/Provider/Delivery_Controller.dart';
import 'package:parsel_flutter/Provider/Invoice_Controller.dart';
import 'package:parsel_flutter/Provider/Process_controller.dart';
import 'package:parsel_flutter/src/mvp/auth/change_password/provider/change_password_provider.dart';
import 'package:parsel_flutter/src/mvp/auth/sign_in/provider/sign_in_provider.dart';
import 'package:parsel_flutter/src/mvp/auth/sign_up/provider/sign_up_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivered/provider/delivered_item_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders/provider/delivery_orders_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/order_review/provider/order_review_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders_summary/provider/delivery_orders_summary_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/dispatch_summary/provider/dispatch_summary_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/home/provider/home_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/provider/in_progress_item_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/map/provider/map_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/provider/payment_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/pending_orders/provider/pending_orders_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/proof_of_delivery/provider/proof_of_delivery_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/return_orders/provider/return_orders_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/provider/select_pending_orders_provider.dart';
import 'package:parsel_flutter/src/mvp/language/provider/select_language_provider.dart';
import 'package:parsel_flutter/src/mvp/on_boarding/provider/on_boarding_provider.dart';
import 'package:provider/provider.dart';

/// This class manage all the provider and return list of provider.
class ProviderBind {
  /// This is the list of providers to manage and attache with application.
  static List<ChangeNotifierProvider> providers = [
    ChangeNotifierProvider<InvoiceController>(
        create: (_) => InvoiceController()),
    ChangeNotifierProvider<ProcessController>(
        create: (_) => ProcessController()),
    ChangeNotifierProvider<DeliveryController>(
        create: (_) => DeliveryController()),
    ChangeNotifierProvider<SignInProvider>(create: (_) => SignInProvider()),
    ChangeNotifierProvider<SelectLanguageProvider>(
        create: (_) => SelectLanguageProvider()),
    ChangeNotifierProvider<OnBoardingProvider>(
        create: (_) => OnBoardingProvider()),
    ChangeNotifierProvider<SignUpProvider>(create: (_) => SignUpProvider()),
    ChangeNotifierProvider<PendingOrdersProvider>(
        create: (_) => PendingOrdersProvider()),
    ChangeNotifierProvider<SelectPendingOrdersProvider>(
        create: (_) => SelectPendingOrdersProvider()),
    ChangeNotifierProvider<DispatchSummaryProvider>(
        create: (_) => DispatchSummaryProvider()),
    ChangeNotifierProvider<InProgressItemProvider>(
        create: (_) => InProgressItemProvider()),
    ChangeNotifierProvider<DeliveredItemProvider>(
        create: (_) => DeliveredItemProvider()),
    ChangeNotifierProvider<DeliveryOrdersProvider>(
        create: (_) => DeliveryOrdersProvider()),
    ChangeNotifierProvider<OrderReviewProvider>(
        create: (_) => OrderReviewProvider()),
    ChangeNotifierProvider<DeliveryOrdersSummaryProvider>(
        create: (_) => DeliveryOrdersSummaryProvider()),
    ChangeNotifierProvider<ReturnOrdersProvider>(
        create: (_) => ReturnOrdersProvider()),
    ChangeNotifierProvider<ProofOfDeliveryProvider>(
        create: (_) => ProofOfDeliveryProvider()),
    ChangeNotifierProvider<PaymentProvider>(create: (_) => PaymentProvider()),
    ChangeNotifierProvider<MapProvider>(create: (_) => MapProvider()),
    ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
    ChangeNotifierProvider<ChangePasswordProvider>(
        create: (_) => ChangePasswordProvider()),
  ];
}

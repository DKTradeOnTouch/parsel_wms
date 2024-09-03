import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:parsel_flutter/screens/splash_page.dart';
import 'package:parsel_flutter/utils/database/database.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await ConnectivityHandler().initConnectivity();
  await DbHelper.initDatabase();
  VariableUtilities.preferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await MixpanelManager.init();

  FirebaseDatabase.instance.setPersistenceEnabled(true);
  runApp(EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('gu', 'IN'),
        Locale('hi', 'IN'),
        Locale('mr', 'IN')
      ],
      path: 'assets/translations',
      startLocale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      child: const ParselExchangeApp()));
}

class ParselExchangeApp extends StatefulWidget {
  const ParselExchangeApp({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ParselExchangeAppState();
  }
}

class ParselExchangeAppState extends State<ParselExchangeApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MultiProvider(
            providers: ProviderBind.providers,
            child: MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              // initialRoute: RouteUtilities.root,
              // onGenerateRoute: RouteUtilities.onGenerateRoute,
              debugShowCheckedModeBanner: false,
              title: 'Parsel',
              theme: ThemeData(
                  fontFamily: 'Roboto',
                  appBarTheme: AppBarTheme(
                      // backgroundColor: HexColor('#000000'),
                      foregroundColor:
                          HexColor('#FFFFFF') //here you can give the text color
                      ),
                  primarySwatch: Colors.grey,
                  primaryTextTheme: TextTheme(
                      titleLarge: TextStyle(color: HexColor('#0137FF')))),
              home: SplashPage(),
            ),
          );
        });
  }
}

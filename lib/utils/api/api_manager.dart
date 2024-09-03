part of parsel_exchange_apis;

typedef JSON = Map<String, dynamic>;

/// enum of apiTypes available to use.
enum APIType {
  /// post
  tPost,

  /// get
  tGet,

  /// put
  tPut,

  /// delete
  tDelete,

  ///
}

/// Base Class of the application to handle all APIS.
class APIManager {
  static String flavor =
      const String.fromEnvironment('flavor', defaultValue: "prod");

  static bool isProd = flavor == 'prod';

  /// base function of APIs.

  static Future<String> getDomain() async {
    print('isProd-> $isProd');
    String? email = '';
    String domain = '';

    bool isExists = VariableUtilities.preferences.containsKey('email');
    if (isExists) {
      email = VariableUtilities.preferences.getString('email') ?? '';
      String str = email.toString();
      const start = "@";
      const end = ".";
      final startIndex = str.indexOf(start);
      final endIndex = str.indexOf(end, startIndex + start.length);
      domain = str.substring(startIndex + start.length, endIndex);
      print('domain_final-->' + domain.toString());
    }
    return domain;
  }

  static Future<Either<dynamic, Exception>> callAPI(
    BuildContext context, {
    required String url,
    required APIType type,
    dynamic body,
    Map<String, String>? header,
    Map<String, dynamic>? parameters,
    String? currentScreenName,
  }) async {
    List<String>? listKeys = [];
    List<String>? listValues = [];

    if (parameters != null) {
      parameters.forEach((key, value) {
        listKeys.add(key);
        listValues.add(value);
      });
    }

    String? paramString = '';
    for (int i = 0; i < listKeys.length; i++) {
      if (i == 0) {
        paramString = paramString! + '?';
      }
      paramString = paramString! + listKeys[i] + '=' + listValues[i];

      if (i != listKeys.length - 1) {
        paramString = paramString + '&';
      }
    }
    List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      try {
        http.Response apiResponse;
        dynamic apiBody = body;
        Map<String, String> appHeader = {};
        if (url != APIUtilities.loginUrl && url != APIUtilities.signUpUrl) {
          String token = VariableUtilities.preferences
                  .getString(LocalCacheKey.userToken) ??
              '';
          String domain = await getDomain();

          appHeader.addAll({
            'X-TenantID': domain,
          });
          if (token != '') {
            appHeader.addAll({
              'Authorization': 'Bearer ' + token,
            });
          }
        } else {
          if (url == APIUtilities.loginUrl || url == APIUtilities.signUpUrl) {
            appHeader.addAll({
              'X-TenantID': body!['domain'],
            });
          }
        }

        if (header != null) {
          appHeader.addAll(header);
        }

        /// [POST CALL]
        if (type == APIType.tPost) {
          assert(body != null);
          String token = VariableUtilities.preferences
                  .getString(LocalCacheKey.userToken) ??
              '';
          String domain = await getDomain();

          appHeader.addAll({
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + token,
            'X-TenantID': domain,
          });

          apiResponse = await http.post(
            Uri.parse(url),
            body: jsonEncode(apiBody),
            headers: appHeader,
          );
          print("apiResponse --> ${apiResponse.body}");
        }

        /// [GET CALL]
        else if (type == APIType.tGet) {
          apiResponse = await http.get(
            Uri.parse(url + (paramString ?? '')),
            headers: appHeader,
          );
        }

        /// [PUT CALL]
        else if (type == APIType.tPut) {
          String token = VariableUtilities.preferences
                  .getString(LocalCacheKey.userToken) ??
              '';
          String domain = await getDomain();

          appHeader.addAll({
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + token,
            'X-TenantID': domain,
          });
          apiResponse = await http.put(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: appHeader,
          );
          debugPrint('apiResponse--> ${apiResponse.body}');
        }

        /// [DELETE CALL]
        else {
          apiResponse = await http.delete(Uri.parse(url),
              body: apiBody, headers: appHeader);
        }

        late Map<String, dynamic> response;

        switch (apiResponse.statusCode) {
          case 200:
            if (kDebugMode) {
              debugPrint('-----------------------------------------');
              debugPrint('URL --> $url${paramString ?? ''}');
              debugPrint('TYPE --> $type');
              debugPrint('APP HEADER --> $appHeader');
              debugPrint(
                  'STATUS CODE ---> ${apiResponse.statusCode.toString()}');
              debugPrint('BODY ---> $body');
              debugPrint('PARAMETER ---> $parameters');
              // log('RESPONSE ---> ${apiResponse.body}');
              debugPrint('-----------------------------------------');
            }
            response = jsonDecode(apiResponse.body);
            return Left(response);

          case 500:
            return Right(ServerException());

          case 404:
            return Right(PageNotFoundException());
          case 400:
            return Right(BadRequestException());

          case 401:
            await logoutOn401(context);
            // if (response['message'].toString() == "Request isn't authorized without token") {
            // await VariableUtilities.preferences
            //     .setBool(LocalCacheKey.isUserLogin, false);
            // if (currentScreenName != 'LoginScreen') {
            //   await Navigator.of(context).pushNamedAndRemoveUntil(
            //       RouteUtilities.root, (context) => false);
            // }
            return Right(AuthorizationException());
          default:
            return Right(GeneralAPIException());
        }
      } catch (e) {
        print("Exception while calling api $e");
        return Right(
          APIException(
            message: e.toString(),
          ),
        );
      }
    } else {
      Fluttertoast.showToast(msg: LocaleKeys.please_connect_with_internet.tr());
      NoInternetException();
      return Right(
        NoInternetException(),
      );
    }
  }
}

Future logoutOn401(BuildContext context) async {
  String selectedLanguage =
      VariableUtilities.preferences.getString(LocalCacheKey.selectedLanguage) ??
          '';
  MixpanelManager.trackEvent(
      eventName: 'ScreenView', properties: {'Screen': 'SignInScreen'});

  Navigator.pushNamedAndRemoveUntil(
      context, RouteUtilities.signInScreen, (route) => false);
  if (GlobalVariablesUtils.globalUpdateTimer != null) {
    GlobalVariablesUtils.globalUpdateTimer?.cancel();
  }
  VariableUtilities.preferences.clear();
  VariableUtilities.preferences
      .setBool(LocalCacheKey.isOnBoardingVisited, true);
  VariableUtilities.preferences.setBool(LocalCacheKey.isUserLogin, false);
  VariableUtilities.preferences
      .setString(LocalCacheKey.selectedLanguage, selectedLanguage);
  VariableUtilities.preferences.setBool(LocalCacheKey.isLanguageSelected, true);
}

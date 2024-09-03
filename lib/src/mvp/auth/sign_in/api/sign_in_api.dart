import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/src/mvp/auth/sign_in/model/sign_in_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

///User Sign In API CALL
Future<Either<SignInModel, Exception>> userSignInApi(BuildContext context,
    {required String email,
    required String password,
    required String domain}) async {
  Map<String, dynamic> body = {
    "phoneNumber": '',
    "email": email.toLowerCase().trim(),
    "password": password,
    "domain": domain
  };

  Either<dynamic, Exception> signInResponse = await APIManager.callAPI(context,
      url: APIUtilities.loginUrl, type: APIType.tPost, body: body);

  if (signInResponse.isLeft) {
    try {
      return Left(SignInModel.fromJson(signInResponse.left));
    } catch (e) {
      return Right(DataToModelConversionException());
    }
  } else {
    return Right(signInResponse.right);
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart' show Either, Right, Left;
import 'package:nhbp/common/errors/failure.dart';
import 'package:nhbp/model/login_model.dart';
import 'package:nhbp/network/helper/api_helper.dart';
import 'package:nhbp/network/network/base_repo.dart';

import '../../main.dart';

class Auth extends BaseRepository {
  final apiHelper = ApiHelper();

  Future<Either<Failure, LoginModel>> loginUser({
    required String email,
    required String password,
  }) async {
    return await isDeviceOffline()
        ? informDeviceIsOffline()
        : _loginUser(email: email, password: password);
  }

  Future<Either<Failure, LoginModel>> _loginUser({
    required String email,
    required String password,
  }) async {
    try {
      var body = {
        "email": email,
        "password": password,
      };

      var headers = {
        'Content-type': 'application/json;charset=UTF-8',
        'Accept': 'application/json;charset=UTF-8',
      };

      final response = await apiHelper.postHttpReq(
          url: ApiURL.login, headers: headers, body: body);
      var data = json.decode(response);
      if (data['data'] == null || !data['status']) {
        return Left(Failure(message: json.decode(response)['message']));
      } else if (data['status'])
        return Right(LoginModel.fromJson(response));
      else
        return Left(Failure(message: json.decode(response)['message']));
    } catch (e) {
      return Left(Failure(message: 'Cannot Login User'));
    }
  }
}

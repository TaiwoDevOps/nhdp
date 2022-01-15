import 'dart:convert';

import 'package:equatable/equatable.dart';

class LoginModel with EquatableMixin {
  bool? status;
  String? message;
  int? statusCode;
  Data? data;

  LoginModel({this.status, this.message, this.statusCode, this.data});

  LoginModel copyWith({
    Data? data,
    String? message,
    bool? status,
    int? statusCode,
  }) {
    return LoginModel(
        data: data ?? this.data,
        message: message ?? this.message,
        status: status ?? this.status,
        statusCode: statusCode ?? this.statusCode);
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'statusCode': statusCode,
      'data': data?.toMap(),
    };
  }

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    // if (map == null) return null ;

    return LoginModel(
      data: Data.fromMap(map['data']),
      message: map['message'],
      statusCode: map['statusCode'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginModel.fromJson(String source) =>
      LoginModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [status, message, statusCode, data];
}

class Data with EquatableMixin {
  String? email;
  String? accessToken;
  String? refreshToken;
  String? expires;

  Data({this.email, this.accessToken, this.refreshToken, this.expires});

  Data copyWith(
      {String? email,
      String? accessToken,
      String? refreshToken,
      String? expires}) {
    return Data(
      email: email ?? this.email,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expires: expires ?? this.expires,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expires': expires,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    // if (map == null) return null;

    return Data(
      email: map['email'],
      accessToken: map['accessToken'],
      refreshToken: map['refreshToken'],
      expires: map['expires'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) => Data.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [email, accessToken, refreshToken, expires];
}

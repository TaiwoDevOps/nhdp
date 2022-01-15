import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

class ServerException extends Equatable implements Exception {
  final String message;
  final int code;

  ServerException({
    this.message = 'Something unexpected has happened, we are sorry...',
    this.code = -1,
  });

  factory ServerException.fromResponse(
    Response response, {
    String? customMessage,
  }) {
    Map<String, dynamic> e = json.decode(response.body);
    final msg = e['message'] ?? 'Something unexpected has happened...';

    return ServerException(
      // try the api code first, and fallback to response if needed
      code: e['statusCode'] ?? response.statusCode,
      // try to use a local Custom message, or falltack to API message if needed
      message: customMessage ?? msg,
    );
  }

  @override
  List<Object> get props => [message, code];
}

class CacheException extends Equatable implements Exception {
  final String message;
  final int code;

  // If a cache error happens we'll need to publish a new version of the app
  // to fix it. This is why we ask the user to update his/her app
  CacheException({
    this.message = 'Ops, we are sorry. Please, try to update your app...',
    this.code = -1,
  });

  @override
  List<Object> get props => [message, code];
}

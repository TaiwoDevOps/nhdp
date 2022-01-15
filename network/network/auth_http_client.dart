import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nhbp/utils/navigator.dart';
import 'package:pedantic/pedantic.dart';

class AuthenticatedDioClient {
  // NavigationService navigationService;

  AuthenticatedDioClient() {
    _dio.options.responseType = ResponseType.plain;
    _dio.interceptors.add(InterceptorsWrapper(requestInterceptor));
  }

  final _dio = Dio();
  final _http = http.Client();

  // Use a memory cache to avoid local storage access in each call
  String _inMemoryToken = '';
  Future<String> get userAccessToken async {
    try {
      // use token availabe in memory if available
      if (_inMemoryToken.isNotEmpty) return _inMemoryToken;

      // otherwise load it from local storage
      _inMemoryToken = await _loadTokenFromSharedPreference();
    } catch (e) {
      //print(e.toString());
    }
    return _inMemoryToken;
  }

  Future<Response<T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final Response<T> resp = await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );

    unawaited(_logoutUserIfUnauthorized(response: resp));
    return resp;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    onReceiveProgress,
  }) async {
    final Response<T> resp = await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );

    unawaited(_logoutUserIfUnauthorized(response: resp));
    return resp;
  }

  Future<Response<T>> head<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final Response<T> resp = await _dio.head(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );

    unawaited(_logoutUserIfUnauthorized(response: resp));
    return resp;
  }

  Future<Response<T>> patch<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    onSendProgress,
    onReceiveProgress,
  }) async {
    final Response<T> resp = await _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    unawaited(_logoutUserIfUnauthorized(response: resp));
    return resp;
  }

  Future<Response<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    onSendProgress,
    onReceiveProgress,
  }) async {
    final Response<T> resp = await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    unawaited(_logoutUserIfUnauthorized(response: resp));
    return resp;
  }

  dynamic httpPost<T>(
    String path, {
    data,
    Map<String, String>? headers,
  }) async {
    final resp = await _http.post(
      Uri.parse(path),
      body: json.encode(data),
      headers: headers,
    );

    unawaited(_logoutUserIfUnauthorized(httpResponse: resp));

    return resp;
  }

  dynamic httpGet<T>(
    String path, {
    Map<String, String>? headers,
  }) async {
    final resp = await _http.get(
      Uri.parse(path),
      headers: headers,
    );

    unawaited(_logoutUserIfUnauthorized(httpResponse: resp));

    return resp;
  }

  Future<Response<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    onSendProgress,
    onReceiveProgress,
  }) async {
    final Response<T> resp = await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    unawaited(_logoutUserIfUnauthorized(response: resp));
    return resp;
  }

  Future<String> _loadTokenFromSharedPreference() async {
    try {
      var accessToken = '';

      // If user is already authenticated, we can load his token from cache

      return accessToken;
    } catch (e) {
      return '';
    }
  }

  // Don't forget to reset the cache when logging out the user
  void resetMemoryCachedToken() {
    _inMemoryToken = '';
  }

  Future<void> _logoutUserIfUnauthorized(
      {Response? response, http.Response? httpResponse}) async {
    final data = await LocalStorage.getLoginData();
    final isUserLoggedIn = data != null && data.data?.accessToken != null;

    if (response != null) {
      if (isUserLoggedIn && response.data == null) {
        resetMemoryCachedToken();
        navigator.popToFirst();
        showInfo("Unauthorized, please login to continue");

        navigator.replaceRoot(LoginPage());
      }
    } else {
      if (isUserLoggedIn && httpResponse!.body.isEmpty) {
        resetMemoryCachedToken();

        navigator.popToFirst();
        showInfo("Unauthorized, please login to continue");
        navigator.replaceRoot(LoginPage());
      }
    }
  }

  void requestInterceptor(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var token = await userAccessToken;

    if (token.isNotEmpty) {
      options.headers.putIfAbsent(
        'Authorization',
        () => 'Bearer $token',
      );
    }
    options.headers.putIfAbsent(
      'Content-type',
      () => 'application/json;charset=UTF-8',
    );
    options.headers.putIfAbsent(
      'Accept',
      () => 'application/json;charset=UTF-8',
    );

    return handler.next(options);
  }

  showInfo(_) async {
    await Fluttertoast.showToast(
        msg: _ ?? '',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.darkPurple,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

class InterceptorsWrapper extends Interceptor {
  Function(RequestOptions options, RequestInterceptorHandler handler)
      requestInterceptor;
  InterceptorsWrapper(this.requestInterceptor);

  @override
  void onRequest(RequestOptions o, RequestInterceptorHandler h) {
    return requestInterceptor(o, h);
  }

  @override
  void onResponse(Response res, ResponseInterceptorHandler handler) {
    return super.onResponse(res, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    return super.onError(err, handler);
  }
}

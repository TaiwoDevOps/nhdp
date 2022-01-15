import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;
  final int code;

  Failure({this.message = '', this.code = -1});

  @override
  List<Object> get props => [];
}

class LocalCacheFailure extends Failure {
  LocalCacheFailure({String message = '', int code = -1})
      : super(code: code, message: message);
}

class DeviceOfflineFailure extends Failure {
  DeviceOfflineFailure(
      {String message = 'Please, check your connection', int code = -1})
      : super(code: code, message: message);
}

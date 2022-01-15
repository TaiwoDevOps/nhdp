import 'package:connectivity/connectivity.dart';
import 'package:dartz/dartz.dart';
import 'package:nhbp/common/errors/failure.dart';
import 'package:nhbp/common/network/network_info.dart';

class BaseRepository {
  final NetworkInfo networkInfo = NetworkInfoImpl(Connectivity());

  // * Helper Functions
  Future<bool> isDeviceOffline() async {
    return (await networkInfo.isConnected);
  }

  Future<Either<Failure, T>> informDeviceIsOffline<T>() async {
    return Left<Failure, T>(DeviceOfflineFailure());
  }
}

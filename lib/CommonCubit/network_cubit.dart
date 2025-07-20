import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkCubit extends Cubit<bool> {
  final Connectivity _connectivity=Connectivity();

  // NetworkCubit() : super(true) {
    // _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
    //   // Check if there's any usable connection (mobile or wifi)
    //   final isConnected = results.contains(ConnectivityResult.mobile) || results.contains(ConnectivityResult.ethernet)||
    //       results.contains(ConnectivityResult.wifi);
    //   emit(isConnected);
    // });
  NetworkCubit() : super(true){
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result){
    emit(result!=ConnectivityResult.none);
  });
  _initialize();
  }
  void _initialize()async{
    final result=await _connectivity.checkConnectivity();
    emit(result!=ConnectivityResult.none);
  }


}

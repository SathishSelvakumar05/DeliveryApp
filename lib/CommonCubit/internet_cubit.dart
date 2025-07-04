import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'internet_state.dart';


class InternetCubit extends Cubit<loading> {
  final Connectivity? connectivity;
  StreamSubscription? connectivityStreamSubscription;
  InternetCubit({@required this.connectivity})
      : assert(connectivity != null),
        super(loading(false));
  bool isloading = false;
  checkInternetConnection() {
    try {
      connectivityStreamSubscription = connectivity!.onConnectivityChanged
          .listen((ConnectivityResult result) {
        if (result == ConnectivityResult.none) {
          emit(loading(false));
        } else {
          emit(loading(true));
        }
      });
    } catch (e) {
      throw e;
    }
  }

  void cancelInternetCheckSubscription() {
    connectivityStreamSubscription!.cancel();
  }
}


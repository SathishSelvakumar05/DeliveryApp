part of 'internet_cubit.dart';


enum ConnectionType {
  wifi,
  mobile,
}

@immutable
abstract class InternetState {}

class loading {
  bool? checkInternet;

  loading(this.checkInternet);
}

class InternetLoading extends InternetState {}

class InternetConnected extends InternetState {
  final ConnectionType? connectionType;

  InternetConnected({@required this.connectionType});
}

class InternetDisconnected extends InternetState {}

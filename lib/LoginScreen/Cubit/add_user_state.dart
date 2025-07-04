part of 'add_user_cubit.dart';

class AddUserState {
  final List<DeliverUser> users;

  AddUserState({this.users = const []});
}


class DeliverUser {
  final String? name;
  final String? mobile;
  final String? email;
  final String? address;
  final String? vehicleNumber;
  final String? idProof;
  final String? licenseDoc;

  DeliverUser({
    this.name,
    this.mobile,
    this.email,
    this.address,
    this.vehicleNumber,
    this.idProof,
    this.licenseDoc,
  });
}



part of 'add_delivery_cubit.dart';
class DeliveryState {
  final List<DeliveryModel> pickupDropList;
  final List<PurchaseDropModel> purchaseDropList;
  final List<ReservationModel> reservationList;

  DeliveryState({
    this.pickupDropList = const [],
    this.purchaseDropList = const [],
    this.reservationList = const [],
  });

  DeliveryState copyWith({
    List<DeliveryModel>? pickupDropList,
    List<PurchaseDropModel>? purchaseDropList,
    List<ReservationModel>? reservationList,
  }) {
    return DeliveryState(
      pickupDropList: pickupDropList ?? this.pickupDropList,
      purchaseDropList: purchaseDropList ?? this.purchaseDropList,
      reservationList: reservationList ?? this.reservationList,
    );
  }
}

class DeliveryModel {
  final String source;
  final String destination;
  final String description;
  final String? imagePath;

  DeliveryModel({
    required this.source,
    required this.destination,
    required this.description,
    this.imagePath,
  });
}

class PurchaseDropModel extends DeliveryModel {
  final String store;

  PurchaseDropModel({
    required String source,
    required String destination,
    required String description,
    required this.store,
    String? imagePath,
  }) : super(
    source: source,
    destination: destination,
    description: description,
    imagePath: imagePath,
  );
}

class ReservationModel extends DeliveryModel {
  final String reservationDate;
  final String reservationTime;

  ReservationModel({
    required String source,
    required String destination,
    required String description,
    required this.reservationDate,
    required this.reservationTime,
    String? imagePath,
  }) : super(
    source: source,
    destination: destination,
    description: description,
    imagePath: imagePath,
  );
}



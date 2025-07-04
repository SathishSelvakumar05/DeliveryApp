import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'add_delivery_state.dart';

class DeliveryCubit extends Cubit<DeliveryState> {
  DeliveryCubit() : super(DeliveryState());

  void addPickupDrop(DeliveryModel model) {
    final updatedList = [...state.pickupDropList, model];
    emit(state.copyWith(pickupDropList: updatedList));
  }

  void addPurchaseDrop(PurchaseDropModel model) {
    final updatedList = [...state.purchaseDropList, model];
    emit(state.copyWith(purchaseDropList: updatedList));
  }

  void addReservation(ReservationModel model) {
    final updatedList = [...state.reservationList, model];
    emit(state.copyWith(reservationList: updatedList));
  }
}


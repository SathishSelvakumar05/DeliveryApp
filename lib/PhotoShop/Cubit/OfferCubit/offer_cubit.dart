import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../Components/CustomToast/CustomToast.dart';
import '../../../main.dart';

part 'offer_state.dart';

class OfferCubit extends Cubit<OfferState> {
  OfferCubit() : super(OfferState(isOfferLoading: false,isOfferData: []));

  Future<void> fetchOffersPhotos() async {
    try {
      emit(OfferState(isOfferLoading: true,isOfferData: []));

      final response = await SupaBase.from('offers_table').select();

      final weddingData = (response as List)
          .map((e) => OfferTable.fromMap(e))
          .toList();

      emit(OfferState(isOfferLoading: false,isOfferData: weddingData));
      showErrorToast("offers data fetched");

    } catch (e) {
      print("ee");
      print(e);
      showErrorToast("$e");
      showErrorToast("failed to get offers data");
      emit(OfferState(isOfferLoading: false,isOfferData: []));
    }}

}

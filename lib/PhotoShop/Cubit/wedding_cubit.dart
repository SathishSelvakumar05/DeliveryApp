import 'package:bloc/bloc.dart';
import 'package:delivery_app/Components/CustomToast/CustomToast.dart';
import 'package:meta/meta.dart';

import '../../main.dart';
import '../Model/TableModel.dart';

part 'wedding_state.dart';

class WeddingCubit extends Cubit<WeddingState> {
  WeddingCubit() : super(WeddingState(isWeddingLoading: false,weddingdata: []));


  Future<void> fetchWeddingPhotos() async {
    try {
      emit(WeddingState(isWeddingLoading: true,weddingdata: []));

      final response = await SupaBase.from('wedding_table').select();

      final weddingData = (response as List)
          .map((e) => TableModel.fromMap(e))
          .toList();

      emit(WeddingState(isWeddingLoading: false,weddingdata: weddingData));
      showErrorToast("Wedding data fetched");

    } catch (e) {
      showErrorToast("failed to get wedding data");
      emit(WeddingState(isWeddingLoading: false,weddingdata: []));
    }}


}

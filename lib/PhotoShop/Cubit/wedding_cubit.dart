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
      // showErrorToast("CustomerChatScreen");

    } catch (e) {
      showErrorToast("failed to get data");
      emit(WeddingState(isWeddingLoading: false,weddingdata: []));
    }}


  /// Filter wedding photos by description
  // Future<void> filterByData(String search, {double? startPrice, double? endPrice}) async {
  //   try {
  //     emit(WeddingState(isWeddingLoading: true, weddingdata: []));
  //
  //     // Build base query
  //     var query = SupaBase.from('wedding_table').select();
  //
  //     // Add search filter if search is not empty
  //     if (search.isNotEmpty) {
  //       query= query.ilike('description', '%$search%');
  //     }
  //
  //     // Add price filter only if both start and end prices are given
  //     if (startPrice != null && endPrice != null) {
  //       query= query.gte('price', startPrice).lte('price', endPrice);
  //     }
  //
  //     // Execute query
  //     final response = await query;
  //
  //     // Map response to model
  //     final weddingData = (response as List)
  //         .map((e) => TableModel.fromMap(e))
  //         .toList();
  //
  //     emit(WeddingState(isWeddingLoading: false, weddingdata: weddingData));
  //
  //   } catch (e) {
  //     showErrorToast("Failed to filter wedding data: $e");
  //     emit(WeddingState(isWeddingLoading: false, weddingdata: []));
  //   }
  // }

  Future<void> filterByData(String search) async {
    try {
      emit(WeddingState(isWeddingLoading: true, weddingdata: []));

      final response = await SupaBase.from('wedding_table')
          .select()
          .ilike('description', '%$search%');

      final weddingData = (response as List)
          .map((e) => TableModel.fromMap(e))
          .toList();

      emit(WeddingState(isWeddingLoading: false, weddingdata: weddingData));
      // showErrorToast("Filtered data fetched");
    } catch (e) {
      showErrorToast("Failed to filter wedding data");
      emit(WeddingState(isWeddingLoading: false, weddingdata: []));
    }
  }


}

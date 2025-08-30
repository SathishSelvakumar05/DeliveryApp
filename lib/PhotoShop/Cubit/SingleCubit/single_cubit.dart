import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../Components/CustomToast/CustomToast.dart';
import '../../../main.dart';
import '../../Model/TableModel.dart';

part 'single_state.dart';

class SingleCubit extends Cubit<SingleState> {
  SingleCubit() : super(SingleState(isSingleLoading: false,singleData: []));


  Future<void> fetchSinglePhotos() async {
    try {
      emit(SingleState(isSingleLoading: true,singleData: []));

      final response = await SupaBase.from('single_photo_table').select();

      final weddingData = (response as List)
          .map((e) => TableModel.fromMap(e))
          .toList();

      emit(SingleState(isSingleLoading: false,singleData: weddingData));
      showErrorToast("Single data fetched");

    } catch (e) {
      showErrorToast("failed to get Single data");
      emit(SingleState(isSingleLoading: false,singleData: []));
    }}


}

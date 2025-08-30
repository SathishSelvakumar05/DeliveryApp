import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../Components/CustomToast/CustomToast.dart';
import '../../../main.dart';
import '../../Model/TableModel.dart';

part 'couple_state.dart';

class CoupleCubit extends Cubit<CoupleState> {
  CoupleCubit() : super(CoupleState(isCoupleLoading: false,coupleData: []));

  Future<void> fetchCouplePhotos() async {
    try {
      emit(CoupleState(isCoupleLoading: true,coupleData: []));

      final response = await SupaBase.from('couple_frame_table').select();

      final weddingData = (response as List)
          .map((e) => TableModel.fromMap(e))
          .toList();

      emit(CoupleState(isCoupleLoading: false,coupleData: weddingData));
       showErrorToast("Couple data fetched");

    } catch (e) {
      showErrorToast("failed to get Couple data");
      emit(CoupleState(isCoupleLoading: false,coupleData: []));
    }}


}

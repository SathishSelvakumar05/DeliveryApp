import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../Components/CustomToast/CustomToast.dart';
import '../../../main.dart';
import '../../Model/TableModel.dart';

part 'kids_state.dart';

class KidsCubit extends Cubit<KidsState> {
  KidsCubit() : super(KidsState(isKidsLoading: false,kidsData: []));


  Future<void> fetchKidsPhotos() async {
    try {
      emit(KidsState(isKidsLoading: true,kidsData: []));

      final response = await SupaBase.from('baby_kids_table').select();

      final weddingData = (response as List)
          .map((e) => TableModel.fromMap(e))
          .toList();

      emit(KidsState(isKidsLoading: false,kidsData: weddingData));
      showErrorToast("Kids data fetched");

    } catch (e) {
      showErrorToast("failed to get kids data");
      emit(KidsState(isKidsLoading: false,kidsData: []));
    }}

}

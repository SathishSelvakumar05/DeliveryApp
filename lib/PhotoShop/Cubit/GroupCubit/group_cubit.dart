import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../Components/CustomToast/CustomToast.dart';
import '../../../main.dart';
import '../../Model/TableModel.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(GroupState(isGroupLoading: false,isGroupData: []));



  Future<void> fetchGroupPhoto() async {
    try {
      emit(GroupState(isGroupLoading: true,isGroupData: []));

      final response = await SupaBase.from('group_photo_table').select();

      final weddingData = (response as List)
          .map((e) => TableModel.fromMap(e))
          .toList();

      emit(GroupState(isGroupLoading: false,isGroupData: weddingData));
      showErrorToast("Group data fetched");

    } catch (e) {
      showErrorToast("failed to get Group data");
      emit(GroupState(isGroupLoading: false,isGroupData: []));
    }}

}

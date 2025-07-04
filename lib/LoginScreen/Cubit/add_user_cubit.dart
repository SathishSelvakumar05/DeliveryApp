import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'add_user_state.dart';

class AddUserCubit extends Cubit<AddUserState> {
  AddUserCubit() : super(AddUserState());

 Future <void> addUser(DeliverUser user)async {
   print("ser.name");
   final updatedList = [...state.users, user];
    print("ser.name");
    print(user.name);
    print(user.mobile);
    emit(AddUserState(users: updatedList));
  }
  bool isMobileExists(String mobile) {
   print('ll');
   print(mobile);
   print(mobile);
    return state.users.any((user) {
      print(user.mobile);
      print(mobile);

      return user.mobile?.toLowerCase() == mobile.toLowerCase();});

  }}


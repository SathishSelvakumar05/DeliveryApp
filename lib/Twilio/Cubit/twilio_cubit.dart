import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'twilio_state.dart';

class TwilioCubit extends Cubit<TwilioState> {
  TwilioCubit() : super(TwilioState(isLoading: false));

  final Dio dio =Dio();

    makeCall(Map<String,dynamic>payload)async{
      try{
        emit(TwilioState(isLoading: true));

        final response=await dio.post("https://c2386ab8010a.ngrok-free.app/make_call/",data: payload);
        if(response.statusCode==200){//showSnackBar(context, "");
        }
      }catch(e){
      }
      finally{
        emit(TwilioState(isLoading: false));
      }

    }

}

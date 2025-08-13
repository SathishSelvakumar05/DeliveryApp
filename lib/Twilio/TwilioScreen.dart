import 'package:delivery_app/Components/CustomToast/CustomToast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../API_Handler/API Funtion.dart';
import 'Cubit/twilio_cubit.dart';

class Twilioscreen extends StatefulWidget {
  const Twilioscreen({super.key});

  @override
  State<Twilioscreen> createState() => _TwilioscreenState();
}

class _TwilioscreenState extends State<Twilioscreen> {
  final Map<String,dynamic>payload={
    "phone_number":"+919585394516",
    "message":"Hello Puja , Don't be Sad"
  };
  var _formKey = GlobalKey<FormState>();
  final Dio dio=Dio();
  @override
  void initState() {
    // TODO: implement initState
    // postData(payload);
    super.initState();
  }
  ApplyPayload(String data){
    payload["message"]=data;
    print(payload);
    makeCall();
  }
  // Future<void> postData(Map<String, dynamic>payload) async {
  //   final dio = ApiClient().client;
  //
  //   try {
  //     final response = await dio.post(
  //       "https://3b8a05e1ada4.ngrok-free.app/make_call/",
  //       // 'http://192.168.0.134:8000/make_call/',
  //       data: payload
  //     );
  //     // 'http://192.168.1.5:8000/make_call/',
  //
  //      print('🔽 Final Response Body: ${response.data}');
  //   } catch (e) {
  //     print('❗ Exception occurred: $e');
  //   }
  // }
  postData(Map<String,dynamic>payload)async{
    try{
      print("comes");
      final response=await dio.post("https://c2386ab8010a.ngrok-free.app/make_call/",data: payload);
      if(response.statusCode==200){
        print("dataa");
        print("${response.data}");
        final content=SnackBar(content: Text("message sent successfully"),);
        ScaffoldMessenger.of(context).showSnackBar(content);
        //showSnackBar(context, "");
      }
    }catch(e){
      if(!mounted)return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("failed to send a call",style: TextStyle(color: Colors.red),)));
    }

  }
  TextEditingController msgController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // GestureDetector(
              //   onTap: (){
              //     postData(payload);
              //   },
              //   child: Center(
              //     child: Text("Data"),
              //   ),
              // ),
              BlocBuilder<TwilioCubit,TwilioState>(
                builder: (context, state) {
                  if(state.isLoading!){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Enter the Number"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: "+919585394516",
                        decoration: InputDecoration(
                          hintText: "Enter number",
                          prefixIcon: Icon(Icons.call,size: 20.sp,),
                          labelText: "",
                          filled: true,
                          fillColor: Colors.blueAccent.withOpacity(0.1),
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
                          ),
                          hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                          labelStyle: TextStyle(fontSize: 14.sp, color: Colors.blueAccent),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14.sp),readOnly: true,
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    Text("Enter the Message"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter message",
                          labelText: "",
                          // prefixIcon: Icon(Icons.message,size: 20.sp,),
                          filled: true,
                          fillColor: Colors.blueAccent.withOpacity(0.1),
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8).r,
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8).r,
                            borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
                          ),
                          hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                          labelStyle: TextStyle(fontSize: 14.sp, color: Colors.blueAccent),
                        ),
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 14.sp),maxLines: 3,maxLength: 600,
                        controller: msgController,
                        validator: (val){
                          if(val==null||val.isEmpty){
                            return "Value can't be empty";}
                          else{
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    Center(
                      child: GestureDetector(
                        onTap: (){
                          if(_formKey.currentState!.validate()){
                            print('object');
                            // ApplyPayload(msgController.text.trim());
                          }
                        },
                        child: Container(
                          width: 160.w,
                          padding: EdgeInsets.only(left: 0,top: 5,bottom: 5),
                          decoration: BoxDecoration(color: Colors.black12,borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Text("Make Call"),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },)
            ],
          ),
        ),
      ),
    );
  }
  makeCall()async{
    try{
      await context.read<TwilioCubit>().makeCall(payload);
      final content=SnackBar(content: Text("message sent successfully"),);
      ScaffoldMessenger.of(context).showSnackBar(content);
    }catch(e){
      final content=SnackBar(content: Text("message not sent"),);
      ScaffoldMessenger.of(context).showSnackBar(content);
    }

  }
}



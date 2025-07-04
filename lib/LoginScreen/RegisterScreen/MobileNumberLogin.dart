import 'package:delivery_app/Components/CustomToast/CustomToast.dart';
import 'package:delivery_app/CustomerScreen/CustomerDashboard/CustomerDashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import '../../Components/Button/CustomButton.dart';
import '../Cubit/add_user_cubit.dart';
import 'AddRegister.dart';


class MobileLoginScreen extends StatefulWidget {
  final String Role;
  const MobileLoginScreen({super.key,required this.Role});

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool isOtpStage = false;
  bool isLoading = false;

  void _submitMobile() {
    if (_mobileController.text.length == 10) {
      setState(() {
        isOtpStage = true;
        _otpController.text='';
      });
    } else {
      _showSnackbar("Enter a valid 10-digit mobile number.");
    }
  }

  Future <void>_submitOtp()async {
    if (_otpController.text.length == 6) {
      // try{}catch(e){}
      setState(() {
        isOtpStage = true;

        isLoading=true;
      });
      _showSnackbar("OTP submitted. Redirecting...");
     await Future.delayed(const Duration(seconds: 2), () {
        final exists = context.read<AddUserCubit>().isMobileExists(_mobileController.text);
        if(!exists){
          return showErrorToast('User Not Found . Please Signup');
        }
        else{
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(),
            ),
                (route) => false,
          );

          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (_) =>  DashboardScreen()),
          // );
        }
      });
      setState(() {
        isLoading=false;
      });
    } else {
      _showSnackbar("Enter a valid 6-digit OTP.");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login with Mobile"),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(isOtpStage)
                if (isOtpStage)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _mobileController.text,
                            style:  TextStyle( letterSpacing: 1.5,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isOtpStage = false;
                            });
                          },
                          child: const Text(
                            'Re-enter mobile number',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              if (!isOtpStage)
              Column(children: [
                TextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Mobile Number",
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 10,
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  text: "Submit",
                  // width: 200.w,
                  onPressed: _submitMobile,
                  isLoading: false,
                  buttonType: ButtonType.elevated,
                ),
              ],)
              else
                Column(
                  children: [
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Enter OTP",
                        border: OutlineInputBorder(),
                      ),
                      maxLength: 6,
                    ),
                    const SizedBox(height: 20),
                   CustomElevatedButton(
                      text: "Verify OTP",
                      // width: 200.w,
                      onPressed: (){
                        _submitOtp();
                      },
                      isLoading: isLoading,
                      buttonType: ButtonType.elevated,
                    ),
                  ],
                ),
              SizedBox(height: 20.h,),
              Text('Does not have any account'),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddUserScreen(title: widget.Role),));
              }, child: Text('SignUp'))

            ],
          ),
        ),
      ),
    );
  }
}



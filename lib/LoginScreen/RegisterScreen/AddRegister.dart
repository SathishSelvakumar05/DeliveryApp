import 'package:delivery_app/LoginScreen/Cubit/add_user_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../Components/Button/CustomButton.dart';
import '../../Components/Textfield/CustomMobileNumber.dart';
import '../../Components/Textfield/CustomTextField.dart';
import '../../CustomerScreen/CustomerDashboard/CustomerDashboard.dart';
import '../../CustomerScreen/UserListScreen.dart';
import 'MobileNumberLogin.dart';

class AddUserScreen extends StatefulWidget {
  final String title;
  AddUserScreen({super.key, required this.title});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController phoneController = TextEditingController();

  bool isLoading=false;
  @override
  void dispose() {
    _formKey.currentState?.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff5f5f5),
        appBar: AppBar(
            backgroundColor: Color(0xfff5f5f5),
            title: Text("Add ${widget.title}")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: ListView(
              children: [
                CustomTextField(icon: Icons.person,
                  name: 'name',
                  labelName: 'Name',
                  placeHolder: 'Enter Name',
                  validators: [
                    FormBuilderValidators.required(
                        errorText: 'Name is required')
                  ],
                ),
                PhoneNumberField(
                    name: "phonenumber",
                    labelName: "Mobile Number",
                    textEditingController: phoneController,
                    validators: [
                      FormBuilderValidators.required(
                          errorText: 'Mobile Number is required'),
                          (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone Number is required';
                        }
                        return null;
                      }
                    ]),
                // CustomTextField(
                //   name: 'mobile',
                //   labelName: 'Mobile Number',
                //   placeHolder: 'Enter Mobile Number',
                //   validators: [
                //     FormBuilderValidators.required(
                //         errorText: 'Mobile is required')
                //   ],
                // ),
                CustomTextField(
                  icon: Icons.email,
                  name: 'email',
                  labelName: 'Email',
                  placeHolder: 'Enter Email',
                  validators: [
                    FormBuilderValidators.required(
                        errorText: 'Email is required')
                  ],
                ),
                CustomTextField(
                  icon:  Icons.location_on,
                  name: 'address',
                  labelName: 'Address',
                  placeHolder: 'Enter Address',
                  required: false,
                  // validators: [
                  //   FormBuilderValidators.required(
                  //       errorText: 'Address is required')
                  // ],
                ),
                if (widget.title == "Delivery Agent")
                  Column(
                    children: [
                      CustomTextField(
                        icon: Icons.directions_car,
                        name: 'vehicleNumber',
                        labelName: 'Vehicle Number',
                        placeHolder: 'Enter Vehicle Number',
                        validators: [
                          FormBuilderValidators.required(errorText: 'Vehicle Number is Required')
                        ],
                      ),
                      CustomTextField(
                        icon:  Icons.credit_card,
                        name: 'idProof',
                        labelName: 'ID Proof',
                        placeHolder: 'Enter Aadhaar No / Vote ID',
                        validators: [
                          FormBuilderValidators.required(errorText: 'ID Proof is Required')
                        ],
                      ),
                      CustomTextField(
                        icon: Icons.document_scanner, // or Icons.assignment_ind
                        name: 'licenseDoc',
                        labelName: 'License Document',
                        placeHolder: 'Enter License Document',
                        validators: [
                          FormBuilderValidators.required(errorText: 'License Document is Required')
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16).r,
            decoration: BoxDecoration(
              color:Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomElevatedButton(
                  text: 'Cancel',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  buttonType: ButtonType.outlined,
                ),
                SizedBox(
                  width: 10.w,
                ),
                CustomElevatedButton(
                  text: "Save ${widget.title}",
                  width: 200.w,
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      final formData = _formKey.currentState!.value;
                      DeliverUser user;
                      String fullNumber = phoneController.text.toString();
                      String mobileNumber = fullNumber.substring(fullNumber.length - 10);
                      if (widget.title == "Delivery Agent") {
                        print(phoneController.text.toString());
                        print(mobileNumber);
                         user = DeliverUser(
                          name: formData['name'],
                          mobile:mobileNumber,
                          email: formData['email'],
                          address: formData['address'],
                          vehicleNumber: formData['vehicleNumber'],
                          idProof: formData['idProof'],
                          licenseDoc: formData['licenseDoc'],
                        );
                         SubmitFunction(user);

                      } else {
                         user = DeliverUser(
                          name: formData['name'],
                          mobile: mobileNumber,
                          email: formData['email'],
                          address: formData['address'],
                          // vehicleNumber: formData['vehicleNumber'],
                          // idProof: formData['idProof'],
                          // licenseDoc: formData['licenseDoc'],
                        );
                         SubmitFunction(user);

                      }

                    }
                  },
                  isLoading: isLoading,
                  buttonType: ButtonType.elevated,
                ),
              ],
            ),));
  }
  Future <void>SubmitFunction(DeliverUser user)async{
    print('object');
    print(user.name);
    try{
      await context.read<AddUserCubit>().addUser(user);

      setState(() {
        isLoading=true;
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => MobileLoginScreen(Role: widget.title,),));
      _formKey.currentState?.reset();


      setState(() {
        isLoading=false;
      });
    }catch(e){
      setState(() {
        isLoading=false;
      });
    }
  }
}

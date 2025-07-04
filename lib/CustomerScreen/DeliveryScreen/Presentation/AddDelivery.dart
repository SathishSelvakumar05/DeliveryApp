import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../Components/Button/CustomButton.dart';
import '../../../Components/Textfield/CustomDescriptionField.dart';
import '../../../Components/Textfield/CustomTextField.dart';
import '../../../Utils/Constants/TextConstants.dart';
import '../Cubit/add_delivery_cubit.dart';

class DeliveryForm extends StatefulWidget {
  final String type;
   DeliveryForm({required this.type});

  @override
  State<DeliveryForm> createState() => _DeliveryFormState();
}

class _DeliveryFormState extends State<DeliveryForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      icon: Icons.location_on,
                      name: 'source',
                      labelName: 'Source',
                      placeHolder: 'Enter Pickup Location',
                      validators: [FormBuilderValidators.required()],
                    ),
                    CustomTextField(
                      icon: Icons.flag,
                      name: 'destination',
                      labelName: 'Destination',
                      placeHolder: 'Enter Drop Location',
                      validators: [FormBuilderValidators.required()],
                    ),
                    if (widget.type == "purchase_drop") ...[
                      CustomTextField(
                        icon: Icons.store,
                        name: 'store',
                        labelName: 'Store',
                        placeHolder: 'Which store to purchase from?',
                        validators: [FormBuilderValidators.required()],
                      ),
                    ],
                    if (widget.type == "reservation") ...[
                      CustomTextField(
                        icon: Icons.calendar_today,
                        name: 'reservationDate',
                        labelName: 'Reservation Date',
                        placeHolder: 'Enter reservation date',
                        validators: [FormBuilderValidators.required()],
                      ),
                      CustomTextField(
                        icon: Icons.watch_later,
                        name: 'reservationTime',
                        labelName: 'Reservation Time',
                        placeHolder: 'Enter reservation time',
                        validators: [FormBuilderValidators.required()],
                      ),
                    ],
                    _buildField(
                      TextConstants.description,
                      TextConstants.description,
                      4,
                      false,
                      '',
                      context,
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(width: 10.w),
                        CustomElevatedButton(
                          text: "Save",
                          width: 200.w,
                          onPressed: () {
                            if (_formKey.currentState?.saveAndValidate() ?? false) {
                              final cubit = context.read<DeliveryCubit>();
                              final formData = _formKey.currentState!.value;

                              if (widget.type == "pickup_drop") {
                                cubit.addPickupDrop(DeliveryModel(
                                  source: formData['source'],
                                  destination: formData['destination'],
                                  description: formData[TextConstants.description],
                                  imagePath: formData['imagePath'] ?? '',
                                ));
                              } else if (widget.type == "purchase_drop") {
                                cubit.addPurchaseDrop(PurchaseDropModel(
                                  source: formData['source'],
                                  destination: formData['destination'],
                                  description: formData[TextConstants.description],
                                  store: formData['store'],
                                  imagePath: formData['imagePath'] ?? '',
                                ));
                              } else if (widget.type == "reservation") {
                                cubit.addReservation(ReservationModel(
                                  source: formData['source'],
                                  destination: formData['destination'],
                                  description: formData[TextConstants.description],
                                  reservationDate: formData['reservationDate'],
                                  reservationTime: formData['reservationTime'],
                                  imagePath: formData['imagePath'] ?? '',
                                ));
                              }

                            } else {
                              debugPrint("Form validation failed");
                            }
                          },
                          isLoading: false,
                          buttonType: ButtonType.elevated,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildField(String name, String labelName, int? maxlines,
      bool? isRequired, String initialValue,BuildContext context) {
    return CustomDescriptionField(
      MaxLines: labelName == TextConstants.description ? 4 : null,
      Maxlength: labelName == TextConstants.description ? 120 : null,
      name: name,
      placeHolder: '',
      initialValue: initialValue.isEmpty ? '' : initialValue,
      labelName: labelName,
      validators: [
        // if (isDescRequired)
        //   FormBuilderValidators.required(errorText: 'Remarks is required'),
        // if (isDescRequired)
        //   FormBuilderValidators.minLength(4,
        //       errorText: 'Minimum 4  character is required'),
      ],
      required: isRequired,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Colors.black,
      ),
    );
  }

}

class CustomImagePickerField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Upload Image"),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {
            // Implement image picker logic
          },
          icon: const Icon(Icons.image),
          label: const Text("Choose File"),
        ),
      ],
    );
  }

  }



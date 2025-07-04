import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../Utils/Constants/TextStyles.dart';
import '../CommonFunctions.dart';

class PhoneNumberField extends StatefulWidget {
  final String name;
  final String? initialValue;
  final String? labelName;
  final bool? readOnly;
  final List<String? Function(String?)> validators;
  final TextEditingController? textEditingController;
  final Function(String?)? onChanged;
  final bool? required;

  const PhoneNumberField(
      {super.key,
        required this.name,
        this.initialValue,
        this.labelName,
        required this.validators,
        this.readOnly = false,
        this.textEditingController,
        this.onChanged,
        this.required = true});

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

const countryCodeLengths = {
  'AU': 9, // Australia
  'CX': 15, // Christmas Island
  'CC': 15, // Cocos (Keeling) Islands
};

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  String localPhoneNumber = '';
  String? selectedCountryCode = '';

  @override
  void initState() {
    super.initState();
    if (widget.textEditingController != null &&
        widget.textEditingController!.text != '') {
      localPhoneNumber = widget.textEditingController!.text
          .toString()
          .replaceAll("+", "")
          .split('-')[1];
      selectedCountryCode = widget.textEditingController!.text
          .toString()
          .replaceAll("+", "")
          .split('-')[0];
    } else {
      localPhoneNumber = '0';
      selectedCountryCode = '91';
    }
  }

  String getCorrectCountry(String dialCode, String phoneNumber) {
    for (var entry in countryCodeLengths.entries) {
      if (entry.key == 'AU' && phoneNumber.length == entry.value) {
        return 'AU'; // Australia
      } else if (entry.key == 'CX' && phoneNumber.length == entry.value) {
        return 'CX'; // Christmas Island
      } else if (entry.key == 'CC' && phoneNumber.length == entry.value) {
        return 'CC'; // Cocos (Keeling) Islands
      }
    }
    return 'AU'; // Default fallback
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelName != null) ...[
          Row(
            children: [
              Text(
                capitalizeFirstLetter(widget.labelName!),
                style: TextStyleClass.textSize14(color:Colors.black),
              ),
              SizedBox(
                width: 5.w,
              ),
              if (widget.required!)
                Text(
                  ' *',
                  style: TextStyleClass.textSize13(
                    color: Colors.red.shade400,
                  ),                )
            ],
          ),
          SizedBox(height: 7.h),
        ],
        FormBuilderField(
          name: widget.name,
          enabled: true,
          builder: (FormFieldState<dynamic> field) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    IntlPhoneField(
                      // showCountryFlag: widget.textEditingController != null &&
                      //     widget.textEditingController!.text.isNotEmpty
                      //     ? true
                      //     : false,
                      // controller: widget.textEditingController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      initialCountryCode:
                      widget.textEditingController != null &&
                          widget.textEditingController!.text != ''
                          ? null
                          : 'IN',
                      initialValue: widget.textEditingController != null &&
                          widget.textEditingController!.text != ''
                          ? "+$selectedCountryCode$localPhoneNumber"
                          : null,
                      readOnly: widget.readOnly!,
                       showCountryFlag: true,
                      style: TextStyleClass.textSize15(color: Colors.black),
                      decoration: InputDecoration(
                        errorStyle: TextStyleClass.textSize12(
                          color: Colors.redAccent.shade100,
                        ),
                        hintText: "Mobile Number",
                        hintStyle: TextStyleClass.textSize15(color: Theme.of(context).hintColor),
                        // prefixIcon: const Icon(Icons.phone),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0).r,
                          borderSide: BorderSide.none,
                        ),
                        // focusedBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //       color: Colors.redAccent),
                        //   borderRadius: BorderRadius.circular(12.0).r,
                        // ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0)
                            .r,
                      ),
                      onCountryChanged: (country) {
                        field.didChange(
                            "+${country.dialCode}-$localPhoneNumber");

                        widget.textEditingController!.text =
                        "+${country.dialCode}-$localPhoneNumber";
                      },
                      // showCountryFlag: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (phone) {
                        setState(() {
                          localPhoneNumber = phone!.number;
                        });
                        if (localPhoneNumber.isEmpty) {
                          field.didChange(null);
                        }
                      },
                      showDropdownIcon: false,
                      // invalidNumberMessage: localPhoneNumber.isEmpty
                      //     ? "ssssssssss"
                      //     : "ssssssssssssssssssssss",
                      // disableLengthCheck: true,
                      //  countries: [Country(name: 'AED', flag: 'AED', code: "+91", dialCode: "91", minLength: 9, maxLength: 10, nameTranslations: {})],
                      cursorHeight: 20.h,

                      // invalidNumberMessage: "ssssss",
                      onChanged: (phone) {
                        field.didChange("${phone.countryCode}-${phone.number}");
                        selectedCountryCode = phone.countryCode;
                        localPhoneNumber = phone.number;
                        field.validate();
                        widget.textEditingController!.text =
                        "${phone.countryCode}-${phone.number}";
                      },
                      validator: widget.validators.isNotEmpty
                          ? FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: 'Phone number is Required',
                        ),
                            (value) {
                          if (localPhoneNumber.isEmpty) {
                            return 'sss'; // Custom error message
                          }
                          return null; // Validation passed
                        },
                      ])
                          : null,
                    ),
                    if (field.value == null && localPhoneNumber.isEmpty)
                      Positioned(
                        left: 10,
                        bottom: 0,
                        child: Text(
                          "Mobile Number is Required",
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.redAccent.shade100),
                        ),
                      )
                  ],
                ),
                SizedBox(height: 10.sp),
              ],
            );
          },
          onChanged: widget.onChanged,
        )
      ],
    );
  }
}

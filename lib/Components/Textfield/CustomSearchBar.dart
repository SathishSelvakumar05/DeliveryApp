import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Utils/Constants/ColorConstants.dart';
import '../../Utils/Constants/TextConstants.dart';
import '../../Utils/Constants/TextStyles.dart';

class CustomSearchBox extends StatefulWidget {
  final String placeHolderName;
  final IconData? suffixicon;
  final TextEditingController? textEditingController;
  final void Function(String) onTextChanged;
  final FocusNode? textFieldFocusNode;

  const CustomSearchBox(
      {super.key,
      required this.placeHolderName,
      required this.onTextChanged,
      this.suffixicon, this.textEditingController, this.textFieldFocusNode});

  @override
  State<CustomSearchBox> createState() => _CustomSearchBoxState();
}

class _CustomSearchBoxState extends State<CustomSearchBox> {
  final FocusNode _textFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0).r,
      child: FormBuilderTextField(
        focusNode:widget.textFieldFocusNode??_textFieldFocusNode,
        autofillHints: const [AutofillHints.name],
        key:  Key(TextConstants.searchbar),
        name: TextConstants.searchbar,
        controller: widget.textEditingController!,
        style: TextStyleClass.textSize14Bold( color: Theme.of(context).hintColor),
        autofocus: false,
        decoration: InputDecoration(
          hintText: widget.placeHolderName,
          suffixIcon: Icon(
            widget.suffixicon,
            color: Colors.grey.shade500,
          ),
          hintStyle: TextStyleClass.textSize14Bold(color: Theme.of(context).dividerColor),
          prefixIconColor: Colors.grey,
          prefixIcon: Icon(
            Icons.search,
            size: 30.sp,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          // prefixIcon: Icon(Icons.person_search,color: Theme.of(context).hintColor,size: 22.sp,),
          fillColor: Theme.of(context).cardColor,
          filled: true,
          focusColor: KConstantColors.primaryColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0).r,
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0).r,
        ),
        onChanged: (value) {
          widget.onTextChanged(value ?? '');
        },
      ),
    );
  }
}

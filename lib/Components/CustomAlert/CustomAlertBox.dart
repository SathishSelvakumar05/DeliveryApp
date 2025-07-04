import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Utils/Constants/TextStyles.dart';

void showCustomDialog({
  required BuildContext context,
  required String title,
  required String noText,
  required String yesText,
  required VoidCallback noFunction,
  required VoidCallback yesFunction,
}) {
  showCupertinoDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title, style: TextStyleClass.textSize16( color: Theme.of(context).hintColor),),
      actions: [
        CupertinoDialogAction(
          child: Text(noText, style: TextStyleClass.textSize18(color: Colors.red)),
          onPressed:
            noFunction
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: Text(yesText, style: TextStyleClass.textSize18(color:Theme.of(context).hintColor)),
          onPressed:yesFunction
        ),
      ],
    ),
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Utils/Constants/ColorConstants.dart';
import '../../../Utils/Constants/TextConstants.dart';
import '../../Utils/Constants/TextStyles.dart';

Future<ImageSource?> showImageSourceDialog(BuildContext context) {
  return showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: Text(TextConstants.selectImage),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, ImageSource.camera);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                color: Theme.of(context).hintColor,
              ),
              SizedBox(
                width: 6.h,
              ),
              Text(TextConstants.takePhoto,
                  style: TextStyleClass.textSize17Bold(
                      color: Theme.of(context).hintColor)),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, ImageSource.gallery);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                color: Theme.of(context).hintColor,
              ),
              SizedBox(
                width: 6.h,
              ),
              Text(TextConstants.chooseGallery,
                  style: TextStyleClass.textSize17Bold(
                      color: Theme.of(context).hintColor)),
            ],
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
        },
        isDestructiveAction: true,
        child: Text(TextConstants.cancel,
            style: TextStyleClass.textSize21Bold(color: KConstantColors.red)),
      ),
    ),
  );
}

// void showLanguagePopup(BuildContext context) {
//   showCupertinoDialog(
//     barrierDismissible: true,
//     context: context,
//     builder: (context) => CupertinoAlertDialog(
//       title: Text(
//         TextConstants.selectLanguage,
//         style: TextStyleClass.textSize16Bold(
//           color: Theme.of(context).hintColor,
//         ),
//       ),
//       actions: [
//         CupertinoDialogAction(
//           onPressed: () {
//             changeLanguage(context, 'en');
//             Navigator.pop(context);
//           },
//           child: Text(
//             '🇬🇧 English',
//             style: TextStyleClass.textSize15Bold(
//               color: Theme.of(context).hintColor,
//             ),
//           ),
//         ),
//         CupertinoDialogAction(
//           onPressed: () {
//             changeLanguage(context, 'ta');
//             Navigator.pop(context);
//           },
//           child: Text(
//             '🇮🇳 தமிழ்',
//             style: TextStyleClass.textSize15Bold(
//               color: Theme.of(context).hintColor,
//             ),
//           ),
//         ),
//         CupertinoDialogAction(
//           onPressed: () {
//             changeLanguage(context, 'ar');
//             Navigator.pop(context);
//           },
//           child: Text(
//             '🇸🇦 العربية',
//             style: TextStyleClass.textSize15Bold(
//               color: Theme.of(context).hintColor,
//             ),
//           ),
//         ),
//         CupertinoDialogAction(
//           onPressed: () => Navigator.pop(context),
//           isDestructiveAction: true,
//           child: Text(
//             TextConstants.cancel,
//             style: TextStyleClass.textSize15Bold(color: Colors.red),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// void changeLanguage(BuildContext context, String langCode) {
//   switch (langCode) {
//     case 'en':
//       context.setLocale(Locale('en'));
//       break;
//     case 'ta':
//       context.setLocale(Locale('ta'));
//       break;
//     case 'ar':
//       context.setLocale(Locale('ar'));
//       break;
//   }
// }


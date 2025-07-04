import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Utils/Constants/ColorConstants.dart';
import '../Utils/Constants/TextStyles.dart';

String formatDateTime(String timestamp) {
  final dateTime =
      DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
  return DateFormat('dd-MM-yyyy hh:mm:a').format(dateTime);
}

String formatDate(String timestamp) {
  final dateTime =
      DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
  return DateFormat('dd-MM-yyyy').format(dateTime);
}

String formatTime(String timestamp) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
  return DateFormat('hh:mm a').format(dateTime);
}

DateTime convertToDateTime(String dateTimeString) {
  try {
    DateFormat inputFormat = DateFormat("dd/MM/yyyy hh:mm a");
    DateTime dateTime = inputFormat.parse(dateTimeString);
    return dateTime;
  } catch (e) {
    print("Error parsing date-time string: $e");
    return DateTime.now();
  }
}

DateTime convertEpochToDateTime(int epochTime) {
  try {
    return DateTime.fromMillisecondsSinceEpoch(epochTime * 1000, isUtc: true)
        .toLocal();
  } catch (e) {
    print("Error converting epoch time: $e");
    return DateTime.now();
  }
}

int convertToEpoch(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  return dateTime.millisecondsSinceEpoch; // Returns epoch in milliseconds
}

String convertEpochToReadableFormattedDate(int epochTime) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epochTime);
  return DateFormat("MMM d yyyy h:mm a").format(dateTime);
}

// String getVehicleImage(String vehicleType) {
//   vehicleType = 'truck';
//   switch (vehicleType) {
//     case 'bike':
//       return ImageConstants.finalBike;
//     case 'truck':
//       return ImageConstants.finalTruck;
//     case 'bus':
//       return ImageConstants.finalTruck;
//     default:
//       return ImageConstants.bgImage;
//   }
// }

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

void showInternalServerErrorPopup(BuildContext context, Function retryFunction,
    {int? statuscode = 500}) {
  bool tokenExpires = statuscode == 401 ? true : false;
  showCupertinoDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => CupertinoAlertDialog(
      title: Text(
        tokenExpires ? "Token Expires" : 'Oops!..',
        style:
        TextStyleClass.textSize17Bold(color: Theme.of(context).hintColor),
      ),
      content: Text(
        tokenExpires
            ? "Please Login again with your credentials"
            : 'Something went wrong with your connection. Please try again.',
        style: TextStyleClass.textSize15(color: Theme.of(context).hintColor),
      ),
      actions: [
        CupertinoDialogAction(
          child: Text("Back",
              style: TextStyleClass.textSize14Bold(
                  color: Theme.of(context).hintColor)),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            // CustomWidgets().logoutFunction(context,false)
          },
          child: Text(tokenExpires ? 'Logout' : 'RETRY',
              style: TextStyleClass.textSize14Bold(color: KConstantColors.red)),
        ),
      ],
    ),
  );
}


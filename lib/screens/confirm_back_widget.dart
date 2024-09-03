import 'package:flutter/material.dart';
import 'package:parsel_flutter/utils/dialogs.dart';

class ConfirmBackWrapperWidget extends StatelessWidget {
  final Widget child;

  const ConfirmBackWrapperWidget({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async =>
            await showConfirmationDialog(
              context: context,
              title: "Cancel",
              content: "Are you sure to go back?",
              positiveButtonLabel: "Yes",
              negativeButtonLabel: "No",
            ) ==
            true,
        child: child);
  }
}

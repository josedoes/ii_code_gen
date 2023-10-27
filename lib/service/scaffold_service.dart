import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ii_code_gen/ui/colors.dart';

ScaffoldService get scaffoldService => GetIt.instance<ScaffoldService>();

class ScaffoldService {
  // Future<void> showADialog(
  //     {required BuildContext context, required Widget child}) async {
  //   await showDialog(
  //     context: context,
  //     builder: (_) {
  //       return ZoomIn(child: child);
  //     },
  //   );
  // }
  ///will return bool like context.pop(true) or false
  Future<bool?> yesOrNoDialog(
      {required BuildContext context, required Widget child}) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          backgroundColor: BaseColors.offWhite,
          child: child,
        );
      },
    );
  }

  Future<void> showBaseDialog(
      {required BuildContext context,
      required Widget child,
      required bool barrierDismissible}) {
    return showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) {
        print('showBaseDialog called');

        return Dialog(
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          backgroundColor: BaseColors.offWhite,
          child: child,
        );
      },
    );
  }

  // void showBaseDialogue(
  //     {required BuildContext context,
  //     required backgroundColor,
  //     required child}) {
  //   showADialog(
  //       context: context,
  //       child: BaseDialogue(
  //         backgroundColor: backgroundColor,
  //         onExit: (context) {
  //           Navigator.of(context).pop();
  //         },
  //         child: child,
  //       ));
  // }

  void showDisabledSnack(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.grey,
    ));
  }

  void showSnackAboveDawer(
      {required BuildContext context, required String message}) {
    showModalBottomSheet<void>(
      context: context,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0),
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 5), () {
          try {
            Navigator.pop(context);
          } on Exception {}
        });
        return Container(
            color: Color(0xff323232),
            padding: const EdgeInsets.all(12),
            child: Wrap(children: [Text(message)]));
      },
    );
  }
}

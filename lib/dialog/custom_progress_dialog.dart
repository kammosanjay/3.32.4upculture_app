import 'package:flutter/material.dart';


class ProgressDialogWidget extends StatelessWidget {
  const ProgressDialogWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Dialog(
      insetPadding: const EdgeInsets.all(90),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      elevation: 0.0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: animatedDialogContent(context),
    );

  }

  ///
  ///
  ///
  animatedDialogContent(BuildContext context) {
    return
    const SizedBox(
        height: 60,
        width: 60,
        child: Center(child: CircularProgressIndicator()));
  }

}


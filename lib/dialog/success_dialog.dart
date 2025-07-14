import 'package:flutter/material.dart';
import 'package:upculture/resources/my_color.dart';

class SuccessDialog extends StatefulWidget {

  final String msg;
  final Function yesFunction;


  const SuccessDialog({super.key, 
    required this.msg,
    required this.yesFunction,});

  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /*Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image(
              image: askQueIc,
              height: 50,
              width: 50,),
          ),
*/
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, bottom: 0.0, top: 10.0),
            child: Text(
                widget.msg,
                textAlign: TextAlign.center,
                style: labelStyle()),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 35,
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: MyColor.appColor),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // To close the dialog
                      widget.yesFunction.call();
                    },
                    style: ButtonStyle(
                        backgroundColor:MaterialStatePropertyAll(
                            Colors.transparent),
                        elevation: MaterialStatePropertyAll(0)),
                    child: const Text("OK", //Ok
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,))),
              ),

            ],
          )
        ],
      ),
    );
  }


  ///*
  ///
  TextStyle labelStyle() {
    return  const TextStyle(
      fontSize: 16,
      color: Colors.black,
    );
  }

  ///*
  ///
  TextStyle titleStyle() {
    return  const TextStyle(
      fontSize: 16,
      color: Colors.black,
    );
  }

}

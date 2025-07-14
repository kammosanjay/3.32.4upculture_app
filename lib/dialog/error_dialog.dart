import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';

class ErrorDialog extends StatefulWidget {
   String? msg;
   String? isShowImage = 'Yes';

    ErrorDialog({
    Key? key,
    required this.msg,
    this.isShowImage
  }) : super(key: key);

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      elevation: 20.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child:  Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15, bottom: 15, top: 10),
          // ignore: unnecessary_new
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Column(
                children: <Widget>[

                  const SizedBox(height: 10),
                  widget.isShowImage == 'Yes'?
                  Image(image: errorIc, height: 50, width: 50,):const SizedBox(),
                  const SizedBox(height: 10),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                            widget.msg!,
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontFamily: MyFont.roboto,
                                fontWeight: MyFontWeight.medium
                            )
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40.0,
                    width: 100,
                    child: ElevatedButton(
                        onPressed: (){
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(shape:
                        RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1.0,
                            color: Colors.black26,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                            backgroundColor: MyColor.appColor),
                        child:  Text(
                          'OK',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: MyFont.roboto,
                              fontWeight: MyFontWeight.medium
                          ),
                        )),
                  ),
                ],
              )
            ],
          ),
        ));
  }

}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:upculture/local_database/my_shared_preference.dart';
import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerScreen extends StatefulWidget {
  String youtubeUrl;
  YoutubePlayerScreen({Key? key, required this.youtubeUrl}) : super(key: key);

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {

  // YoutubePlayerController? youtubeController;

  late double height;
  late double width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MySharedPreference.getInstance();
    // initYoutubePlayer();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    // if(youtubeController != null){
    //   youtubeController!.dispose();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: MyColor.appColor,
    ));

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [


            // Positioned(
            //   left: 0,
            //   right: 0,
            //   top: 0,
            //   bottom: 0,
            //   child: Container(
            //     child: youtubePlayerWidget(),
            //   ),
            // ),

            Positioned(
              top: 20,
              left: 20,
              child: InkWell(
                onTap: (){
                  Get.back();
                },
                child: Container(
                  height: 35,
                  width: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white
                  ),
                  child: Image(
                    image: backArrow,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  ///
  ///
  ///
  // initYoutubePlayer(){
  //   youtubeController = YoutubePlayerController(
  //     initialVideoId: YoutubePlayer.convertUrlToId(widget.youtubeUrl)!,
  //     flags: const YoutubePlayerFlags(
  //         autoPlay: true,
  //         mute: false,
  //         loop: false
  //     ),
  //   );
  // }

  ///
  ///
  ///
  // youtubePlayerWidget() {
  //   return
  //     YoutubePlayer(
  //       controller: youtubeController!,
  //       showVideoProgressIndicator: false,
  //       onReady: (){
  //         youtubeController!.addListener(() {
  //         });
  //       },
  //       onEnded: (data){
  //       },
  //     );
  // }
}


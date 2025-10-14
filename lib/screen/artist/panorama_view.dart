import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class PanoramaView extends StatefulWidget {
  const PanoramaView({super.key});

  @override
  State<PanoramaView> createState() => _PanoramaViewState();
}

class _PanoramaViewState extends State<PanoramaView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

        child: PanoramaViewer(
          zoom: 1.0,
          animSpeed: 1.0,
          maxZoom: 5,
          // sensitivity: 0.5,

          child: Image.asset('assets/images/ramji.webp'),
        ),
      ),
    );
  }
}

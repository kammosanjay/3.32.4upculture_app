import 'package:flutter/material.dart';
import 'package:upculture/resources/my_color.dart';

class SequentialSlidingFooter extends StatefulWidget {
  
  @override
  State<SequentialSlidingFooter> createState() =>
      _SequentialSlidingFooterState();
}

class _SequentialSlidingFooterState extends State<SequentialSlidingFooter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  int _currentImageIndex = 0;

  final List<String> images = [
    'assets/images/footer-image.png',
    'assets/images/footer-image.png', // Add more image paths if needed
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    _animation = Tween<Offset>(
      begin: Offset(1.0, 0.0), // Start off-screen right
      end: Offset(-1.0, 0.0), // End off-screen left
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % images.length;
        });
        _controller.reset();
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: SlideTransition(
          position: _animation,
          child: Image.asset(
            images[_currentImageIndex],
            fit: BoxFit.cover,
            color: MyColor.appColor,
            width: MediaQuery.of(context).size.width,
           
          ),
        ),
      ),
    );
  }
}

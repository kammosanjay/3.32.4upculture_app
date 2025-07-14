import 'package:flutter/material.dart';

class SplashScreenone extends StatefulWidget {
  const SplashScreenone({Key? key}) : super(key: key);

  @override
  State<SplashScreenone> createState() => _SplashScreenoneState();
}

class _SplashScreenoneState extends State<SplashScreenone>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late AnimationController _textController;
  late Animation<double> _textAnimation;

  var screenHeight;
  var screenWidth;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: -400, end:100).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeOutBack
      ),
    );
    _textController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _textAnimation = Tween<double>(
            begin: -200, // Start off-screen (right to left)
            end: 200)
        .animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOut,
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _controller.reverse();
        });
      }
    });

    _textController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _textController.reverse();
        });
      }
    });

    _controller.forward();
    _textController.forward();

    //  _fadeLeftController.forward();
    //   _fadeRightController.forward();
    // handleSession();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/splash/splash_img1.png',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          upMap(),
          txtAnimation()
        ],
      ),
    );
  }

  Widget upMap() {
    return AnimatedBuilder(
      animation: _logoAnimation,
      builder: (context, child) {
        return Positioned(
          top: _logoAnimation.value,
          height: MediaQuery.of(context).size.height * 0.45,
          left: MediaQuery.of(context).size.height * 0.01,
          right: MediaQuery.of(context).size.height * 0.01,
          child: Image.asset(
            "assets/images/updarshan.png",
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width * 0.9,
          ),
        );
      },
    );
  }

  Widget txtAnimation() {
    return AnimatedBuilder(
      animation: _textAnimation,
      builder: (context, child) {
        return Positioned(
          bottom: _textAnimation.value,
          // Fixed vertical position
          left: MediaQuery.of(context).size.height * 0.01,
          right: MediaQuery.of(context).size.height *
              0.01, // Animate the `right` property
          child: Text(
            'Culture Department\n Uttar Pradesh',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        );
      },
    );
  }
}

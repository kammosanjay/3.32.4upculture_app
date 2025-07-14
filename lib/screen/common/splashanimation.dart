import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  late Animation<double> _rotationAnimation;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _textAnimation = Tween<double>(
            begin: -200, // Start off-screen (right to left)
            end: 70)
        .animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0, // Start at 0 degrees
      end: 10.0, // End at 1 full rotation (360 degrees)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCirc, // Smooth rotation
    ));

    _controller.forward();
    // handleSession();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("screenWidth${MediaQuery.of(context).size.width}");
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/splash/splash_img1.png',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          logoAnimation(),
          
          txtAnimation()
        ],
      ),
    );
  }

  Widget logoAnimation() {
    return AnimatedBuilder(
      animation: _logoAnimation,
      builder: (context, child) {
        return Positioned(
          top: 250,
          left:80,right: 80,
          child: Transform.rotate(
            angle: _rotationAnimation.value *
                2 *
                3.141592653589793, // Convert to radians
            child: Image.asset(
              "assets/images/uplogo.png",
              height: 140,
              width: 140,
            ),
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
          // top: screenHeight / 2,
          top: MediaQuery.of(context).size.height * 0.5,
          // bottom: MediaQuery.of(context).size.height*0.5,
          // left:MediaQuery.of(context).size.width*0.5 ,
          // right:MediaQuery.of(context).size.width*0.5 ,
          // Fixed vertical position
          right: _textAnimation.value, // Animate the `right` property
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

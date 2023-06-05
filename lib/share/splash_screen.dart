import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chat_app/modules/chat_screen.dart';
import 'package:chat_app/share/components.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChatSplashScreen extends StatelessWidget {
  const ChatSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
          splash:Column(
            children: [
              Expanded(child: LottieBuilder.asset('assets/chat_animation.json',fit: BoxFit.cover,width: 300)),
              defaultText(text: 'شـاتـك غير أي حد',size: 30.0,fontWeight: FontWeight.bold),
            ],
          ),
          duration: 3000,
          backgroundColor: Colors.white,
          splashTransition: SplashTransition.slideTransition,
          pageTransitionType: PageTransitionType.leftToRightWithFade,
          animationDuration: const Duration(seconds: 2),
          splashIconSize: 300,
          nextScreen: const ChatScreen(),
      ),
    );
  }
}

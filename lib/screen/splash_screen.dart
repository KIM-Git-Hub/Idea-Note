import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      context.go('/main');
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/idea_icon.png',
              height: 180,
              width: 180,
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Text(
                'Idea Note',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

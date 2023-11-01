import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:idea_note_app/color_schemes.g.dart';
import 'package:idea_note_app/screen/main_screen.dart';
import 'package:idea_note_app/screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

final router = GoRouter(initialLocation: '/splash', routes: [
  GoRoute(
    path: '/splash',
    builder: (context, state) => SplashScreen(),
  ),
  GoRoute(
    path: '/main',
    builder: (context, state) => MainScreen(),
  )
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Idea Note',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
    );
  }
}

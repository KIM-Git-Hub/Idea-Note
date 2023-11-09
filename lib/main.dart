import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:idea_note_app/data/idea_info.dart';
import 'package:idea_note_app/screen/detail_screen.dart';
import 'package:idea_note_app/screen/main_screen.dart';
import 'package:idea_note_app/screen/splash_screen.dart';

import 'screen/edit_screen.dart';

void main() {
  runApp(const MyApp());
}


final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => MainScreen(),
    ),
    GoRoute(
      path: '/edit',
      builder: (context, state){
        if(state.extra != null){
          IdeaInfo ideaInfo = state.extra as IdeaInfo;
          return EditScreen(ideaInfo: ideaInfo,);
        }else{
          return EditScreen();
        }
      }
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        IdeaInfo ideaInfo = state.extra as IdeaInfo;
        return DetailScreen(ideaInfo: ideaInfo,);

      }
    ),
  ],
);

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        backgroundColor: Colors.white,
      ),
    );
  }
}

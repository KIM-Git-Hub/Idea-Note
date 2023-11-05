import 'package:flutter/material.dart';
import 'package:idea_note_app/data/idea_info.dart';
import 'package:idea_note_app/main.dart';

class DetailScreen extends StatelessWidget {
  IdeaInfo? ideaInfo;

  DetailScreen({super.key, this.ideaInfo});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 25,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          ideaInfo!.title,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:idea_note_app/data/idea_info.dart';
import 'package:idea_note_app/database/database_helper.dart';
import 'package:idea_note_app/main.dart';

class DetailScreen extends StatelessWidget {
  IdeaInfo? ideaInfo;
  final dbHelper = DatabaseHelper();

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
        actions: [
          TextButton(
              onPressed: () {
                //아이디어 삭제
                //다이얼로그로 확인
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('삭제?'),
                      content: Text('아이디어를 삭제할거에용?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: Text(
                              '취소',
                              style: TextStyle(color: Colors.grey),
                            )),
                        TextButton(
                            onPressed: () async {
                              if (context.mounted) {
                                await setDeleteIdeaInfo(ideaInfo!.id!);
                                context.pop(); // 팝업종료
                                context.pop(); // 이전 화면
                              }
                            },
                            child: Text(
                              '삭제',
                              style: TextStyle(color: Colors.red),
                            ))
                      ],
                    );
                  },
                );
              },
              child: Text(
                '삭제',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '아이디어를 떠울린 계기',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ideaInfo!.motive,
                      style: TextStyle(
                        color: Color(0xffa5a5a5),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      '아이디어내용',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ideaInfo!.content,
                      style: TextStyle(
                        color: Color(0xffa5a5a5),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      '별갯수',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: ideaInfo!.priority,
                      minRating: 1,
                      itemCount: 5,
                      direction: Axis.horizontal,
                      itemSize: 35,
                      itemPadding: EdgeInsets.symmetric(horizontal: 0),
                      itemBuilder: (context, index) {
                        return Icon(
                          Icons.star,
                          color: Colors.amber,
                        );
                      },
                      ignoreGestures: true,
                      updateOnDrag: false,
                      onRatingUpdate: (value) {},
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      '메모',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ideaInfo!.memo,
                      style: TextStyle(
                        color: Color(0xffa5a5a5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: ()  {
                  context.push('/edit', extra: ideaInfo);
                },
                child: Text('내용편집하기')),
          )
        ],
      ),
    );
  }

  Future<void> setDeleteIdeaInfo(int id) async {
    await dbHelper.initDatabase();
    await dbHelper.deleteIdeaInfo(id);
  }
}

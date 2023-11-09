import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:idea_note_app/data/idea_info.dart';
import 'package:idea_note_app/database/database_helper.dart';

class DetailScreen extends StatelessWidget {
  IdeaInfo? ideaInfo;

  DetailScreen({super.key, this.ideaInfo});

  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 25,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          alignment: Alignment.center,
          child: Text(
            ideaInfo!.title,
            style: TextStyle(fontSize: 20),
          ),
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
                      title: Text('削除'),
                      content: Text('アイデアを削除しますか？'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: Text(
                              'キャンセル',
                              style: TextStyle(color: Colors.black),
                            )),
                        TextButton(
                            onPressed: () async {
                              await setDeleteIdeaInfo(ideaInfo!.id!);
                              context.pop(); // 팝업종료
                              context.pop('delete'); // 이전 화면
                            },
                            child: Text(
                              '削除',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    );
                  },
                );
              },
              child: Text(
                '削除',
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
                      'アイデアを思いついたきっかけ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 8),
                      height: 40,
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      child: Text(
                        ideaInfo!.motive,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Color(0xffd9d9d9)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'アイデアの内容',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 8),
                      height: 150,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(
                        ideaInfo!.content,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Color(0xffd9d9d9)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      '重要度',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 8),
                      child: RatingBar.builder(
                        initialRating: ideaInfo!.priority,
                        minRating: 1,
                        itemCount: 5,
                        direction: Axis.horizontal,
                        itemSize: 50,
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
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'メモ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 8),
                      height: 150,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(
                        ideaInfo!.memo,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Color(0xffd9d9d9)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
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
                onPressed: () async {
                  var result = await context.push('/edit', extra: ideaInfo);
                  if (result != null) {
                    if (result == 'update') {
                      context.pop('update');
                    }
                  }
                },
                child: Text('編集', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),
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

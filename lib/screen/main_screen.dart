import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:idea_note_app/database/database_helper.dart';
import 'package:intl/intl.dart';

import '../data/idea_info.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var dbHelper = DatabaseHelper(); // 데이터 베이스 접근을 용이하게 해주는 유틸 객체
  List<IdeaInfo> listIdeaInfo = []; // 아이디어 목록들

  @override
  void initState() {
    //위젯이 생성될때 처음으로 호출되는 메서드 이다. initState는 오직 한번 만 호출 된다.
    super.initState();
    //아이디어 목록들 가져오기
    getIdeaInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Idea Note',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: listIdeaInfo.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: listItem(index),
              onTap: () async {
                // 몇번째 인덱스를 클릭했는가을 알기 위해 정보전달
                var result =
                    await context.push('/detail', extra: listIdeaInfo[index]);
                if (result != null) {
                  if (result == 'delete') {
                    getIdeaInfo();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('삭제완료')));
                  } else if (result == 'update') {
                    getIdeaInfo();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('수정완료')));
                  }
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            ///새 아이디어 작성 화면으로 이동
            // editScreen 에서 pop 되서 돌아오면 화면 갱신
            //main -> edit -> main 화면으로 돌아왔을떄  edit로 부터 결과 값을 전달 받았을때
            var result = await context.push('/edit');
            //pop 에서 돌아올떄 result가  특정 인자값을 넘겨 받을수 있다.
            if (result != null) {
              if (result == 'insert') {
                getIdeaInfo();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('작성완료')));
              }
            }
          },
          child: Icon(Icons.add)),
    );
  }

  Widget listItem(int index) {
    //Stack 쌓아올리다 겹칠수 잇다 햄버거 처럼
    return Container(
      height: 65,
      margin: EdgeInsets.only(top: 15),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xffd9d9d9), width: 2),
        borderRadius: BorderRadius.circular(10),
      )),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Align(
            /// 아이디어 제목
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: 8, left: 15),
              child: Text(
                listIdeaInfo[index].title,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          Align(

              ///기록 날짜
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(bottom: 8, right: 15),
                child: Text(
                  DateFormat("yyyy.MM.dd HH:mm").format(
                      DateTime.fromMillisecondsSinceEpoch(
                          listIdeaInfo[index].createdAt)),
                  style: TextStyle(
                    color: Color(0xffaeaeae),
                    fontSize: 10,
                  ),
                ),
              )),
          Align(
            /// 중요도
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(bottom: 8, left: 15),
              child: RatingBar.builder(
                initialRating: listIdeaInfo[index].priority,
                minRating: 1,
                itemCount: 5,
                direction: Axis.horizontal,
                itemSize: 16,
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
          )
        ],
      ),
    );
  }

  Future<void> getIdeaInfo() async {
    // idea 정보들을 가지고 와서 멤버 (전역) 변수 리스트 객체에 담기
    await dbHelper.initDatabase();
    //idea 정보들을 가지고 와서 멤버 변수 리스트 객체에 담기
    listIdeaInfo = await dbHelper
        .getAllIdeaInfo(); // database_helper의 getAllIdeaInfo (데이터 조회)
    //리스트 객체 역순으로 정렬
    listIdeaInfo.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );
    setState(() {
      //리스트 갱신, ui업데이트
    });
  }
}

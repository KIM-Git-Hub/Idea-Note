import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:idea_note_app/data/idea_info.dart';
import 'package:idea_note_app/database/database_helper.dart';

class EditScreen extends StatefulWidget {
  IdeaInfo? ideaInfo;

  EditScreen({super.key, this.ideaInfo});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController motiveController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController memoController = TextEditingController();
  double sliderValue = 0.0;
  List<String> sliderValueString = [
    "X",
    "★",
    "★★",
    "★★★",
    "★★★★",
    "★★★★★"
  ];
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
          '아이디어 작성',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('제목'),
              Container(
                margin: EdgeInsets.only(top: 8),
                height: 40,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: '아이디아 제목',
                      hintStyle: TextStyle(color: Color(0xffb4b4b4)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffd9d9d9),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      )),
                  style: TextStyle(fontSize: 12),
                  controller: titleController,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text('아이디어 떠올린 계기'),
              Container(
                margin: EdgeInsets.only(top: 8),
                height: 40,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: '아이디아 제목',
                      hintStyle: TextStyle(color: Color(0xffb4b4b4)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffd9d9d9),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      )),
                  style: TextStyle(fontSize: 12),
                  controller: motiveController,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text('아이디어 내용'),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: TextField(
                  maxLength: 500,
                  maxLines: 5,
                  decoration: InputDecoration(
                      hintText: '아이디아 제목',
                      hintStyle: TextStyle(color: Color(0xffb4b4b4)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffd9d9d9),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      )),
                  style: TextStyle(fontSize: 12),
                  controller: contentController,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text('아이디어 중요도 내용'),
              Slider(
                value: sliderValue,
                max: 5,
                min: 0,
                label: sliderValueString[sliderValue.toInt()],
                divisions: 5,
                onChanged: (newValue) {
                  setState(() {
                    sliderValue = newValue;
                    print(sliderValue);
                  });
                },
              ),
              Text('메모(선택)'),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: TextField(
                  maxLength: 500,
                  maxLines: 5,
                  decoration: InputDecoration(
                      hintText: '아이디아 제목',
                      hintStyle: TextStyle(color: Color(0xffb4b4b4)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffd9d9d9),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      )),
                  style: TextStyle(fontSize: 12),
                  controller: memoController,
                ),
              ),
              SizedBox(
                height: 15,
              ),

              ///아이디어 작성버튼 완료 버튼
              Container(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async {
                      //작성처리 database insert 처리
                      String titleValue = titleController.text.toString();
                      String motiveValue = motiveController.text.toString();
                      String contentValue = contentController.text.toString();
                      String memoValue = memoController.text.toString();

                      //유효성 검사 (비어 있는 필수 입력 값에 대한 체크)
                      if (titleValue.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('타이틀을 입력해줭.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      } else if (motiveValue.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('아이디아 계기 입력해줭.'),
                          duration: Duration(seconds: 2),
                        ));
                        return;
                      } else if (contentValue.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('아이디어 내용 입력해줭.'),
                          duration: Duration(seconds: 2),
                        ));
                        return;
                      }

                      if (widget.ideaInfo == null) {
                        var ideaInfo = IdeaInfo(
                            title: titleValue,
                            motive: motiveValue,
                            content: contentValue,
                            priority: sliderValue,
                            memo: memoValue,
                            createdAt: DateTime.now().millisecondsSinceEpoch);

                            await setInsertIdeaInfo(ideaInfo);
                            context.pop();
                      }
                    },
                    child: Text('저장하기')),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future setInsertIdeaInfo(IdeaInfo ideaInfo) async {
    //삽입하는 메소드
    await dbHelper.initDatabase();
    await dbHelper.insertIdeaInfo(ideaInfo);
  }
}

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
  List<String> sliderValueString = ["☆", "★", "★★", "★★★", "★★★★", "★★★★★"];
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    //기존 데이터를 수정할 경우
    if (widget.ideaInfo != null) {
      titleController.text = widget.ideaInfo!.title;
      motiveController.text = widget.ideaInfo!.motive;
      contentController.text = widget.ideaInfo!.content;
      sliderValue = widget.ideaInfo!.priority;
      if (widget.ideaInfo!.memo.isNotEmpty) {
        memoController.text = widget.ideaInfo!.memo; // 메모 작성이 필수가 아니기 때문
      }
    }
  }

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
        title: Text(
          widget.ideaInfo == null ? 'アイデア作成' : 'アイデア編集',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'タイトル',
                    style: TextStyle(fontSize: 15),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    height: 40,
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintText: 'アイデアのタイトルを作成してください。',
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
                  Text('アイデアを思いついたきっかけ'),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    height: 40,
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintText: 'アイデアを思いついたきっかけを作成してください。',
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
                  Text('アイデアの内容'),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: TextField(
                      maxLength: 300,
                      maxLines: 7,
                      decoration: InputDecoration(
                          hintText: 'アイデアの内容を作成してください。',
                          hintStyle: TextStyle(color: Color(0xffb4b4b4)),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
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
                  Text('重要度'),
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
                  Text('メモ（選択）'),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: TextField(
                      maxLength: 300,
                      maxLines: 7,
                      decoration: InputDecoration(
                          hintText: 'メモを作成してください。',
                          hintStyle: TextStyle(color: Color(0xffb4b4b4)),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
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
                ],
              ),
            ),
          )),

          ///아이디어 작성버튼 완료 버튼
          Container(
            width: double.infinity,
            height: 60,
            margin: EdgeInsets.all(15),
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
                        content: Text('タイトルを入力してください。'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  } else if (motiveValue.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('アイデアを思いついたきっかけを作成してください。'),
                      duration: Duration(seconds: 2),
                    ));
                    return;
                  } else if (contentValue.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('アイデアの内容を作成してください。'),
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
                        memo: memoValue.isNotEmpty ? memoValue : '',
                        createdAt: DateTime.now().millisecondsSinceEpoch);

                    await setInsertIdeaInfo(ideaInfo);
                    context.pop('insert');
                  } else {
                    //업데이트 하는 경우
                    var ideaInfoModify = widget.ideaInfo;
                    ideaInfoModify?.title = titleValue;
                    ideaInfoModify?.motive = motiveValue;
                    ideaInfoModify?.content = contentValue;
                    ideaInfoModify?.priority = sliderValue;
                    ideaInfoModify?.memo =
                        memoValue.isNotEmpty ? memoValue : '';

                    await setUpdateIdeaInfo(ideaInfoModify!);
                    context.pop('update');
                  }
                },
                child: Text(
                  '保存',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
          )
        ],
      ),
    );
  }

  Future setInsertIdeaInfo(IdeaInfo ideaInfo) async {
    //삽입하는 메소드
    await dbHelper.initDatabase();
    await dbHelper.insertIdeaInfo(ideaInfo);
  }

  Future setUpdateIdeaInfo(IdeaInfo ideaInfo) async {
    // 업데이트
    await dbHelper.initDatabase();
    await dbHelper.updateIdeaInfo(ideaInfo);
  }
}

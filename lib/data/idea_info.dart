class IdeaInfo {
  int? id; // 데이터 컬럼 아이디
  String title; // 아이디어 제목
  String motive; // 작성 계기
  String content; // 아이디어내용
  int priority; //아이디어 중요도 점수
  String memo; // 간단메모
  int createdAt; //생성 일시

  //생성자
  IdeaInfo({
    this.id,
    required this.title,
    required this.motive,
    required this.content,
    required this.priority,
    required this.memo,
    required this.createdAt,
  });


  //IdeaInfo 객체를 Map 객체로 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'motive': motive,
      'content': content,
      'priority': priority,
      'memo': memo,
      'created': createdAt,
    };
  }

  //Map 객체를 IdeaInfo 데이터 클래스로 변환
  factory IdeaInfo.fromMap(Map<String, dynamic> map) {
    return IdeaInfo(
      id: map['id'],
      title: map['title'],
      motive: map['motive'],
      content: map['content'],
      priority: map['priority'],
      memo: map['memo'],
      createdAt: map['createdAt'],
    );
  }
}

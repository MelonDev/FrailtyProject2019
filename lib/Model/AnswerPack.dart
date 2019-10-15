class AnswerPack {

  final String id;
  final String takerId;
  final String dateTime;

  AnswerPack({this.id,this.takerId,this.dateTime});

  factory AnswerPack.fromJson(Map<String, dynamic> json) {
    return new AnswerPack(
        id: json['id'],
        takerId: json['takerId'],
        dateTime: json['dateTime']
    );
  }

  factory AnswerPack.fromMap(Map map) {
    return new AnswerPack(
        id: map['id'] as String,
        takerId: map['takerId'] as String,
        dateTime: map['dateTime'] as String
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "takerId": takerId,
    "dateTime": dateTime
  };

}
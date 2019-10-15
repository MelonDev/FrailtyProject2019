class Answer {

  final String id;
  final String questionId;
  final String answerPack;
  final String value;

  Answer({this.id,this.questionId,this.answerPack,this.value});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return new Answer(
        id: json['id'],
        questionId: json['questionId'],
        answerPack: json['answerPack'],
        value: json['value']
    );
  }

  factory Answer.fromMap(Map map) {
    return new Answer(
        id: map['id'] as String,
        questionId: map['questionId'] as String,
        answerPack: map['answerPack'] as String,
        value: map['value'] as String
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "questionId": questionId,
    "answerPack": answerPack,
    "value": value
  };

}
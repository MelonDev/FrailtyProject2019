class Choice {
  final String id;
  final String questionId;
  final String message;
  final int position;
  final String destinationId;

  Choice({this.id, this.questionId, this.message,this.position,this.destinationId});

  factory Choice.fromJson(Map<String, dynamic> json) {
    return new Choice(
      id: json['id'],
      questionId: json['questionId'],
      message: json['message'],
      position: json['position'],
      destinationId: json['destinationId'],
    );
  }

  factory Choice.fromMap(Map map) {
    return new Choice(
      id: map['id'] as String,
      questionId: map['questionId'] as String,
      message: map['message'] as String,
      position: map['position'] as int,
      destinationId: map['destinationId'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "questionId": questionId,
    "message": message,
    "position": position,
    "destinationId": destinationId
  };
}

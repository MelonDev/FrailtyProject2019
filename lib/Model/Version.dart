class Version {
  final String id;
  final String questionnaireId;
  final int version;
  final String createAt;
  final String updateAt;

  Version({this.id, this.questionnaireId, this.version,this.createAt,this.updateAt});

  factory Version.fromJson(Map<String, dynamic> json) {
    return new Version(
      id: json['id'],
      questionnaireId: json['questionnaireId'],
      version: json['version'],
      createAt: json['createAt'],
      updateAt: json['updateAt'],
    );
  }

  factory Version.fromMap(Map map) {
    return new Version(
      id: map['id'] as String,
      questionnaireId: map['questionnaireId'] as String,
      version: map['version'] as int,
      createAt: map['createAt'] as String,
      updateAt: map['updateAt'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "questionnaireId": questionnaireId,
    "version": version,
    "createAt": createAt,
    "updateAt": updateAt
  };
}

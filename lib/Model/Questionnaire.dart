class Questionnaire {
  final String id;
  final String name;
  final String description;

  Questionnaire({this.id, this.name, this.description});

  factory Questionnaire.fromJson(Map<String, dynamic> json) {
    return new Questionnaire(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  factory Questionnaire.fromMap(Map map) {
    return new Questionnaire(
        id: map['id'] as String,
        name: map['name'] as String,
        description: map['description'] as String);
  }

  Map<String, dynamic> toMap() => {"id": id, "name": name, "description": description};

}

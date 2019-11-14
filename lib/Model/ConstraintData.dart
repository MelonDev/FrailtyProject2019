
class ConstraintData {
  final String id;
  final String fromId;
  final int min;
  final int max;

  ConstraintData({this.id, this.fromId, this.min,this.max});

  factory ConstraintData.fromJson(Map<String, dynamic> json) {
    return new ConstraintData(
      id: json['id'],
      fromId: json['fromId'],
      min: json['min'],
      max: json['max']
    );
  }

  factory ConstraintData.fromMap(Map map) {
    return new ConstraintData(
      id: map['id'] as String,
      fromId: map['fromId'] as String,
      min: map['colmin'] as int,
      max: map['colmax'] as int
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "fromId": fromId,
    "colmin": min,
    "colmax": max
  };
}

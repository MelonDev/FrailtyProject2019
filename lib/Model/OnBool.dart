class OnBool {
  final bool value;
  final String message;

  OnBool({this.value, this.message});

  factory OnBool.fromJson(Map<String, dynamic> json) {
    return new OnBool(value: json["value"], message: json["message"]);
  }
}

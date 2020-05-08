class ReturnHttp {

  final int httpStatus;
  final String status;

  ReturnHttp(this.httpStatus, this.status);

  factory ReturnHttp.fromJson(Map<String, dynamic> json) {
    return new ReturnHttp(json['httpStatus'], json['status']);
  }


}
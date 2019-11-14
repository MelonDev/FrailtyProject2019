class HttpResult {
  final String status;
  final int httpStatus;

  HttpResult(this.status,this.httpStatus);

  HttpResult.fromJson(Map<String, dynamic> json) : status = json["status"],httpStatus = json["httpStatus"];
}
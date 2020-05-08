class ResultAfterProcess {
  final String questionnaireName;
  final String answerPackId;
  final String resultMessage;
  final double score;
  final double percent;
  final String dateTime;

  ResultAfterProcess({this.questionnaireName,this.answerPackId,this.resultMessage,this.score,this.percent,this.dateTime});

  ResultAfterProcess.fromJson(Map<String, dynamic> json)
      : questionnaireName = json['questionnaireName'],
        answerPackId = json['answerPackId'],
        dateTime = json['dateTime'],
        resultMessage = json['resultMessage'],
        score = double.parse((json['score']).toString()),
        percent = double.parse((json['percent']).toString());

}
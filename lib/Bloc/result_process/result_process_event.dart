part of 'result_process_bloc.dart';

@immutable
abstract class ResultProcessEvent {}

class InitialResultProcessEvent extends ResultProcessEvent {}

class LoadingResultProcessEvent extends ResultProcessEvent {
  final String key;
  final String answerPackId;
  final String questionnaireName;
  final String dateTime;

  LoadingResultProcessEvent(this.key,this.answerPackId,this.questionnaireName,this.dateTime);

}

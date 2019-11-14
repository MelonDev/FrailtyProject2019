part of 'result_process_bloc.dart';

@immutable
abstract class ResultProcessState {}

class InitialResultProcessState extends ResultProcessState {
  @override
  String toString() {
    return "InitialResultProcessState";
  }
}

class LoadingResultProcessState extends ResultProcessState {
  @override
  String toString() {
    return "LoadingResultProcessState";
  }
}

class LoadedResultProcessState extends ResultProcessState {

  final ResultAfterProcess resultAfterProcess;

  LoadedResultProcessState(this.resultAfterProcess);

  @override
  String toString() {
    return "LoadedResultProcessState";
  }
}
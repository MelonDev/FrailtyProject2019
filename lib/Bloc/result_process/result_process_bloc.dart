import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:frailty_project_2019/Model/ResultAfterProcess.dart';
import 'package:meta/meta.dart';

import 'package:http/http.dart' as http;

part 'result_process_event.dart';
part 'result_process_state.dart';

class ResultProcessBloc extends Bloc<ResultProcessEvent, ResultProcessState> {
  @override
  ResultProcessState get initialState => InitialResultProcessState();

  @override
  Stream<ResultProcessState> mapEventToState(ResultProcessEvent event) async* {
    if (event is LoadingResultProcessEvent) {
      yield* _mapResultLoadingToState(event);
    }
  }

  Stream<ResultProcessState> _mapResultLoadingToState(LoadingResultProcessEvent event) async* {
    yield LoadingResultProcessState();

    String url =
        'https://melondev-frailty-project.herokuapp.com/api/result/calculating';
    var body = json.encode({"key": event.key, "answerPackId": event.answerPackId, "questionnaireName": event.questionnaireName, "dateTime": event.dateTime});

    var response = await http.post(url, body: body,headers: {'Content-type': 'application/json'});

    print("RESULT :${response.body}");

    ResultAfterProcess resultAfterProcess = ResultAfterProcess.fromJson(jsonDecode(response.body));

    yield LoadedResultProcessState(resultAfterProcess);


  }
}

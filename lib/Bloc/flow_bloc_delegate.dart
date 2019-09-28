import 'package:bloc/bloc.dart';

class FlowBlocDelegate extends BlocDelegate {

  @override
  void onEvent(Bloc bloc, Object event) {

  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    print(error);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);

  }
}
part of 'catalogue_bloc.dart';

@immutable
abstract class CatalogueEvent {}

abstract class CatalogueDelegate {
  void onSuccess(String message);

  void onError(String message);
}


class QuestionnaireSelectedEvent extends CatalogueEvent {}


class UncompletedSelectedEvent extends CatalogueEvent {}


class CompletedSelectedEvent extends CatalogueEvent {}
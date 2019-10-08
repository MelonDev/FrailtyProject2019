part of 'catalogue_bloc.dart';

@immutable
abstract class CatalogueState {}

class InitialCatalogueState extends CatalogueState {}

class LoadingCatalogueState extends CatalogueState {
  @override
  String toString() {
    return "LoadingCatalogueState";
  }
}

class QuestionnaireCatalogueState extends CatalogueState {
  final List<Questionnaire> questionnaireList;

  QuestionnaireCatalogueState(this.questionnaireList);

  @override
  String toString() {
    return "LoadingCatalogueState";
  }
}

class UncompletedCatalogueState extends CatalogueState {
  @override
  String toString() {
    return "UncompletedCatalogueState";
  }
}

class CompletedCatalogueState extends CatalogueState {
  @override
  String toString() {
    return "CompletedCatalogueState";
  }
}

class ErrorCatalogueState extends CatalogueState {
  @override
  String toString() {
    return "CompletedCatalogueState";
  }
}
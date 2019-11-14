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
  final List<UncompleteDataPack> data;

  UncompletedCatalogueState(this.data);

  @override
  String toString() {
    return "UncompletedCatalogueState";
  }
}

class CompletedCatalogueState extends CatalogueState {

  final List<CompleteItem> data;

  CompletedCatalogueState(this.data);

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
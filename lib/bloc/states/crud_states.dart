enum ProcessType {
  create, update, delete
}

abstract class CrudState {}

class ListReadState<T> extends CrudState {
  final List<T> list;

  ListReadState(this.list);
}

class ProcessState extends CrudState{
  final String message;
  final bool status;
  final ProcessType processType;

  ProcessState(this.message, this.status, this.processType);
}

class DefaultState extends CrudState {}

class LoadingState extends CrudState{}
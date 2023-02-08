abstract class CrudEvents {}

class CreateEvent<T> extends CrudEvents {
  final T object;

  CreateEvent(this.object);
}

class ReadEvent extends CrudEvents {}

class UpdateEvent<T> extends CrudEvents {
  final T object;

  UpdateEvent(this.object);
}

class DeleteEvent extends CrudEvents {
  final int index;

  DeleteEvent(this.index);
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vp12_database/bloc/events/crud_events.dart';
import 'package:vp12_database/bloc/states/crud_states.dart';
import 'package:vp12_database/database/controller/note_db_controller.dart';
import 'package:vp12_database/models/note.dart';

class NoteBloc extends Bloc<CrudEvents, CrudState> {
  NoteBloc(CrudState initialState) : super(initialState) {
    on<CreateEvent<Note>>(_createEvent);
    on<ReadEvent>(_readEvent);
    on<DeleteEvent>(_deleteEvent);
    on<UpdateEvent<Note>>(_updateEvent);
  }

  final NoteDbController _noteDbController = NoteDbController();
  List<Note> _notes = <Note>[];

  void _updateEvent(UpdateEvent<Note> event, Emitter emit) async {
    bool updated = await _noteDbController.update(event.object);
    if(updated) {
      int index = _notes.indexWhere((element) => element.id == event.object.id);
      if(index != -1) {
        _notes[index] = event.object;
        emit(ListReadState<Note>(_notes));
      }
    }
    String message = updated ? 'Updated successfully' : 'Update failed!';
    emit(ProcessState(message, updated, ProcessType.update));
  }

  void _deleteEvent(DeleteEvent event, Emitter emit) async {
    bool deleted = await _noteDbController.delete(_notes[event.index].id);
    if (deleted) {
      _notes.removeAt(event.index);
      emit(ListReadState<Note>(_notes));
    }
    String message = deleted ? 'Deleted successfully' : 'Delete failed';
    emit(ProcessState(message, deleted, ProcessType.delete));
  }

  void _readEvent(ReadEvent event, Emitter emit) async {
    emit(LoadingState());
    _notes = await _noteDbController.read();
    emit(ListReadState<Note>(_notes));
  }

  void _createEvent(CreateEvent<Note> event, Emitter emit) async {
    int newRowId = await _noteDbController.create(event.object);
    if (newRowId != 0) {
      event.object.id = newRowId;
      _notes.add(event.object);
      emit(ListReadState<Note>(_notes));
    }
    String message = newRowId != 0 ? 'Created Successfully' : 'Create Failed';
    emit(ProcessState(message, newRowId != 0, ProcessType.create));
  }
}

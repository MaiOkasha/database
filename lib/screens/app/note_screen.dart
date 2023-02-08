import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vp12_database/bloc/bloc/note_bloc.dart';
import 'package:vp12_database/bloc/events/crud_events.dart';
import 'package:vp12_database/bloc/states/crud_states.dart';
import 'package:vp12_database/models/note.dart';
import 'package:vp12_database/storage/pref_controller.dart';
import 'package:vp12_database/utils/helpers.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key, this.note}) : super(key: key);

  final Note? note;

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> with Helpers {
  late TextEditingController _titleTextController;
  late TextEditingController _infoTextController;

  @override
  void initState() {
    super.initState();
    _titleTextController = TextEditingController(text: widget.note?.title);
    _infoTextController = TextEditingController(text: widget.note?.details);
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _infoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN'),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocListener<NoteBloc, CrudState>(
        listenWhen: (previous, current) =>
            current is ProcessState &&
            (current.processType == ProcessType.create ||
                current.processType == ProcessType.update),
        listener: (context, state) {
          state as ProcessState;
          showSnackBar(context, message: state.message, error: !state.status);
          state.processType == ProcessType.create ? clear() : Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              const Text(
                'New Note',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const Text(
                "Enter note details",
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _titleTextController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Name',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 1,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _infoTextController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Info',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 1,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => performSave(),
                child: const Text('SAVE'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void performSave() {
    if (checkData()) {
      save();
    }
  }

  bool checkData() {
    if (_titleTextController.text.isNotEmpty &&
        _infoTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, message: 'Enter required data', error: true);
    return false;
  }

  void save() {
    // bool saved = isCreate()
    //     ? await Provider.of<NoteProvider>(context,listen: false).create(note: note)
    //     : await Provider.of<NoteProvider>(context,listen: false).update(note);

    // bool saved = isCreate()
    //     ? await NoteGetController.to.create(note: note)
    //     : await NoteGetController.to.updateNote(note);

    isCreate()
        ? BlocProvider.of<NoteBloc>(context).add(CreateEvent<Note>(note))
        : BlocProvider.of<NoteBloc>(context).add(UpdateEvent<Note>(note));
  }

  bool isCreate() => widget.note == null;

  Note get note {
    Note note = Note();
    if (!isCreate()) {
      note.id = widget.note!.id;
    }
    note.title = _titleTextController.text;
    note.details = _infoTextController.text;
    note.userId =
        PrefController().getValueFor<int>(key: PrefKeys.id.toString())!;
    return note;
  }

  void clear() {
    _titleTextController.text = '';
    _infoTextController.text = '';
  }
}

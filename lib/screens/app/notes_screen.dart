import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vp12_database/bloc/bloc/note_bloc.dart';
import 'package:vp12_database/bloc/events/crud_events.dart';
import 'package:vp12_database/bloc/states/crud_states.dart';
import 'package:vp12_database/get/note_get_controller.dart';
import 'package:vp12_database/models/note.dart';
import 'package:vp12_database/providers/note_provider.dart';
import 'package:vp12_database/screens/app/note_screen.dart';
import 'package:vp12_database/utils/helpers.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> with Helpers {
  // final NoteGetController _noteGetController = Get.put(NoteGetController());

  @override
  void initState() {
    super.initState();
    // Provider.of<NoteProvider>(context, listen: false).read();
    BlocProvider.of<NoteBloc>(context).add(ReadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        actionsIconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoteScreen(),
                ),
              );
            },
            icon: const Icon(Icons.note_add),
          ),
          IconButton(
            onPressed: () async {
              bool deleted = await Get.delete<NoteGetController>();
              Navigator.pushReplacementNamed(context, '/login_screen');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocConsumer<NoteBloc, CrudState>(
        listenWhen: (previous, current) =>
        current is ProcessState &&
            current.processType == ProcessType.delete,
        listener: (context, state) {
          state as ProcessState;
          showSnackBar(context, message: state.message, error: !state.status);
        },
        buildWhen: (previous, current) =>
        current is ListReadState<Note> || current is LoadingState,
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ListReadState<Note> && state.list.isNotEmpty) {
            return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteScreen(
                          note: state.list[index],
                        ),
                      ),
                    );
                  },
                  leading: const Icon(Icons.note),
                  title: Text(state.list[index].title),
                  subtitle: Text(state.list[index].details),
                  trailing: IconButton(
                    onPressed: () {
                      BlocProvider.of<NoteBloc>(context)
                          .add(DeleteEvent(index));
                    },
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.warning,
                    size: 80,
                  ),
                  Text(
                    'NO DATA',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
      // body: BlocListener<NoteBloc, CrudState>(
      //   listenWhen: (previous, current) =>
      //       current is ProcessState &&
      //       current.processType == ProcessType.delete,
      //   listener: (context, state) {
      //     state as ProcessState;
      //     showSnackBar(context, message: state.message, error: !state.status);
      //   },
      //   child: BlocBuilder<NoteBloc, CrudState>(
      //     buildWhen: (previous, current) =>
      //         current is ListReadState<Note> || current is LoadingState,
      //     builder: (context, state) {
      //       if (state is LoadingState) {
      //         return const Center(child: CircularProgressIndicator());
      //       } else if (state is ListReadState<Note> && state.list.isNotEmpty) {
      //         return ListView.builder(
      //           itemCount: state.list.length,
      //           itemBuilder: (context, index) {
      //             return ListTile(
      //               onTap: () {
      //                 Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                     builder: (context) => NoteScreen(
      //                       note: state.list[index],
      //                     ),
      //                   ),
      //                 );
      //               },
      //               leading: const Icon(Icons.note),
      //               title: Text(state.list[index].title),
      //               subtitle: Text(state.list[index].details),
      //               trailing: IconButton(
      //                 onPressed: () {
      //                   BlocProvider.of<NoteBloc>(context)
      //                       .add(DeleteEvent(index));
      //                 },
      //                 icon: const Icon(Icons.delete),
      //               ),
      //             );
      //           },
      //         );
      //       } else {
      //         return Center(
      //           child: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: const [
      //               Icon(
      //                 Icons.warning,
      //                 size: 80,
      //               ),
      //               Text(
      //                 'NO DATA',
      //                 style: TextStyle(
      //                   fontSize: 26,
      //                   fontWeight: FontWeight.bold,
      //                   color: Colors.black45,
      //                 ),
      //               )
      //             ],
      //           ),
      //         );
      //       }
      //     },
      //   ),
      // ),
      // body: Obx(
      //   () {
      //     if (_noteGetController.loading.isTrue) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (_noteGetController.notes.isNotEmpty) {
      //       return ListView.builder(
      //         itemCount: _noteGetController.notes.length,
      //         itemBuilder: (context, index) {
      //           return ListTile(
      //             onTap: () {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => NoteScreen(
      //                     note: _noteGetController.notes[index],
      //                   ),
      //                 ),
      //               );
      //             },
      //             leading: const Icon(Icons.note),
      //             title: Text(_noteGetController.notes[index].title),
      //             subtitle: Text(_noteGetController.notes[index].details),
      //             trailing: IconButton(
      //               onPressed: () => deleteNote(index),
      //               icon: const Icon(Icons.delete),
      //             ),
      //           );
      //         },
      //       );
      //     } else {
      //       return Center(
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           children: const [
      //             Icon(
      //               Icons.warning,
      //               size: 80,
      //             ),
      //             Text(
      //               'NO DATA',
      //               style: TextStyle(
      //                 fontSize: 26,
      //                 fontWeight: FontWeight.bold,
      //                 color: Colors.black45,
      //               ),
      //             )
      //           ],
      //         ),
      //       );
      //     }
      //   },
      // ),
      // body: GetX<NoteGetController>(
      //   init: NoteGetController(),
      //   global: true,
      //   builder: (controller) {
      //     if (controller.loading.isTrue) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (controller.notes.isNotEmpty) {
      //       return ListView.builder(
      //         itemCount: controller.notes.length,
      //         itemBuilder: (context, index) {
      //           return ListTile(
      //             onTap: () {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => NoteScreen(
      //                     note: controller.notes[index],
      //                   ),
      //                 ),
      //               );
      //             },
      //             leading: const Icon(Icons.note),
      //             title: Text(controller.notes[index].title),
      //             subtitle: Text(controller.notes[index].details),
      //             trailing: IconButton(
      //               onPressed: () => deleteNote(index),
      //               icon: const Icon(Icons.delete),
      //             ),
      //           );
      //         },
      //       );
      //     } else {
      //       return Center(
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           children: const [
      //             Icon(
      //               Icons.warning,
      //               size: 80,
      //             ),
      //             Text(
      //               'NO DATA',
      //               style: TextStyle(
      //                 fontSize: 26,
      //                 fontWeight: FontWeight.bold,
      //                 color: Colors.black45,
      //               ),
      //             )
      //           ],
      //         ),
      //       );
      //     }
      //   },
      // ),
      // body: GetBuilder<NoteGetController>(
      //   init: NoteGetController(),
      //   global: true,
      //   id: 'NotesScreen-Read',
      //   builder: (NoteGetController controller) {
      //     if (controller.loading) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (controller.notes.isNotEmpty) {
      //       return ListView.builder(
      //         itemCount: controller.notes.length,
      //         itemBuilder: (context, index) {
      //           return ListTile(
      //             onTap: () {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => NoteScreen(
      //                     note: controller.notes[index],
      //                   ),
      //                 ),
      //               );
      //             },
      //             leading: const Icon(Icons.note),
      //             title: Text(controller.notes[index].title),
      //             subtitle: Text(controller.notes[index].details),
      //             trailing: IconButton(
      //               onPressed: () => deleteNote(index),
      //               icon: const Icon(Icons.delete),
      //             ),
      //           );
      //         },
      //       );
      //     } else {
      //       return Center(
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           children: const [
      //             Icon(
      //               Icons.warning,
      //               size: 80,
      //             ),
      //             Text(
      //               'NO DATA',
      //               style: TextStyle(
      //                 fontSize: 26,
      //                 fontWeight: FontWeight.bold,
      //                 color: Colors.black45,
      //               ),
      //             )
      //           ],
      //         ),
      //       );
      //     }
      //   },
      // ),
      // body: Consumer<NoteProvider>(
      //   builder: (context, NoteProvider value, child) {
      //     if (value.loading) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (value.notes.isNotEmpty) {
      //       return ListView.builder(
      //         itemCount: value.notes.length,
      //         itemBuilder: (context, index) {
      //           return ListTile(
      //             onTap: () {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => NoteScreen(
      //                     note: value.notes[index],
      //                   ),
      //                 ),
      //               );
      //             },
      //             leading: const Icon(Icons.note),
      //             title: Text(value.notes[index].title),
      //             subtitle: Text(value.notes[index].details),
      //             trailing: IconButton(
      //               onPressed: () => deleteNote(index),
      //               icon: const Icon(Icons.delete),
      //             ),
      //           );
      //         },
      //       );
      //     } else {
      //       return Center(
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           children: const [
      //             Icon(
      //               Icons.warning,
      //               size: 80,
      //             ),
      //             Text(
      //               'NO DATA',
      //               style: TextStyle(
      //                 fontSize: 26,
      //                 fontWeight: FontWeight.bold,
      //                 color: Colors.black45,
      //               ),
      //             )
      //           ],
      //         ),
      //       );
      //     }
      //   },
      // ),
    );
  }

  void deleteNote(int index) async {
    // bool _deleted =
    //     await Provider.of<NoteProvider>(context, listen: false).delete(index);

    bool _deleted = await NoteGetController.to.delete(index);
    String message =
        _deleted ? 'Note deleted successfully' : 'Note delete failed';
    showSnackBar(context, message: message, error: !_deleted);
  }
}

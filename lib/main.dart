import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vp12_database/bloc/bloc/note_bloc.dart';
import 'package:vp12_database/bloc/states/crud_states.dart';
import 'package:vp12_database/database/db_controller.dart';
import 'package:vp12_database/providers/note_provider.dart';
import 'package:vp12_database/providers/user_provider.dart';
import 'package:vp12_database/screens/app/notes_screen.dart';
import 'package:vp12_database/screens/auth/login_screen.dart';
import 'package:vp12_database/screens/auth/register_screen.dart';
import 'package:vp12_database/screens/launch_screen.dart';
import 'package:vp12_database/storage/pref_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefController().initPref();
  await DbController().initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteBloc>(create: (context) => NoteBloc(LoadingState())),
      ],
      child: MaterialApp(
        initialRoute: '/launch_screen',
        routes: {
          '/launch_screen': (context) => const LaunchScreen(),
          '/login_screen': (context) => const LoginScreen(),
          '/register_screen': (context) => const RegisterScreen(),
          '/notes_screen': (context) => const NotesScreen(),
        },
      ),
    );
  }
}


// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider<UserProvider>(
//             create: (context) => UserProvider()),
//         ChangeNotifierProvider<NoteProvider>(
//             create: (context) => NoteProvider()),
//       ],
//       child: MaterialApp(
//         initialRoute: '/launch_screen',
//         routes: {
//           '/launch_screen': (context) => const LaunchScreen(),
//           '/login_screen': (context) => const LoginScreen(),
//           '/register_screen': (context) => const RegisterScreen(),
//           '/notes_screen': (context) => const NotesScreen(),
//         },
//       ),
//     );
//   }
// }

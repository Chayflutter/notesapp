import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/note_database.dart';
import 'package:provider/provider.dart';
import 'pages/notesPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();
  runApp(ChangeNotifierProvider(
    create: (context) => NoteDatabase(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
      Theme.of(context).textTheme,
    )
      ),
      debugShowCheckedModeBanner: false,
      home: Notespage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:myapp/models/note_database.dart';
import 'package:myapp/models/notes.dart';
import 'package:provider/provider.dart';

class Notespage extends StatefulWidget {
  const Notespage({super.key});

  @override
  State<Notespage> createState() => _NotespageState();
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Page 2'),
      ),
    );
  }
}

class _NotespageState extends State<Notespage> {
  final textController = TextEditingController();
  final textController2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    readNote();
  }

  void createNote() {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                content: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: "Heading"),
                      controller: textController2,
                    ),
                    TextField(
                      controller: textController,
                    ),
                  ],
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      context.read<NoteDatabase>().addNote(textController.text, textController2.text);
                      textController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Create'),
                  )
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) => const Page2());
  }

  void readNote() {
    context.read<NoteDatabase>().fetchNotes();
  }

  void updateNote(Note note) {
    textController.text = note.text;

    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                title: Text('Update note'),
                content: Column(
                  children: [
                    TextField(
                      controller: textController,
                    ),
                    TextField(
                      controller: textController2,
                    ),
                  ],
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      context
                          .read<NoteDatabase>()
                          .updateNote(note.id, textController.text);
                      textController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Update'),
                  )
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) => const Page2());
  }

  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  void _navigateToNextScreen(BuildContext context, Note note) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>  NewScreen(data:note),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Notes',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 30),
        )),
        backgroundColor: Colors.amber,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton(
            onPressed: createNote,
            child: const Icon(Icons.edit),
            backgroundColor: Colors.amber.shade400,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100))),
      ),
      body: ListView.builder(
          itemCount: currentNotes.length,
          itemBuilder: (context, index) {
            final note = currentNotes[index];
            return ListTile(
              title: Text(note.heading,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  )),
                  subtitle: Text(note.text),
                  
              onTap: () {
                _navigateToNextScreen(context, note);
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () => updateNote(note),
                      icon: Icon(Icons.edit_note)),
                  IconButton(
                      onPressed: () => deleteNote(note.id),
                      icon: Icon(Icons.delete))
                ],
              ),
            );
          }),
    );
  }
}

class NewScreen extends StatelessWidget {
  final Note data;
  const NewScreen({required this.data, super.key});
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(title: Text(data.heading)),
      body: Center(
        child: Text(
          data.text,
          style: const TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}

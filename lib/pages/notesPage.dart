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
                content: TextField(
                  controller: textController,
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      context.read<NoteDatabase>().addNote(textController.text);
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
                content: TextField(
                  controller: textController,
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

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NewScreen()));
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
              title: Text(note.text,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  )),
              onTap: () {
                _navigateToNextScreen(context);
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Screen')),
      body: const Center(
        child: Text(
          'This is a new screen',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:myapp/models/note_database.dart';
import 'package:myapp/models/notes.dart';
import 'package:provider/provider.dart';

class Notespage extends StatefulWidget {
  const Notespage({Key? key}) : super(key: key);

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
      final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
      return Transform(
        transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
        child: Opacity(
          opacity: a1.value,
          child: AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: [
                MaterialButton(onPressed: () {
                  context.read<NoteDatabase>().addNote(textController.text);
                  textController.clear();
            Navigator.pop(context);
                },
                child: const Text('Create'),)
              ],
            ),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 200),
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder:  (context, animation1, animation2) =>const Page2());
  }

  void readNote(){
    context.watch<NoteDatabase>().fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();
    List <Note> currentNotes = noteDatabase.currentNotes;

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
        itemBuilder: (context, index){
        final note = currentNotes[index];
        return ListTile(
          title: Text(note.text),
        );
      }),
    );
  }
}

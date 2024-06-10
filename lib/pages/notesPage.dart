import 'package:flutter/material.dart';
import 'package:myapp/models/note_database.dart';
import 'package:provider/provider.dart';

class Notespage extends StatefulWidget {
  const Notespage({Key? key}) : super(key: key);

  @override
  State<Notespage> createState() => _NotespageState();
}

class _NotespageState extends State<Notespage> {
  final textController = TextEditingController();

  void createNote() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: [
                MaterialButton(onPressed: () {
                  context.read<NoteDatabase>().addNote(textController.text);
                  
            Navigator.pop(context);
                },
                child: const Text('Create'),)
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
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
    );
  }
}

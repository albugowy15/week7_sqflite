import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:week7_sqflite/db/notes_database.dart';
import 'package:week7_sqflite/model/note.dart';
import 'package:week7_sqflite/page/edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;
  const NoteDetailPage({super.key, required this.noteId});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    note = await NotesDatabase.instance.readNote(widget.noteId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [editButton(), deleteButton()]),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    DateFormat.yMMMd().format(note.createdTime),
                    style: const TextStyle(color: Colors.white38),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    note.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ],
              )),
    );
  }

  Widget editButton() => IconButton(
        onPressed: () async {
          if (isLoading) return;
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddEditNotePage(note: note),
          ));
          refreshNotes();
        },
        icon: const Icon(Icons.edit_outlined),
      );

  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await NotesDatabase.instance.delete(widget.noteId);
          Navigator.of(context).pop();
        },
      );
}

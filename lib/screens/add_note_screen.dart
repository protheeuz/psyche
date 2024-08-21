import 'package:flutter/material.dart';
import '../repositories/noted_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNoteScreen extends StatefulWidget {
  final Map<String, String>? note;

  const AddNoteScreen({super.key, this.note});

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final NotedRepository _notedRepository = NotedRepository();
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    
    // Jika note ada, isi TextField dengan nilai note tersebut
    if (widget.note != null) {
      _titleController.text = widget.note!['title'] ?? '';
      _contentController.text = widget.note!['content'] ?? '';
    }
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('user_id');
  }

  Future<void> _saveNote() async {
    if (_userId == null) return;

    final title = _titleController.text;
    final content = _contentController.text;

    final note = {'title': title, 'content': content};

    Navigator.pop(context, note); // Kembalikan catatan yang baru disimpan atau diubah
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 50),
            child: TextField(
              controller: _titleController,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'Judul',
                hintStyle: TextStyle(color: Colors.black54),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, top: 20, right: 10),
              child: TextField(
                controller: _contentController,
                style: const TextStyle(color: Colors.black),
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Isi catatan',
                  hintStyle: TextStyle(color: Colors.black45),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _saveNote,
              child: const Text('Simpan'),
            ),
          ),
        ],
      ),
    );
  }
}
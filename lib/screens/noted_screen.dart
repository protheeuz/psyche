import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../core/constants/app_strings.dart';
import '../repositories/noted_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_note_screen.dart';

class NotedScreen extends StatefulWidget {
  const NotedScreen({super.key});

  @override
  _NotedScreenState createState() => _NotedScreenState();
}

class _NotedScreenState extends State<NotedScreen> {
  List<Map<String, String>> _notes = [];
  final NotedRepository _notedRepository = NotedRepository();
  int? _userId;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) => _loadUserIdAndNotes());
  }

  Future<void> _loadUserIdAndNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('user_id');

    if (_userId != null) {
      final notes = await _notedRepository.getNotes(_userId!);
      setState(() {
        _notes = notes;
      });
    }
  }

  Future<void> _deleteNoteAtIndex(int index) async {
    setState(() {
      _notes.removeAt(index);
    });

    await _notedRepository.saveNotes(_notes, _userId!);
  }

  Future<void> _editNoteAtIndex(int index) async {
    final editedNote = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNoteScreen(
          note: _notes[index],
        ),
      ),
    );

    if (editedNote != null) {
      setState(() {
        _notes[index] = editedNote;
      });

      await _notedRepository.saveNotes(_notes, _userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notedWelcome),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                final title = note['title'] ?? 'Catatan';
                final content = note['content'] ?? '';

                // Menggunakan intl untuk memformat tanggal dan jam
                final formattedDate = DateFormat('EEEE, dd MMMM yyyy, HH:mm', 'id_ID')
                    .format(DateTime.now());

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      _editNoteAtIndex(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              content,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Waktu: $formattedDate',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'delete') {
                                      _deleteNoteAtIndex(index);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Hapus'),
                                      ),
                                    ];
                                  },
                                  icon: const Icon(Icons.more_vert),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNoteScreen(),
            ),
          );

          if (newNote != null) {
            setState(() {
              _notes.add(newNote
                  as Map<String, String>); // Tambahkan catatan baru ke daftar
            });
            await _notedRepository.saveNotes(_notes, _userId!);
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
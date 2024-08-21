import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotedRepository {
  Future<void> insertNote(Map<String, String> note, int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notes = prefs.getStringList('notes_$userId') ?? [];
    notes.add(jsonEncode(note)); // Serialize the note to JSON
    await prefs.setStringList('notes_$userId', notes);
  }

  Future<List<Map<String, String>>> getNotes(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notes = prefs.getStringList('notes_$userId') ?? [];
    return notes.map((note) => Map<String, String>.from(jsonDecode(note))).toList(); // Deserialize JSON to Map
  }

  saveNotes(List<Map<String, String>> notes, int i) {}
}
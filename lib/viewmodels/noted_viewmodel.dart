import '../repositories/noted_repository.dart';

class NotedViewModel {
  final NotedRepository _notedRepository = NotedRepository();

  Future<void> addNote(String note) async {
    await _notedRepository.insertNote(note);
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    return await _notedRepository.getNotes();
  }
}

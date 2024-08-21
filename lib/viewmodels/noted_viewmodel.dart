import '../repositories/noted_repository.dart';

class NotedViewModel {
  final NotedRepository _notedRepository = NotedRepository();

  Future<void> addNote(Map<String, String> note, int userId) async {
    await _notedRepository.insertNote(note, userId);
  }

  Future<List<Map<String, String>>> getNotes(int userId) async {
    return await _notedRepository.getNotes(userId);
  }
}
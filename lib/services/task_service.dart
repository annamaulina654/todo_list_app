import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class TaskService {
  static const String baseUrl = 'https://coba-4c9b1-default-rtdb.firebaseio.com/tasks';

  static Future<void> addTask(Task task) async {
    final url = Uri.parse('$baseUrl.json');
    try {
      final response = await http.post(url, body: json.encode(task.toJson()));
      if (response.statusCode != 200) {
        throw Exception('Gagal menambahkan tugas.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  static Future<List<Task>> fetchTasks() async {
    final url = Uri.parse('$baseUrl.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        if (response.body == 'null') {
          return [];
        }
        final Map<String, dynamic> data = json.decode(response.body);
        return data.entries.map((entry) {
          final value = entry.value as Map<String, dynamic>;
          value['id'] = entry.key;
          return Task.fromJson(value);
        }).toList();
      } else {
        throw Exception('Gagal memuat tugas.');
      }
    } catch (e) {
      throw Exception('Gagal memuat tugas: $e');
    }
  }
  
  static Future<void> updateTask(String id, Task task) async {
    final url = Uri.parse('$baseUrl/$id.json');
    try {
      final response = await http.put(url, body: json.encode(task.toJson()));
      if (response.statusCode != 200) {
        throw Exception('Gagal memperbarui tugas.');
      }
    } catch (e) {
      throw Exception('Gagal memperbarui tugas: $e');
    }
  }

  static Future<void> deleteTask(String id) async {
    final url = Uri.parse('$baseUrl/$id.json');
    try {
      final response = await http.delete(url);
      if (response.statusCode != 200) {
        throw Exception('Gagal menghapus tugas.');
      }
    } catch (e) {
      throw Exception('Gagal menghapus tugas: $e');
    }
  }
}
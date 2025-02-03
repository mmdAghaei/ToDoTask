import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todotask/screens/taskClass.dart';

class TaskService {
  final String baseUrl = 'https://retoolapi.dev/de1t8o/mmd';

  // Get all tasks
  Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  // Create a new task
  Future<Task> createTask(Task newTask) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newTask.toJson()),
    );
    if (response.statusCode == 201) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }

  // Update a task
  Future<Task> updateTask(int id, Task updatedTask) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedTask.toJson()),
    );
    if (response.statusCode == 200) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update task');
    }
  }

  // Delete a task
  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}

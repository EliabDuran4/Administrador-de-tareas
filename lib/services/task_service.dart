// lib/services/task_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class TaskService {
  static const String _key = 'tasks_list';

  // Guarda la lista completa de tareas
  static Future<void> saveTasks(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList = tasks.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  // Carga las tareas guardadas (devuelve lista vacía si no hay)
  static Future<List<TaskModel>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(_key);
    if (jsonList == null) return <TaskModel>[];
    return jsonList.map((s) {
      final Map<String, dynamic> map = jsonDecode(s) as Map<String, dynamic>;
      return TaskModel.fromJson(map);
    }).toList();
  }

  // Elimina todas las tareas
  static Future<void> clearTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskModel> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final loaded = await TaskService.loadTasks();
    setState(() {
      tasks = loaded;
    });
  }

  Future<void> _addTask(String title, DateTime? reminderTime) async {
    final task = TaskModel(
      id: Random().nextInt(999999).toString(),
      title: title,
      description: 'Sin descripción',
      isCompleted: false,
      createdAt: DateTime.now(),
      reminderTime: reminderTime,
    );
    setState(() {
      tasks.add(task);
    });
    await TaskService.saveTasks(tasks);
  }

  Future<void> _deleteTask(String id) async {
    setState(() {
      tasks.removeWhere((t) => t.id == id);
    });
    await TaskService.saveTasks(tasks);
  }

  Future<void> _toggleCompleted(TaskModel task) async {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
    await TaskService.saveTasks(tasks);
  }

  Future<void> _addTaskDialog(BuildContext context) async {
    String newTask = '';
    DateTime? selectedDate;

    return showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Nueva tarea"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Escribe tu tarea",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => newTask = value,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate == null
                        ? "Sin recordatorio"
                        : "📅 ${selectedDate.toString().substring(0, 16)}",
                    style: const TextStyle(fontSize: 13),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_month_outlined),
                    tooltip: "Seleccionar fecha y hora",
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          final fullDate = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          setDialogState(() {
                            selectedDate = fullDate;
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text("Guardar"),
              onPressed: () async {
                if (newTask.trim().isNotEmpty) {
                  await _addTask(newTask, selectedDate);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Administrador de Tareas"),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                "No hay tareas aún 😴",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: task.isCompleted ? Colors.grey : Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (task.reminderTime != null)
                          Text(
                            "⏰ Recordatorio: ${task.reminderTime}",
                            style: const TextStyle(
                                fontSize: 13, color: Colors.teal),
                          ),
                        Text(
                          "🕒 Creada: ${task.createdAt.toLocal()}",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        Checkbox(
                          value: task.isCompleted,
                          onChanged: (_) => _toggleCompleted(task),
                          activeColor: Colors.teal,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.redAccent),
                          onPressed: () => _deleteTask(task.id),
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fade(duration: 400.ms)
                    .slideY(begin: 0.2, end: 0);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addTaskDialog(context),
        label: const Text("Nueva tarea"),
        icon: const Icon(Icons.add_task),
      ),
    );
  }
}

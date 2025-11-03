// lib/pages/task_list_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final TextEditingController _textController = TextEditingController();
  List<TaskModel> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final loaded = await TaskService.loadTasks();
    setState(() => _tasks = loaded);
  }

  Future<void> _saveTasks() async {
    await TaskService.saveTasks(_tasks);
  }

  Future<void> _addTaskFromInput() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: text,
      description: '',
      isCompleted: false,
    );
    setState(() {
      _tasks.add(newTask);
      _textController.clear();
    });
    await _saveTasks();
  }

  Future<void> _editTaskDialog(int index) async {
    final task = _tasks[index];
    final controller = TextEditingController(text: task.title);

    final newTitle = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar tarea'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Título'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (newTitle != null && newTitle.isNotEmpty) {
      setState(() {
        _tasks[index].title = newTitle;
      });
      await _saveTasks();
    }
  }

  Future<void> _toggleCompleted(int index) async {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    await _saveTasks();
  }

  Future<void> _deleteTask(int index) async {
    setState(() {
      _tasks.removeAt(index);
    });
    await _saveTasks();
  }

  // Marca todas las tareas como completadas
  Future<void> _markAllCompleted() async {
    setState(() {
      for (var t in _tasks) {
        t.isCompleted = true;
      }
    });
    await _saveTasks();
  }

  // Borra las tareas completadas
  Future<void> _deleteCompleted() async {
    setState(() {
      _tasks.removeWhere((t) => t.isCompleted);
    });
    await _saveTasks();
  }

  // Contador de pendientes (útil si lo quieres mostrar)
  int get _pendingCount => _tasks.where((t) => !t.isCompleted).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrador de Tareas'),
        centerTitle: true,
        actions: [
          // Mostrar contador como chip pequeño
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Center(
              child: Text(
                'Pendientes: $_pendingCount',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'markAll') {
                _markAllCompleted();
              } else if (value == 'deleteCompleted') {
                _deleteCompleted();
              } else if (value == 'clearAll') {
                // opcional: borrar todo
                setState(() => _tasks.clear());
                _saveTasks();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'markAll', child: Text('Marcar todas como completadas')),
              PopupMenuItem(value: 'deleteCompleted', child: Text('Borrar tareas completadas')),
              PopupMenuItem(value: 'clearAll', child: Text('Borrar todas (opcional)')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Input + botón agregar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Nueva tarea',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTaskFromInput(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTaskFromInput,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          // Lista de tareas
          Expanded(
            child: _tasks.isEmpty
                ? const Center(child: Text('No hay tareas aún 😴', style: TextStyle(fontSize: 18)))
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (_) => _toggleCompleted(index),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration:
                                  task.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          subtitle: Text('Creada: ${task.createdAt.toLocal()}'.split('.').first),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editTaskDialog(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteTask(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

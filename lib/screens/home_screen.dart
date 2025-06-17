import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Task>> _tasksFuture;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Kuliah', 'Organisasi', 'Pribadi', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  void _refreshTasks() {
    setState(() {
      _tasksFuture = TaskService.fetchTasks();
    });
  }

  void _toggleCompletion(Task task) async {
    task.isCompleted = !task.isCompleted;
    try {
      await TaskService.updateTask(task.id!, task);
      _refreshTasks();
    } catch (e) {
      setState(() {
        task.isCompleted = !task.isCompleted;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List Mahasiswa'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedFilter,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: const Color(0xFF2A4463), 
              ),
              dropdownColor: const Color(0xFF2A4463),
              items: _filters.map((String filter) {
                return DropdownMenuItem<String>(
                  value: filter,
                  child: Text(filter, style: Theme.of(context).textTheme.titleMedium),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Task>>(
              future: _tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Belum ada tugas.'));
                }

                final allTasks = snapshot.data!;
                final List<Task> filteredTasks;

                if (_selectedFilter == 'All') {
                  filteredTasks = allTasks;
                } else {
                  filteredTasks = allTasks.where((task) => task.category == _selectedFilter).toList();
                }

                if (filteredTasks.isEmpty) {
                  return Center(child: Text('Tidak ada tugas dalam kategori "$_selectedFilter".'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return Card(
                      color: const Color(0xFF5993A2),
                      margin: const EdgeInsets.only(bottom: 12.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailScreen(task: task),
                            ),
                          );
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        title: Text(task.title, style: Theme.of(context).textTheme.titleMedium),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Deadline: ${DateFormat('d MMMM yyyy', 'id_ID').format(task.deadline)}',
                                style: Theme.of(context).textTheme.bodySmall
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  task.category, 
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: Checkbox(
                          value: task.isCompleted,
                          onChanged: (bool? value) {
                            _toggleCompletion(task);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          ).then((_) => _refreshTasks());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
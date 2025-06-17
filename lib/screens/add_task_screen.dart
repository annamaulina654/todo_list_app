import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _deadlineController = TextEditingController();

  String _selectedCategory = 'Organisasi';
  DateTime? _selectedDate;
  final List<String> _categories = ['Organisasi', 'Kuliah', 'Pribadi', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    _titleController.text = "Rapat Akbar";
    _selectedDate = DateTime(2025, 6, 2);
    _deadlineController.text = DateFormat('d MMMM yyyy', 'id_ID').format(_selectedDate!);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _deadlineController.text = DateFormat('d MMMM yyyy', 'id_ID').format(picked);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        title: _titleController.text,
        category: _selectedCategory,
        deadline: _selectedDate!,
      );
      TaskService.addTask(newTask).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tugas berhasil ditambahkan')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan tugas: $error')),
        );
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF333333),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color tealColor = Color(0xFF5993A2);
    const Color lightTextColor = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Simpan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Judul Tugas:'),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: lightTextColor, fontSize: 16),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: tealColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (value) => value!.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),

              _buildLabel('Kategori:'),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                icon: const Icon(Icons.keyboard_arrow_down, color: lightTextColor),
                style: const TextStyle(color: lightTextColor, fontSize: 16),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: tealColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                dropdownColor: tealColor,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 24),

              _buildLabel('Deadline:'),
              TextFormField(
                controller: _deadlineController,
                readOnly: true,
                onTap: () => _selectDate(context),
                style: const TextStyle(color: lightTextColor, fontSize: 16),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: tealColor,
                  suffixIcon: Icon(Icons.calendar_today, color: lightTextColor.withOpacity(0.8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (value) => value!.isEmpty ? 'Deadline tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),

              _buildLabel('Gambar Pendukung:'),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white54, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(Icons.camera_alt_outlined, size: 50, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
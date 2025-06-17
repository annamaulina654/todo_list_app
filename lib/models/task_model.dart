class Task {
  String? id;
  String title;
  String category;
  DateTime deadline;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.category,
    required this.deadline,
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      deadline: DateTime.parse(json['deadline']),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'deadline': deadline.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}
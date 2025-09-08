// ---------------------------- Task Model ----------------------------
class Task {
  final String name;
  final DateTime? deadline;
  final String? imagePath;
  bool isCompleted; // ✅ new field

  Task({
    required this.name,
    this.deadline,
    this.imagePath,
    this.isCompleted = false,
  });
}
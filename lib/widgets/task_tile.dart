import 'dart:io';
import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onToggleComplete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      color: Theme.of(context).cardColor, // adaptive card color
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: task.imagePath != null
            ? GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Scaffold(
                      backgroundColor: Colors.black,
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                      ),
                      body: Center(
                        child: InteractiveViewer(
                          child: Image.file(File(task.imagePath!)),
                        ),
                      ),
                    ),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(task.imagePath!),
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Icon(Icons.task, color: colorScheme.primary),
        title: Text(
          task.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: task.isCompleted
                ? colorScheme.outline
                : colorScheme.onSurface,
          ),
        ),
        subtitle: task.deadline != null
            ? Text(
                "Deadline: ${task.deadline!.toLocal()}",
                style: TextStyle(color: colorScheme.secondary),
              )
            : null,
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: colorScheme.primary),
              onPressed: onEdit,
            ),
            Checkbox(
              value: task.isCompleted,
              onChanged: (_) => onToggleComplete(),
              activeColor: colorScheme.secondary,
              checkColor: colorScheme.onSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

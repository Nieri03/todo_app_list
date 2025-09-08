import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/task.dart';

void showTaskDialog({
  required BuildContext context,
  required Function(Task) onSave,
  Task? task,
}) {
  final TextEditingController nameController =
      TextEditingController(text: task?.name ?? "");
  DateTime? selectedDate = task?.deadline;
  String? imagePath = task?.imagePath;

  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: theme.dialogBackgroundColor,
            title: Text(
              task == null ? "Add New Task" : "Edit Task",
              style: TextStyle(color: colorScheme.onBackground),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Task name
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Enter Task Name",
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Deadline picker
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDate == null
                              ? "No deadline"
                              : "Deadline: ${selectedDate!.toLocal()}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today,
                            color: colorScheme.primary),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  selectedDate ?? DateTime.now()),
                            );
                            if (pickedTime != null) {
                              setStateDialog(() {
                                selectedDate = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),

                  // Image picker
                  Row(
                    children: [
                      imagePath == null
                          ? Text("No image selected",
                              style: TextStyle(color: colorScheme.onSurface))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(imagePath!),
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.image, color: colorScheme.primary),
                        onPressed: () async {
                          final picker = ImagePicker();
                          final pickedFile =
                              await picker.pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setStateDialog(() => imagePath = pickedFile.path);
                          }
                        },
                      ),
                      if (imagePath != null)
                        IconButton(
                          icon: Icon(Icons.close, color: colorScheme.error),
                          tooltip: "Remove image",
                          onPressed: () {
                            setStateDialog(() => imagePath = null);
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: TextStyle(color: colorScheme.error)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    final newTask = Task(
                      name: nameController.text,
                      deadline: selectedDate,
                      imagePath: imagePath,
                      isCompleted: task?.isCompleted ?? false,
                    );
                    onSave(newTask);
                    Navigator.pop(context);
                  }
                },
                child: Text(task == null ? "Add" : "Save"),
              ),
            ],
          );
        },
      );
    },
  );
}

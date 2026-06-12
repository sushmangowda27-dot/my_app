import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAddAssignmentPage extends StatefulWidget {
  const AdminAddAssignmentPage({super.key});

  @override
  State<AdminAddAssignmentPage> createState() => _AdminAddAssignmentPageState();
}

class _AdminAddAssignmentPageState extends State<AdminAddAssignmentPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedCourse = "CSE";
  String selectedSemester = "1";

  Future<void> uploadAssignment() async {
    await FirebaseFirestore.instance.collection("assignments").add({
      "title": titleController.text.trim(),
      "description": descriptionController.text.trim(),
      "course": selectedCourse,
      "semester": selectedSemester,
      "createdAt": Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Assignment Added Successfully")),
    );

    titleController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Assignment (Admin)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Assignment Title"),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField(
              value: selectedCourse,
              items: ["CSE", "AIML", "DS", "CyberSecurity"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourse = value.toString();
                });
              },
              decoration: const InputDecoration(labelText: "Course"),
            ),
            DropdownButtonFormField(
              value: selectedSemester,
              items: ["1", "2", "3", "4", "5", "6", "7", "8"]
                  .map((e) => DropdownMenuItem(value: e, child: Text("Sem $e")))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedSemester = value.toString();
                });
              },
              decoration: const InputDecoration(labelText: "Semester"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadAssignment,
              child: const Text("Upload Assignment"),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProjectPage extends StatefulWidget {
  final String projectId;
  final Map<String, dynamic> projectData;

  const EditProjectPage({
    super.key,
    required this.projectId,
    required this.projectData,
  });

  @override
  State<EditProjectPage> createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController levelController;
  late TextEditingController linkController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.projectData['title']);

    descriptionController =
        TextEditingController(text: widget.projectData['description']);

    levelController = TextEditingController(text: widget.projectData['level']);

    linkController =
        TextEditingController(text: widget.projectData['codeLink']);
  }

  Future<void> updateProject() async {
    await FirebaseFirestore.instance
        .collection("projects")
        .doc(widget.projectId)
        .update({
      "title": titleController.text,
      "description": descriptionController.text,
      "level": levelController.text,
      "codeLink": linkController.text,
    });

    if (!mounted) return;

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Project updated"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Project"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: levelController,
              decoration: const InputDecoration(
                labelText: "Level",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: linkController,
              decoration: const InputDecoration(
                labelText: "GitHub Link",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateProject,
              child: const Text("Update Project"),
            )
          ],
        ),
      ),
    );
  }
}

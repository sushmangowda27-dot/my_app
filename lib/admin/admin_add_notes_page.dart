import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminAddNotesPage extends StatefulWidget {
  const AdminAddNotesPage({super.key});

  @override
  State<AdminAddNotesPage> createState() => _AdminAddNotesPageState();
}

class _AdminAddNotesPageState extends State<AdminAddNotesPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  String course = "CSE";
  String semester = "1";

  File? file;
  bool uploading = false;

  Future<void> pickPDF() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });
    }
  }

  Future<String> uploadFile(File file) async {
    final name = DateTime.now().millisecondsSinceEpoch.toString();

    final ref = FirebaseStorage.instance.ref().child("notes/$name.pdf");

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }

  Future<void> uploadNotes() async {
    if (file == null) return;

    setState(() => uploading = true);

    try {
      final url = await uploadFile(file!);

      await FirebaseFirestore.instance.collection("notes").add({
        "title": titleController.text,
        "description": descController.text,
        "course": course,
        "semester": semester,
        "pdfUrl": url,
        "createdAt": Timestamp.now(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notes uploaded successfully ✅")),
      );

      titleController.clear();
      descController.clear();

      setState(() {
        file = null;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => uploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Notes"),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField(
              value: course,
              items: const ["CSE", "AI/ML", "Cybersecurity", "Data Science"]
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => course = value!),
              decoration: const InputDecoration(
                labelText: "Course",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField(
              value: semester,
              items: List.generate(8, (i) => (i + 1).toString())
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text("Semester $e"),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => semester = value!),
              decoration: const InputDecoration(
                labelText: "Semester",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: pickPDF,
              icon: const Icon(Icons.upload_file),
              label: const Text("Pick PDF"),
            ),
            if (file != null) Text("Selected: ${file!.path.split('/').last}"),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: uploading ? null : uploadNotes,
                child: uploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Upload Notes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

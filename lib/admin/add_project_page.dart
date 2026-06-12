import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({super.key});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final codeLinkController = TextEditingController();

  String category = "AI/ML";
  String branch = "CSE";

  int semester = 1;

  bool pptPremium = false;
  bool reportPremium = false;

  bool isLoading = false;

  final List<String> categories = [
    "AI/ML",
    "Cybersecurity",
    "Data Science",
    "Web Development",
    "Mobile Apps",
    "IoT",
    "Cloud Computing",
    "Blockchain",
    "Embedded Systems",
    "Electronics",
    "Mechanical",
    "Civil Engineering",
  ];

  final List<String> branches = [
    "CSE",
    "ECE",
    "EEE",
    "MECH",
    "CIVIL",
  ];

  Future<void> addProject() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    if (titleController.text.trim().isEmpty ||
        descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields"),
        ),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await FirebaseFirestore.instance.collection("projects").add({
        "title": titleController.text.trim(),
        "description": descController.text.trim(),
        "codeLink": codeLinkController.text.trim(),

        // Project Info
        "category": category,
        "branch": branch,
        "semester": semester,

        // Premium Content
        "pptPremium": pptPremium,
        "reportPremium": reportPremium,

        // Search
        "searchKeywords": titleController.text.toLowerCase().split(" "),

        // Metadata
        "createdBy": user.uid,
        "createdAt": FieldValue.serverTimestamp(),
      });

      titleController.clear();
      descController.clear();
      codeLinkController.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Project Added Successfully ✅"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    codeLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Project"),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Project Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: codeLinkController,
              decoration: const InputDecoration(
                labelText: "GitHub / Code Link",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: category,
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
              items: categories.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: branch,
              decoration: const InputDecoration(
                labelText: "Branch",
                border: OutlineInputBorder(),
              ),
              items: branches.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  branch = value!;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: semester,
              decoration: const InputDecoration(
                labelText: "Semester",
                border: OutlineInputBorder(),
              ),
              items: List.generate(
                8,
                (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text("Semester ${index + 1}"),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  semester = value!;
                });
              },
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text("PPT Premium"),
              value: pptPremium,
              onChanged: (value) {
                setState(() {
                  pptPremium = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text("Report Premium"),
              value: reportPremium,
              onChanged: (value) {
                setState(() {
                  reportPremium = value;
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : addProject,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Add Project",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

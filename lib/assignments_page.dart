import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  int semester = 1;
  String searchText = "";
  String difficultyFilter = "All";

  final TextEditingController searchController = TextEditingController();

  void showAssignmentDetails(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(data["title"] ?? "Untitled"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _build("Question", data["question"]),
              _build("Language", data["language"]),
              _build("Tools", data["tools"]),
              _build("Difficulty", data["difficulty"]),
              _build("Instructions", data["instructions"]),
              _build("Reference Solution", data["referenceSolution"]),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _build(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value?.toString() ?? "-"),
        ],
      ),
    );
  }

  bool filterData(Map<String, dynamic> data) {
    final title = (data["title"] ?? "").toString().toLowerCase();
    final difficulty = (data["difficulty"] ?? "").toString();

    final matchesSearch = title.contains(searchText.toLowerCase());
    final matchesDifficulty =
        difficultyFilter == "All" || difficulty == difficultyFilter;

    return matchesSearch && matchesDifficulty;
  }

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance.collection("assignments");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Assignments"),
      ),
      body: Column(
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              onChanged: (val) {
                setState(() => searchText = val);
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search assignments...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // 🎯 DIFFICULTY FILTER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonFormField<String>(
              value: difficultyFilter,
              items: const [
                DropdownMenuItem(value: "All", child: Text("All")),
                DropdownMenuItem(value: "Easy", child: Text("Easy")),
                DropdownMenuItem(value: "Medium", child: Text("Medium")),
                DropdownMenuItem(value: "Hard", child: Text("Hard")),
              ],
              onChanged: (val) {
                setState(() => difficultyFilter = val!);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Filter by Difficulty",
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 📘 SEMESTER SELECTOR
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 8,
              itemBuilder: (context, i) {
                final sem = i + 1;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text("Sem $sem"),
                    selected: semester == sem,
                    onSelected: (_) {
                      setState(() => semester = sem);
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // 📄 DATA LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ref.where("semester", isEqualTo: semester).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No Assignments Found"));
                }

                final docs = snapshot.data!.docs;

                final filtered = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return filterData(data);
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text("No matching results"),
                  );
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final data = filtered[i].data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.assignment),
                        title: Text(data["title"] ?? ""),
                        subtitle:
                            Text("Difficulty: ${data["difficulty"] ?? "-"}"),
                        onTap: () => showAssignmentDetails(data),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

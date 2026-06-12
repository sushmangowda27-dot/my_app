import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  String searchText = "";
  String selectedBranch = "All";
  int selectedSemester = 0;

  Future<void> openLink(String url) async {
    if (url.isEmpty) return;

    final uri = Uri.parse(url);

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Projects"),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          // SEARCH
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Projects...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),

          // FILTERS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedBranch,
                    decoration: const InputDecoration(
                      labelText: "Branch",
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "All",
                        child: Text("All Branches"),
                      ),
                      DropdownMenuItem(
                        value: "CSE",
                        child: Text("CSE"),
                      ),
                      DropdownMenuItem(
                        value: "ECE",
                        child: Text("ECE"),
                      ),
                      DropdownMenuItem(
                        value: "EEE",
                        child: Text("EEE"),
                      ),
                      DropdownMenuItem(
                        value: "MECH",
                        child: Text("MECH"),
                      ),
                      DropdownMenuItem(
                        value: "CIVIL",
                        child: Text("CIVIL"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedBranch = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: selectedSemester,
                    decoration: const InputDecoration(
                      labelText: "Semester",
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: 0,
                        child: Text("All"),
                      ),
                      ...List.generate(
                        8,
                        (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text("Sem ${index + 1}"),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedSemester = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("projects")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final docs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  final title = (data["title"] ?? "").toString().toLowerCase();

                  final description =
                      (data["description"] ?? "").toString().toLowerCase();

                  final branch = (data["branch"] ?? "CSE").toString();

                  final semester = (data["semester"] ?? 0) as int;

                  final searchMatch = title.contains(searchText) ||
                      description.contains(searchText);

                  final branchMatch =
                      selectedBranch == "All" || branch == selectedBranch;

                  final semesterMatch =
                      selectedSemester == 0 || semester == selectedSemester;

                  return searchMatch && branchMatch && semesterMatch;
                }).toList();

                if (docs.isEmpty) {
                  return const Center(
                    child: Text("No Projects Found"),
                  );
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data["title"] ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data["description"] ?? "",
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              children: [
                                Chip(
                                  label: Text(
                                    data["branch"] ?? "CSE",
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    "Sem ${data["semester"] ?? 1}",
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    data["category"] ?? "",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (data["pptPremium"] == true)
                              const Chip(
                                label: Text("Premium PPT"),
                              ),
                            if (data["reportPremium"] == true)
                              const Chip(
                                label: Text("Premium Report"),
                              ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    openLink(
                                      data["codeLink"] ?? "",
                                    );
                                  },
                                  icon: const Icon(Icons.code),
                                  label: const Text("View Code"),
                                ),
                              ],
                            ),
                          ],
                        ),
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

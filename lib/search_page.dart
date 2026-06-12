import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText = "";

  final collections = [
    "projects",
    "notes",
    "assignments",
    "concepts",
    "placements",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: collections.map((collection) {
                return SearchCollectionWidget(
                  collection: collection,
                  searchText: searchText,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchCollectionWidget extends StatelessWidget {
  final String collection;
  final String searchText;

  const SearchCollectionWidget({
    super.key,
    required this.collection,
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collection).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final docs = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;

          final title = (data["title"] ?? "").toString().toLowerCase();

          return title.contains(searchText);
        }).toList();

        if (docs.isEmpty) {
          return const SizedBox();
        }

        return Card(
          margin: const EdgeInsets.all(10),
          child: ExpansionTile(
            title: Text(
              collection.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            children: docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(
                  data["title"] ?? "No Title",
                ),
                subtitle: Text(
                  data["category"] ?? data["branch"] ?? "",
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

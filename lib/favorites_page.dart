import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final userData = userSnapshot.data!.data() as Map<String, dynamic>;

          final favorites = List<String>.from(userData['favorites'] ?? []);

          if (favorites.isEmpty) {
            return const Center(
              child: Text("No favorites yet"),
            );
          }

          return StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("projects").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final docs = snapshot.data!.docs
                  .where(
                    (doc) => favorites.contains(doc.id),
                  )
                  .toList();

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (_, index) {
                  final data = docs[index].data() as Map<String, dynamic>;

                  return Card(
                    child: ListTile(
                      title: Text(data["title"] ?? ""),
                      subtitle: Text(
                        data["category"] ?? "",
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

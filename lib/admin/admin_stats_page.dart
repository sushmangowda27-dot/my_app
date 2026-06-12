import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminStatsPage extends StatelessWidget {
  const AdminStatsPage({super.key});

  Future<int> getCount(String status) async {
    final snap = await FirebaseFirestore.instance
        .collection("assignments")
        .where("status", isEqualTo: status)
        .get();

    return snap.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Stats"),
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder(
        future: Future.wait([
          getCount("pending"),
          getCount("completed"),
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final pending = snapshot.data![0];
          final completed = snapshot.data![1];

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Pending: $pending", style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Text("Completed: $completed",
                  style: const TextStyle(fontSize: 20)),
            ],
          );
        },
      ),
    );
  }
}

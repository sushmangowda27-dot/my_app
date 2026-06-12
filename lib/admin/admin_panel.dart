import 'package:flutter/material.dart';

import 'admin_add_notes_page.dart';
import 'add_project_page.dart';
import 'admin_stats_page.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  Widget adminCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Widget page,
    required Color color,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.9),
              color.withValues(alpha: 0.6),
            ],
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black26,
              offset: Offset(2, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel - Campus Core"),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        children: [
          adminCard(
            context: context,
            title: "Add Notes",
            icon: Icons.note_add,
            page: const AdminAddNotesPage(),
            color: Colors.blue,
          ),
          adminCard(
            context: context,
            title: "Add Projects",
            icon: Icons.create_new_folder,
            page: const AddProjectPage(),
            color: Colors.green,
          ),
          adminCard(
            context: context,
            title: "Stats Dashboard",
            icon: Icons.bar_chart,
            page: const AdminStatsPage(),
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_page.dart';
import 'projects_page.dart';
import 'notes_page.dart';
import 'favorites_page.dart';
import 'search_page.dart';
import 'admin/admin_panel.dart';

import 'pages/student_assignments_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/profile_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;
  bool isAdmin = false;
  bool loading = true;

  late List<Widget> pages;
  late List<BottomNavigationBarItem> items;

  @override
  void initState() {
    super.initState();
    initUser();
  }

  Future<void> initUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      isAdmin = doc.data()?["role"] == "admin";
    }

    pages = [
      const HomePage(),
      const ProjectsPage(),
      const NotesPage(),
      const StudentAssignmentsPage(),
      const DashboardPage(),
      const ProfilePage(),
      const SearchPage(),
      const FavoritesPage(),
      if (isAdmin) const AdminPanel(),
    ];

    items = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      const BottomNavigationBarItem(icon: Icon(Icons.work), label: "Projects"),
      const BottomNavigationBarItem(icon: Icon(Icons.note), label: "Notes"),
      const BottomNavigationBarItem(
          icon: Icon(Icons.assignment), label: "Tasks"),
      const BottomNavigationBarItem(
          icon: Icon(Icons.dashboard), label: "Dashboard"),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      const BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
      const BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Fav"),
      if (isAdmin)
        const BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings),
          label: "Admin",
        ),
    ];

    if (!mounted) return;

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => index = i),
        items: items,
      ),
    );
  }
}

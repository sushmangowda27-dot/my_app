import 'package:cloud_firestore/cloud_firestore.dart';

class SeedProjects {
  static Future<void> uploadAllProjects() async {
    final firestore = FirebaseFirestore.instance;

    final departments = ["CSE", "ECE", "ME", "CIVIL"];
    final levels = ["Beginner", "Intermediate", "Advanced"];

    int totalCount = 0;

    for (String dept in departments) {
      for (int i = 1; i <= 100; i++) {
        final level = levels[i % levels.length];

        final project = {
          "title": "$dept Project $i - ${_getProjectName(i)}",
          "description":
              "This is a $level level $dept project designed for students to learn real-world development concepts.",
          "department": dept,
          "level": level,
          "codeLink": "https://github.com/example/$dept-project-$i",
          "imageUrl": "",
          "createdAt": FieldValue.serverTimestamp(),
        };

        await firestore.collection("projects").add(project);

        totalCount++;
        // ignore: avoid_print
        print("Uploaded: ${project['title']}");
      }
    }

    // ignore: avoid_print
    print("DONE ✅ Total Projects Uploaded: $totalCount");
  }

  static String _getProjectName(int i) {
    List<String> names = [
      "AI Chatbot",
      "Weather App",
      "E-commerce Platform",
      "Library System",
      "Attendance System",
      "Chat Application",
      "Expense Tracker",
      "Food Delivery App",
      "Smart Home Controller",
      "Online Learning Platform",
      "Portfolio Website",
      "Hospital Management System",
      "Bus Tracking App",
      "Event Management System",
      "Quiz App",
    ];

    return names[i % names.length];
  }
}

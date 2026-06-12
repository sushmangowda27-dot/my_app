import 'package:flutter/material.dart';

class CseCategoryPage extends StatelessWidget {
  const CseCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {"name": "AI & Machine Learning", "icon": Icons.smart_toy},
      {"name": "Web Development", "icon": Icons.web},
      {"name": "Mobile App Development", "icon": Icons.phone_android},
      {"name": "Cyber Security", "icon": Icons.security},
      {"name": "Cloud Computing", "icon": Icons.cloud},
      {"name": "IoT", "icon": Icons.router},
      {"name": "Robotics", "icon": Icons.precision_manufacturing},
      {"name": "Agriculture Technology", "icon": Icons.agriculture},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("CSE Categories"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];

            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "${category["name"]} projects coming soon",
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category["icon"] as IconData,
                      size: 45,
                      color: Colors.indigo,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        category["name"] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

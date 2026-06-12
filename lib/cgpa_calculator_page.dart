import 'package:flutter/material.dart';

class CGPACalculatorPage extends StatefulWidget {
  const CGPACalculatorPage({super.key});

  @override
  State<CGPACalculatorPage> createState() => _CGPACalculatorPageState();
}

class _CGPACalculatorPageState extends State<CGPACalculatorPage> {
  List<TextEditingController> gradeControllers = [];
  List<TextEditingController> creditControllers = [];

  double result = 0;

  void addSubject() {
    setState(() {
      gradeControllers.add(TextEditingController());
      creditControllers.add(TextEditingController());
    });
  }

  double convertGrade(String grade) {
    switch (grade.toUpperCase()) {
      case "S":
        return 10;
      case "A":
        return 9;
      case "B":
        return 8;
      case "C":
        return 7;
      case "D":
        return 6;
      case "E":
        return 5;
      default:
        return 0;
    }
  }

  void calculateCGPA() {
    double totalPoints = 0;
    double totalCredits = 0;

    for (int i = 0; i < gradeControllers.length; i++) {
      double gradePoint = convertGrade(gradeControllers[i].text);
      double credit = double.tryParse(creditControllers[i].text) ?? 0;

      totalPoints += gradePoint * credit;
      totalCredits += credit;
    }

    setState(() {
      result = totalCredits == 0 ? 0 : totalPoints / totalCredits;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CGPA Calculator"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: addSubject,
              child: const Text("Add Subject"),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: gradeControllers.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: gradeControllers[index],
                              decoration: const InputDecoration(
                                labelText: "Grade (A, B, C...)",
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: creditControllers[index],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Credits",
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
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: calculateCGPA,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
              ),
              child: const Text("Calculate CGPA"),
            ),
            const SizedBox(height: 20),
            Text(
              "Your CGPA: ${result.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

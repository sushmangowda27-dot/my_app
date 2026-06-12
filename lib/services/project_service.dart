import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/ai_duplicate_service.dart';

Future<void> uploadProject({
  required String title,
  required String description,
  required String category,
  required int semester,
  required String github,
}) async {
  try {
    // =========================
    // 1. AI DUPLICATE CHECK (SAFE)
    // =========================
    bool isDuplicate = await AIDuplicateService.isDuplicate(title);

    // extra safety check (GitHub exact match inside AI service is better)
    if (isDuplicate) {
      throw Exception("Duplicate project detected ❌");
    }

    // =========================
    // 2. CREATE EMBEDDING (SAFE)
    // =========================
    List<double> embedding = await AIDuplicateService.createEmbedding(title);

    // =========================
    // 3. SAVE TO FIREBASE
    // =========================
    await FirebaseFirestore.instance.collection("projects").add({
      "title": title.trim(),
      "description": description.trim(),
      "category": category,
      "semester": semester,
      "github": github.trim(),
      "embedding": embedding,
      "createdAt": FieldValue.serverTimestamp(),
    });
  } catch (e) {
    // =========================
    // 4. FAIL-SAFE HANDLING
    // =========================

    // If AI fails → still allow upload (optional but recommended)
    // You can REMOVE this if you want strict blocking

    if (e.toString().contains("Duplicate")) {
      rethrow;
    }

    // fallback upload without AI embedding
    await FirebaseFirestore.instance.collection("projects").add({
      "title": title.trim(),
      "description": description.trim(),
      "category": category,
      "semester": semester,
      "github": github.trim(),
      "embedding": null,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}

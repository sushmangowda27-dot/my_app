import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class AIDuplicateService {
  // 🔑 PUT YOUR HUGGINGFACE KEY HERE
  static const String apiKey = "YOUR_HUGGINGFACE_API_KEY";

  // =========================
  // 1. GET EMBEDDING
  // =========================
  static Future<List<double>> getEmbedding(String text) async {
    final response = await http.post(
      Uri.parse(
        "https://api-inference.huggingface.co/pipeline/feature-extraction/"
        "sentence-transformers/all-MiniLM-L6-v2",
      ),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"inputs": text}),
    );

    final data = jsonDecode(response.body);

    return List<double>.from(data[0]);
  }

  // =========================
  // 2. COSINE SIMILARITY
  // =========================
  static double cosineSimilarity(List<double> a, List<double> b) {
    double dot = 0;
    double magA = 0;
    double magB = 0;

    for (int i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      magA += a[i] * a[i];
      magB += b[i] * b[i];
    }

    return dot / (sqrt(magA) * sqrt(magB));
  }

  // =========================
  // 3. CHECK DUPLICATE
  // =========================
  static Future<bool> isDuplicate(String title) async {
    try {
      final newEmbedding = await getEmbedding(title);

      final snapshot =
          await FirebaseFirestore.instance.collection("projects").get();

      for (var doc in snapshot.docs) {
        final data = doc.data();

        if (data["embedding"] == null) continue;

        List<double> existing = List<double>.from(data["embedding"]);

        double score = cosineSimilarity(newEmbedding, existing);

        // 🔥 AI threshold
        if (score > 0.88) {
          return true;
        }
      }

      return false;
    } catch (e) {
      // If AI fails → allow upload (safe fallback)
      return false;
    }
  }

  // =========================
  // 4. CREATE EMBEDDING FOR STORAGE
  // =========================
  static Future<List<double>> createEmbedding(String text) async {
    return await getEmbedding(text);
  }
}

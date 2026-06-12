import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  static Future<void> toggleFavorite(String itemId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    final doc = await userRef.get();

    List favorites = List.from(doc.data()?['favorites'] ?? []);

    if (favorites.contains(itemId)) {
      favorites.remove(itemId);
    } else {
      favorites.add(itemId);
    }

    await userRef.update({
      'favorites': favorites,
    });
  }

  static Future<bool> isFavorite(String itemId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    List favorites = List.from(doc.data()?['favorites'] ?? []);

    return favorites.contains(itemId);
  }
}

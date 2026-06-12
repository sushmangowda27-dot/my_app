import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotesService {
  // ==========================
  // PICK PDF (WEB + MOBILE)
  // ==========================
  static Future<PlatformFile?> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null) {
      return result.files.first;
    }

    return null;
  }

  // ==========================
  // UPLOAD PDF TO FIREBASE STORAGE
  // ==========================
  static Future<String> uploadPdf({
    required PlatformFile file,
    required String branch,
    required int semester,
  }) async {
    if (file.bytes == null) {
      throw Exception("Unable to read PDF file");
    }

    final storageRef = FirebaseStorage.instance.ref().child(
          "notes/$branch/semester_$semester/${file.name}",
        );

    UploadTask uploadTask = storageRef.putData(
      file.bytes!,
      SettableMetadata(
        contentType: "application/pdf",
      ),
    );

    TaskSnapshot snapshot = await uploadTask;

    return await snapshot.ref.getDownloadURL();
  }

  // ==========================
  // SAVE NOTE TO FIRESTORE
  // ==========================
  static Future<void> saveNote({
    required String title,
    required String category,
    required String branch,
    required int semester,
    required String pdfUrl,
  }) async {
    await FirebaseFirestore.instance.collection("notes").add({
      "title": title.trim(),
      "category": category,
      "branch": branch,
      "semester": semester,
      "pdfUrl": pdfUrl,
      "uploadedAt": FieldValue.serverTimestamp(),
    });
  }

  // ==========================
  // DELETE NOTE
  // ==========================
  static Future<void> deleteNote(String docId) async {
    await FirebaseFirestore.instance.collection("notes").doc(docId).delete();
  }

  // ==========================
  // GET NOTES STREAM
  // ==========================
  static Stream<QuerySnapshot> getNotes() {
    return FirebaseFirestore.instance
        .collection("notes")
        .orderBy(
          "uploadedAt",
          descending: true,
        )
        .snapshots();
  }
}

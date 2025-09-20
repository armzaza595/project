import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference animes = FirebaseFirestore.instance.collection(
    'animes',
  );

  // Create
  Future<void> addAnime({
    required String animeName,
    required int animeChapter,
    required int animeSeason,
    required double animeScore, // score 0.00 - 5.00
    required String animeImageUrl, // URL รูป
  }) {
    // ตรวจสอบคะแนนให้อยู่ระหว่าง 0-5 และมีทศนิยม 2 ตำแหน่ง
    double validScore = double.parse(animeScore.clamp(0, 5).toStringAsFixed(2));

    return animes.add({
      'animeName': animeName,
      'animeChapter': animeChapter,
      'animeSeason': animeSeason,
      'animeScore': validScore,
      'animeImageUrl': animeImageUrl,
      'timeStamp': Timestamp.now(),
    });
  }

  // Read
  Stream<QuerySnapshot> getAnimes() {
    return animes.orderBy('timeStamp', descending: true).snapshots();
  }

  // Get by id
  Future<Map<String, dynamic>> getAnimeById(String animeId) async {
    final doc = await animes.doc(animeId).get();
    return (doc.data() as Map<String, dynamic>?) ?? {};
  }

  // Update
  Future<void> updateAnime({
    required String animeID,
    required String animeName,
    required int animeChapter,
    required int animeSeason,
    required double animeScore,
    required String animeImageUrl,
  }) {
    double validScore = double.parse(animeScore.clamp(0, 5).toStringAsFixed(2));

    return animes.doc(animeID).update({
      'animeName': animeName,
      'animeChapter': animeChapter,
      'animeSeason': animeSeason,
      'animeScore': validScore,
      'animeImageUrl': animeImageUrl,
      'timeStamp': Timestamp.now(),
    });
  }

  // Delete
  Future<void> deleteAnime(String animeId) {
    return animes.doc(animeId).delete();
  }
}

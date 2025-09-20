import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FirstScreen(),
    );
  }
}

// ================= Firestore Service =================
class FirestoreService {
  final CollectionReference animeCollection = FirebaseFirestore.instance
      .collection('animes');

  Future<void> addAnime({
    required String animeName,
    required int animeChapter,
    required int animeSeason,
    required double animeScore,
    required String animeImageUrl,
  }) async {
    await animeCollection.add({
      'animeName': animeName,
      'animeChapter': animeChapter,
      'animeSeason': animeSeason,
      'animeScore': animeScore,
      'animeImageUrl': animeImageUrl,
    });
  }

  Future<void> updateAnime({
    required String animeID,
    required String animeName,
    required int animeChapter,
    required int animeSeason,
    required double animeScore,
    required String animeImageUrl,
  }) async {
    await animeCollection.doc(animeID).update({
      'animeName': animeName,
      'animeChapter': animeChapter,
      'animeSeason': animeSeason,
      'animeScore': animeScore,
      'animeImageUrl': animeImageUrl,
    });
  }

  Future<void> deleteAnime(String animeID) async {
    await animeCollection.doc(animeID).delete();
  }

  Stream<QuerySnapshot> getAnimes() {
    return animeCollection.snapshots();
  }

  Future<Map<String, dynamic>> getAnimeById(String animeID) async {
    DocumentSnapshot doc = await animeCollection.doc(animeID).get();
    return doc.data() as Map<String, dynamic>;
  }
}

// ================= First Screen =================
class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  void checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      _showAlertDialog(
        context,
        "No Internet",
        "Please check your internet connection.",
      );
    } else {
      _showToast(context, "Connected!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                SpinKitPulse(color: Colors.pinkAccent, size: 80.0),
                const SizedBox(height: 25),
                Text(
                  "Loading Your Anime App...",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        blurRadius: 12,
                        color: Colors.pinkAccent.withOpacity(0.8),
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================= Toast & Alert =================
void _showToast(BuildContext context, String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black87,
    textColor: Colors.pinkAccent,
    fontSize: 16.0,
  );

  Timer(
    const Duration(seconds: 2),
    () => Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const SecondScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
  );
}

void _showAlertDialog(BuildContext context, String title, String msg) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.deepPurple.shade800.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.pinkAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(msg, style: const TextStyle(color: Colors.white70)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

// ================= Second Screen =================
class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController chapterController = TextEditingController();
  final TextEditingController seasonController = TextEditingController();
  final TextEditingController scoreController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  // ================= Add/Edit/Delete Dialog =================
  void openAnimeBox(String? animeID) async {
    if (animeID != null) {
      final anime = await firestoreService.getAnimeById(animeID);
      nameController.text = anime['animeName'] ?? '';
      chapterController.text = anime['animeChapter']?.toString() ?? '';
      seasonController.text = anime['animeSeason']?.toString() ?? '';
      scoreController.text = anime['animeScore']?.toString() ?? '';
      imageUrlController.text = anime['animeImageUrl'] ?? '';
    } else {
      nameController.clear();
      chapterController.clear();
      seasonController.clear();
      scoreController.clear();
      imageUrlController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade900.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.pinkAccent.withOpacity(0.5)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField("Anime Name", nameController),
                    const SizedBox(height: 10),
                    _buildTextField(
                      "Chapter",
                      chapterController,
                      isNumber: true,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField("Season", seasonController, isNumber: true),
                    const SizedBox(height: 10),
                    _buildTextField(
                      "Score (0.00-5.00)",
                      scoreController,
                      isNumber: true,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField("Image URL", imageUrlController),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),

                        if (animeID != null)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                            onPressed: () async {
                              bool confirm = await showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Confirm Delete"),
                                  content: const Text(
                                    "Are you sure you want to delete this anime?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("No"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text("Yes"),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm) {
                                await firestoreService.deleteAnime(animeID);
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                  msg: "Anime deleted",
                                  backgroundColor: Colors.black87,
                                  textColor: Colors.pinkAccent,
                                );
                              }
                            },
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                          ),
                          onPressed: () async {
                            if (nameController.text.isEmpty ||
                                chapterController.text.isEmpty ||
                                seasonController.text.isEmpty ||
                                scoreController.text.isEmpty ||
                                imageUrlController.text.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Please fill all fields",
                                backgroundColor: Colors.black87,
                                textColor: Colors.pinkAccent,
                              );
                              return;
                            }

                            double? score = double.tryParse(
                              scoreController.text,
                            );
                            if (score == null || score < 0 || score > 5) {
                              Fluttertoast.showToast(
                                msg: "Score must be 0-5",
                                backgroundColor: Colors.black87,
                                textColor: Colors.pinkAccent,
                              );
                              return;
                            }

                            final String name = nameController.text;
                            final int chapter =
                                int.tryParse(chapterController.text) ?? 0;
                            final int season =
                                int.tryParse(seasonController.text) ?? 0;
                            final String imageUrl = imageUrlController.text;

                            if (!imageUrl.startsWith("http")) {
                              Fluttertoast.showToast(
                                msg: "Image URL must start with http",
                                backgroundColor: Colors.black87,
                                textColor: Colors.pinkAccent,
                              );
                              return;
                            }

                            if (animeID != null) {
                              await firestoreService.updateAnime(
                                animeID: animeID,
                                animeName: name,
                                animeChapter: chapter,
                                animeSeason: season,
                                animeScore: score,
                                animeImageUrl: imageUrl,
                              );
                            } else {
                              await firestoreService.addAnime(
                                animeName: name,
                                animeChapter: chapter,
                                animeSeason: season,
                                animeScore: score,
                                animeImageUrl: imageUrl,
                              );
                            }

                            Navigator.pop(context);
                            Fluttertoast.showToast(
                              msg: "Saved Successfully!",
                              backgroundColor: Colors.black87,
                              textColor: Colors.pinkAccent,
                            );
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextField _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.pinkAccent),
        filled: true,
        fillColor: Colors.deepPurple.shade800.withOpacity(0.5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "🌸 Anime List",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 12,
                color: Colors.pinkAccent,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pinkAccent.shade200,
        onPressed: () => openAnimeBox(null),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Anime", style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getAnimes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final animeList = snapshot.data!.docs;
            if (animeList.isEmpty) {
              return const Center(
                child: Text(
                  "No Anime Added",
                  style: TextStyle(fontSize: 20, color: Colors.pinkAccent),
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: animeList.length,
              itemBuilder: (context, index) {
                final anime = animeList[index];
                final animeData = anime.data() as Map<String, dynamic>;

                return GestureDetector(
                  onTap: () => openAnimeBox(anime.id),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(22),
                            ),
                            child: Image.network(
                              animeData['animeImageUrl'],
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(22),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                animeData['animeName'] ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "S${animeData['animeSeason']} | Ep ${animeData['animeChapter']}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    animeData['animeScore'].toString(),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.pinkAccent),
            );
          }
        },
      ),
    );
  }
}

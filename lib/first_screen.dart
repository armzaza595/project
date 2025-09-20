import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/services/filestore.dart';

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

    if (connectivityResult.contains(ConnectivityResult.none)) {
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
            colors: [Color(0xFF1D1E33), Color(0xFF2C3E50)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: "logo",
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      './android/assets/image/loadingScreen.jpeg',
                      width: 220,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SpinKitWave(
                  color: Colors.pinkAccent.shade200,
                  size: 60.0,
                ),
                const SizedBox(height: 25),
                Text(
                  "Loading Your Anime App...",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.pinkAccent.shade100,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
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
        backgroundColor: Colors.blueGrey.shade900,
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
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

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

  // ✅ ฟังก์ชันเพิ่ม/แก้ไข Anime
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
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.pinkAccent.withOpacity(0.5)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField("Anime Name", nameController),
                    const SizedBox(height: 10),
                    _buildTextField("Chapter", chapterController, isNumber: true),
                    const SizedBox(height: 10),
                    _buildTextField("Season", seasonController, isNumber: true),
                    const SizedBox(height: 10),
                    _buildTextField("Score (0.00-5.00)", scoreController, isNumber: true),
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                          ),
                          onPressed: () {
                            if (nameController.text.isEmpty ||
                                chapterController.text.isEmpty ||
                                seasonController.text.isEmpty ||
                                scoreController.text.isEmpty ||
                                imageUrlController.text.isEmpty) {
                              _showToast(context, "Please fill all fields!");
                              return;
                            }

                            double? score = double.tryParse(scoreController.text);
                            if (score == null || score < 0 || score > 5) {
                              _showToast(context, "Score must be between 0-5");
                              return;
                            }

                            final String name = nameController.text;
                            final int chapter = int.tryParse(chapterController.text) ?? 0;
                            final int season = int.tryParse(seasonController.text) ?? 0;
                            final String imageUrl = imageUrlController.text;

                            if (!imageUrl.startsWith("http")) {
                              _showToast(context, "Image URL must start with http");
                              return;
                            }

                            if (animeID != null) {
                              firestoreService.updateAnime(
                                animeID: animeID,
                                animeName: name,
                                animeChapter: chapter,
                                animeSeason: season,
                                animeScore: score,
                                animeImageUrl: imageUrl,
                              );
                            } else {
                              firestoreService.addAnime(
                                animeName: name,
                                animeChapter: chapter,
                                animeSeason: season,
                                animeScore: score,
                                animeImageUrl: imageUrl,
                              );
                            }
                            Navigator.pop(context);
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    )
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
        fillColor: Colors.blueGrey.shade800.withOpacity(0.4),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1E33),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "🌸 Anime List",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pinkAccent,
        onPressed: () => openAnimeBox(null),
        icon: const Icon(Icons.add),
        label: const Text("Add Anime"),
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
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
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
                        colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Hero(
                            tag: anime.id,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              child: Image.network(
                                animeData['animeImageUrl'],
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                animeData['animeName'] ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "S${animeData['animeSeason']} | Ep ${animeData['animeChapter']}",
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    animeData['animeScore'].toString(),
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              )
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

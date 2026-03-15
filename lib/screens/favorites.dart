import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:prueba_tecnica/screens/details.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<int> favoriteIds = [];
  List<dynamic> favoritePosts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favorites') ?? [];

    favoriteIds = favs.map((e) => int.parse(e)).toList();

    fetchFavoritePosts();
  }

  Future<void> fetchFavoritePosts() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );

    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(json.decode(response.body));

      setState(() {
        favoritePosts = data
            .where((post) => favoriteIds.contains(post['id']))
            .toList();

        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoritePosts.isEmpty
          ? const Center(child: Text("No tienes noticias favoritas"))
          : ListView.builder(
              itemCount: favoritePosts.length,
              itemBuilder: (context, index) {
                final post = favoritePosts[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.red),

                    title: Text(
                      post['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(
                            id: post['id'],
                            title: post['title'],
                            body: post['body'],
                            isFavorite: true,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

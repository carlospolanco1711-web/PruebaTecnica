import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_tecnica/screens/details.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Challenge',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const NewsListScreen(),
    );
  }
}

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  late String apiSecret = '';
  Set<int> favoritos = {};
  List<dynamic> posts = [];
  List<dynamic> filteredposts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
<<<<<<< HEAD
    _loadFavorites();
=======
    filteredposts = posts;
  }

  void _filteredPosts (String query){
    final result = posts.where((post){
    final title = post['title'].toString().toLowerCase();
    final result = query;
    return result.contains(title);
    }).toList();

>>>>>>> 3a3c7d3438662438931a0b956ab78180528b5c00
  }

  Future<void> _fetchPosts() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {'Accept': 'application/json', 'User-Agent': 'Mozilla'},
      );

      if (response.statusCode == 200) {
        final data = List<Map<String, dynamic>>.from(
          json.decode(response.body),
        );
        setState(() {
          posts = data;
          filteredposts = data;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error al cargar datos: $e');
      setState(() => isLoading = false);
    }
  }

  void _filteredPosts(String query) {
    final results = posts.where((post) {
      final title = post['title'].toString().toLowerCase();
      final body = post['body'].toString().toLowerCase();
      final search = query.toLowerCase();
      return title.contains(search) || body.contains(search);
    }).toList();

    setState(() {
      filteredposts = results;
    });
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favList = prefs.getStringList('favorites') ?? [];

    setState(() {
      favoritos = favList.map((e) => int.parse(e)).toSet();
    });
  }

  Future<void> _toggleFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      if (favoritos.contains(id)) {
        favoritos.remove(id);
      } else {
        favoritos.add(id);
      }
    });

    prefs.setStringList(
      'favorites',
      favoritos.map((e) => e.toString()).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News Feed $apiSecret')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar noticia...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
<<<<<<< HEAD
              onChanged: (value) {
                _filteredPosts(value);
=======
              onChanged: (void value) {
                _filteredPosts;
>>>>>>> 3a3c7d3438662438931a0b956ab78180528b5c00
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredposts.length,
                    itemBuilder: (context, index) {
                      final post = filteredposts[index];
<<<<<<< HEAD
                      return _buildNewsItem(
                        post['id'],
                        post['title'],
                        post['body'],
                      );
=======
                      return _buildNewsItem(post['title'], post['body']);
>>>>>>> 3a3c7d3438662438931a0b956ab78180528b5c00
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(int id, String title, String body) {
    final isFavorite = favoritos.contains(id);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
              id: id,
              title: title,
              body: body,
              isFavorite: favoritos.contains(id),
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              const Icon(Icons.article, size: 40, color: Colors.blue),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  _toggleFavorite(id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_tecnica/screens/details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keahak News Challenge',
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

  List<dynamic> posts = [];
  List<dynamic> filteredposts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    filteredposts = posts;
  }

  void _filteredPosts (String query){
    final result = posts.where((post){
    final title = post['title'].toString().toLowerCase();
    final result = query;
    return result.contains(title);
    }).toList();

  }

  Future<void> _fetchPosts() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {'Accept': 'application/json', 'User-Agent': 'Mozilla'},
      );


      if (response.statusCode == 200) {
          final  data = List<Map<String, dynamic>>.from(json.decode(response.body));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News Feed - Key: $apiSecret')),
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
              onChanged: (void value) {
                _filteredPosts;
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
                      return _buildNewsItem(post['title'], post['body']);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(String title, String body) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(title: title, body: body),
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
            ],
          ),
        ),
      ),
    );
  }
}

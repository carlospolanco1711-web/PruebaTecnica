import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
<<<<<<< HEAD
import 'package:shared_preferences/shared_preferences.dart';
=======
>>>>>>> 3a3c7d3438662438931a0b956ab78180528b5c00

class DetailsPage extends StatefulWidget {
  final int id;
  final String title;
  final String body;
  final bool isFavorite;

  const DetailsPage({
    super.key,
    required this.id,
    required this.title,
    required this.body,
    required this.isFavorite,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  Future<void> toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    setState(() {
      if (isFavorite) {
        favorites.remove(widget.id.toString());
        isFavorite = false;
      } else {
        favorites.add(widget.id.toString());
        isFavorite = true;
      }
    });

    await prefs.setStringList('favorites', favorites);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
<<<<<<< HEAD
            Html(data: "<p>${widget.body}</p>"),
=======
            Html(data: """ <p><i> $body </i></p> """),
>>>>>>> 3a3c7d3438662438931a0b956ab78180528b5c00
          ],
        ),
      ),
    );
  }
}

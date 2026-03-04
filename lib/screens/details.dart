import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final String title;
  final String body;

  const DetailsPage({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagina de detalles')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(body, style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}

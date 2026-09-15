import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final String id;

  const DetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details Page')),
      body: const Center(child: Text('This is the details page.')),
    );
  }
}

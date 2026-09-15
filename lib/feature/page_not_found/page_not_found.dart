import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound(String string, {super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            const Text(
              '404 - Page Not Found',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'The page "$url" does not exist.',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/screen_paths.dart';
import '../../../../core/widget/controls/app_header.dart';

class DetailsPage extends StatelessWidget {
  final String id;

  const DetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            title: 'Details',
            subtitle: id,
            // Deep-linked straight here? There's nothing to pop, so go home.
            onBack: () => context.canPop() ? context.pop() : context.go(ScreenPaths.home),
          ),
          const Expanded(child: Center(child: Text('This is the details page.'))),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SavingIndicator extends StatelessWidget {
  const SavingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Salvando despesa...'),
        ],
      ),
    );
  }
}

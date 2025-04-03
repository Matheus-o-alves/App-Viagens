import 'package:flutter/material.dart';

class SavingIndicator extends StatelessWidget {
  const SavingIndicator({Key? key}) : super(key: key);

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

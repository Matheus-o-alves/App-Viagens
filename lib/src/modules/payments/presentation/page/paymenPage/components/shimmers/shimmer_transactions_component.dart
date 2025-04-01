import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TransactionDetailCardShimmer extends StatelessWidget {
  const TransactionDetailCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey[300]!;
    final highlightColor = Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildShimmerRow(),
            const SizedBox(height: 12),
            _buildShimmerRow(),
            const SizedBox(height: 12),
            _buildShimmerRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Coluna da esquerda
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Simula o título (label)
              Container(
                height: 16,
                width: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 4),
              // Simula o valor
              Container(
                height: 20,
                width: double.infinity,
                color: Colors.white,
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // Coluna da direita
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 16,
                width: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 4),
              Container(
                height: 20,
                width: double.infinity,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

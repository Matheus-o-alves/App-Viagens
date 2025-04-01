import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerScheduleComponent extends StatelessWidget {
  const ShimmerScheduleComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 640 ? 16 : 12,
        vertical: MediaQuery.of(context).size.width > 640 ? 20 : 16,
      ),
      child: Column(
        children: List.generate(3, (index) => _buildShimmerItem(index == 0)), // 3 placeholders
      ),
    );
  }

  Widget _buildShimmerItem(bool showNextBadge) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            if (showNextBadge)
              Positioned(
                right: 30,
                top: 0,
                child: Container(
                  width: 48,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

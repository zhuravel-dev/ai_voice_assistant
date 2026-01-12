import 'package:flutter/material.dart';

class CenterEmptyContent extends StatelessWidget {
  const CenterEmptyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, color: Colors.white.withValues(alpha: 0.35), size: 52),
            const SizedBox(height: 14),
            Text(
              'Let`s start!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 16,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

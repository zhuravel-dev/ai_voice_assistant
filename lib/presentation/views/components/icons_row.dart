import 'package:flutter/material.dart';
import 'custom_icon_button.dart';

class IconsRow extends StatelessWidget {
  const IconsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomIconButton(icon: Icons.menu),
          Row(
            children: [
              CustomIconButton(icon: Icons.person_add_alt_1),
              SizedBox(width: 8),
              CustomIconButton(icon: Icons.chat_bubble_outline),
            ],
          ),
        ],
      ),
    );
  }
}

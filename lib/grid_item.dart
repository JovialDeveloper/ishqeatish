import 'package:flutter/material.dart';

class GridItem {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap; // Add onTap as a parameter

  GridItem({
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
  });
}

import 'package:flutter/material.dart';

class MasteryIndicator extends StatelessWidget {
  final double masteryLevel;

  const MasteryIndicator({super.key, required this.masteryLevel});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: masteryLevel,
      backgroundColor: Colors.grey[200],
      color: _getMasteryColor(masteryLevel),
      minHeight: 8,
      borderRadius: BorderRadius.circular(4),
    );
  }

  Color _getMasteryColor(double level) {
    if (level >= 0.8) return Colors.green;
    if (level >= 0.5) return Colors.orange;
    return Colors.red;
  }
}
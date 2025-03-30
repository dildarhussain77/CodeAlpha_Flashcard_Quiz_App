import 'package:flutter/material.dart';

class QuizProgressIndicator extends StatelessWidget {
  final int current;
  final int total;

  const QuizProgressIndicator({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$current',style: TextStyle(color: Colors.white),),
        const Text(' / ',style: TextStyle(color: Colors.white)),
        Text('$total',style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
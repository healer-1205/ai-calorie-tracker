import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MacroIndicator extends StatelessWidget {
  final String label;
  final double value;
  final double goal;
  final Color color;

  const MacroIndicator({
    Key? key,
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        LinearPercentIndicator(
          width: 80,
          lineHeight: 8,
          percent: (value / goal).clamp(0.0, 1.0),
          backgroundColor: Colors.grey[200],
          progressColor: color,
          padding: EdgeInsets.zero,
          barRadius: Radius.circular(4),
        ),
        SizedBox(height: 4),
        Text(
          '${value.toInt()}/${goal.toInt()}g',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import '../../data/models/food_item.dart';

class MealListItem extends StatelessWidget {
  final FoodItem meal;
  final String timeAgo;

  const MealListItem({
    Key? key,
    required this.meal,
    required this.timeAgo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        title: Text(meal.name),
        subtitle: Text('$timeAgo\n${meal.calories.toStringAsFixed(1)} kcal'),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
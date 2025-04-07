import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/food_item.dart';
import '../screens/meal_detail_screen.dart';
import '../cubit/food_log_cubit.dart';
import 'meal_list_item.dart';
import 'package:timeago/timeago.dart' as timeago;
class MealList extends StatelessWidget {
  final List<FoodItem> meals;

  const MealList({
    required this.meals,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedMeals = List.of(meals)..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: sortedMeals.length,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        final meal = sortedMeals[index];
        return GestureDetector(
          onLongPress: () => _showDeleteDialog(context, meal),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MealDetailScreen(meal: meal),
              ),
            );
          },
          child: MealListItem(
            meal: meal,
            timeAgo: timeago.format(meal.timestamp),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, FoodItem meal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Meal'),
        content: Text('Are you sure you want to delete this meal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<FoodLogCubit>().deleteMeal(meal);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
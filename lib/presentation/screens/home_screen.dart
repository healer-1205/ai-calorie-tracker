import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import '../cubit/food_log_cubit.dart';
import '../widgets/daily_tracker.dart';
import '../widgets/meal_list.dart';
import '../widgets/alert_message_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final picker = ImagePicker();
  File? _image;

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 600,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      scanImage();
    }
  }

  void scanImage() async {
    context.read<FoodLogCubit>().addMealFromImage(_image!);
  }

  void showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Camera'),
            onTap: () {
              Navigator.pop(context);
              getImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              getImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calorie Tracker'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today's trackers", style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 16),
                BlocBuilder<FoodLogCubit, FoodLogState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    children: [
                      // Tracker Section
                      DailyTracker(
                        calories: state.totalCalories,
                        protein: state.totalProtein,
                        carbs: state.totalCarbs,
                        fat: state.totalFat,
                      ),
                      SizedBox(height: 24),

                      // Inline Alert Section for Success or Error
                      if (state.successMessage != null || state.error != null)
                          AlertMessageWidget(
                            errorMessage: state.error,
                            successMessage: state.successMessage,
                            onClose: () => context.read<FoodLogCubit>().clearMessages(),
                          ),

                      // Meals Section
                      Text('Meals', style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: 16),
                      MealList(meals: state.meals),
                    ],
                  );
                },
              ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showImageSourceActionSheet(context),
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
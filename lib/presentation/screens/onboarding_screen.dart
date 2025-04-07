import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/calorie_calculator.dart';
import '../../data/local/preference_manager.dart';
import '../../data/models/user_data.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  double? weight;
  double? height; // Added height field
  int? age;
  String? activityLevel;
  String? gender;
  int estimatedCalories = 0;
  String? userGoal;

  // Activity level descriptions for better user understanding
  final Map<String, String> activityLevelDescriptions = {
    'Sedentary': 'Little or no exercise, desk job',
    'Light': '1-3 days/week of exercise',
    'Moderate': '3-5 days/week of moderate activity',
    'Active': '6-7 days/week of exercise',
    'Very Active': 'Very intense exercise/sports & physical job'
  };

  Future<void> _savePreferences() async {
    final maintenanceCalories = CalorieCalculator.fallbackEstimateCalories(
      weight: weight!,
      height: height!, // Added height parameter
      age: age!,
      activityLevel: activityLevel!,
      gender: gender!,
    );

    final adjustedCalories = CalorieCalculator.calculateCaloriesBasedOnGoal(
      maintenanceCalories: maintenanceCalories,
      goal: userGoal!,
    );

    final macroGoals = CalorieCalculator.calculateMacroGoals(
      calories: adjustedCalories,
      goal: userGoal!,
    );

    setState(() {
      estimatedCalories = adjustedCalories;
    });

    final userData = UserData(
      weight: weight!,
      height: height!, // Added height
      age: age!,
      activityLevel: activityLevel!,
      gender: gender!,
      goal: userGoal!,
      estimatedCalories: adjustedCalories,
      proteinGoal: macroGoals['proteinGoal']!,
      fatGoal: macroGoals['fatGoal']!,
      carbsGoal: macroGoals['carbsGoal']!,
    );

    final prefManager = PreferenceManager(await SharedPreferences.getInstance());
    await prefManager.saveUserData(userData);
  }

  void _nextPage() {
    if (_currentPage < 6) {
      if (_currentPage == 5) {
        _savePreferences();
      }
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  void _skipToMain() {
    Navigator.pushReplacementNamed(context, '/main');
  }

  Widget _buildPage(String title, String assetPath, Widget inputField) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 7,
            child: Image.asset(
              assetPath,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                inputField,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLevelDropdown() {
    return Column(
      children: [
        DropdownButton<String>(
          value: activityLevel,
          isExpanded: true,
          items: activityLevelDescriptions.entries
              .map((entry) => DropdownMenuItem(
                    value: entry.key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          entry.value,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ))
              .toList(),
          onChanged: (value) => setState(() => activityLevel = value),
          hint: Text('Select Activity Level'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevents keyboard from pushing up content
      appBar: _currentPage == 0 ? AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: _skipToMain,
            child: Text('Skip'),
          ),
        ],
      ) : null,
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          _buildPage(
            'Enter Your Weight',
            'assets/onboarding/onboarding_weight.png',
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) => weight = double.tryParse(value),
              decoration: InputDecoration(labelText: 'Weight in kg'),
            ),
          ),
          _buildPage(
            'Enter Your Height',
            'assets/onboarding/onboarding_height.png',
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) => height = double.tryParse(value),
              decoration: InputDecoration(labelText: 'Height in cm'),
            ),
          ),
          _buildPage(
            'Enter Your Age',
            'assets/onboarding/onboarding_age.png',
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) => age = int.tryParse(value),
              decoration: InputDecoration(labelText: 'Age in years'),
            ),
          ),
          _buildPage(
            'Select Your Activity Level',
            'assets/onboarding/onboarding_activity_level.png',
            _buildActivityLevelDropdown(),
          ),
          _buildPage(
            'Select Your Gender',
            'assets/onboarding/onboarding_gender.png',
            DropdownButton<String>(
              value: gender,
              isExpanded: true,
              items: ['Male', 'Female', 'Other']
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (value) => setState(() => gender = value),
              hint: Text('Select Your Gender'),
            ),
          ),
          _buildPage(
            'What is your goal?',
            'assets/onboarding/onboarding_goal.png',
            DropdownButton<String>(
              value: userGoal,
              isExpanded: true,
              items: ['Weight Loss', 'Maintenance', 'Muscle Gain']
                  .map((goal) => DropdownMenuItem(value: goal, child: Text(goal)))
                  .toList(),
              onChanged: (value) => setState(() => userGoal = value),
              hint: Text('Select Your Goal'),
            ),
          ),
          _buildWelcomePage(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 48,
                width: 120,
                child: TextButton(
                  onPressed: _currentPage > 0 
                    ? () => _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      )
                    : null,
                  child: Text(
                    _currentPage > 0 ? 'Back' : '',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(
                height: 48,
                width: 120,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == 6 ? 'Finish' : 'Next',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 7,
            child: Image.asset(
              'assets/onboarding/onboarding_welcome.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(
                  'Welcome to Calorie Lens!',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Your Daily Calorie Target',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '$estimatedCalories kcal',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
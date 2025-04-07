class CalorieCalculator {
  /// Calculates the Basal Metabolic Rate (BMR) and estimated daily calorie needs
  /// using the Mifflin-St Jeor Equation
  static int fallbackEstimateCalories({
    required double weight, // in kg
    required double height, // in cm
    required int age,
    required String activityLevel,
    required String gender,
  }) {
    double bmr;

    // Calculate BMR using Mifflin-St Jeor Equation
    if (gender == 'Male') {
      bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else if (gender == 'Female') {
      bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    } else {
      // Average BMR for other genders
      double maleBmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
      double femaleBmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
      bmr = (maleBmr + femaleBmr) / 2;
    }

    // Determine activity multiplier based on detailed activity levels
    double activityMultiplier = switch (activityLevel) {
      'Sedentary' => 1.2, // Little or no exercise, desk job
      'Light' => 1.375, // Light exercise 1-3 days/week
      'Moderate' => 1.55, // Moderate exercise 3-5 days/week
      'Active' => 1.725, // Heavy exercise 6-7 days/week
      'Very Active' => 1.9, // Very heavy exercise, physical job
      _ => 1.2 // Default to sedentary if unknown
    };

    return (bmr * activityMultiplier).toInt();
  }

  /// Adjusts calories based on the user's goal with scientifically-backed adjustments
  static int calculateCaloriesBasedOnGoal({
    required int maintenanceCalories,
    required String goal,
  }) {
    return switch (goal) {
      'Weight Loss' => (maintenanceCalories * 0.8).round(), // 20% deficit
      'Muscle Gain' => (maintenanceCalories * 1.15).round(), // 15% surplus
      _ => maintenanceCalories // Maintenance
    };
  }

  /// Calculates macronutrient goals based on calorie intake and user goal
  /// Returns values in grams per day
  static Map<String, int> calculateMacroGoals({
    required int calories,
    required String goal,
  }) {
    // Initialize default macro ratios
    double proteinPercent;
    double fatPercent;
    double carbsPercent;

    switch (goal) {
      case 'Weight Loss':
        // Higher protein for muscle preservation during deficit
        proteinPercent = 0.30; // 30% of calories from protein
        fatPercent = 0.25; // 25% of calories from fat
        carbsPercent = 0.45; // 45% of calories from carbs
        break;
      case 'Muscle Gain':
        // Moderate protein, higher carbs for muscle growth
        proteinPercent = 0.25; // 25% of calories from protein
        fatPercent = 0.25; // 25% of calories from fat
        carbsPercent = 0.50; // 50% of calories from carbs
        break;
      default: // Maintenance
        // Balanced distribution
        proteinPercent = 0.25; // 25% of calories from protein
        fatPercent = 0.25; // 25% of calories from fat
        carbsPercent = 0.50; // 50% of calories from carbs
    }

    // Calculate grams of each macronutrient
    // Protein & Carbs = 4 calories per gram
    // Fat = 9 calories per gram
    return {
      'proteinGoal': (calories * proteinPercent / 4).round(),
      'fatGoal': (calories * fatPercent / 9).round(),
      'carbsGoal': (calories * carbsPercent / 4).round(),
    };
  }

  /// Calculates recommended water intake in milliliters based on weight
  static int calculateWaterIntake({
    required double weight, // in kg
    required String activityLevel,
  }) {
    // Base calculation: 30-35ml per kg of body weight
    double baseWater = weight * 33; // Using 33ml as a middle ground

    // Adjust for activity level
    double activityMultiplier = switch (activityLevel) {
      'Sedentary' => 1.0,
      'Light' => 1.1,
      'Moderate' => 1.2,
      'Active' => 1.3,
      'Very Active' => 1.4,
      _ => 1.0
    };

    return (baseWater * activityMultiplier).round();
  }

  /// Estimates recommended protein intake in grams based on weight and activity level
  static int calculateProteinNeeds({
    required double weight, // in kg
    required String activityLevel,
    required String goal,
  }) {
    // Base protein requirements (in g/kg of body weight)
    double proteinMultiplier = switch (goal) {
      'Weight Loss' => 2.0, // Higher protein for muscle preservation
      'Muscle Gain' => 2.2, // Higher protein for muscle growth
      _ => 1.8 // Maintenance
    };

    // Adjust for activity level
    if (activityLevel == 'Active' || activityLevel == 'Very Active') {
      proteinMultiplier += 0.2;
    }

    return (weight * proteinMultiplier).round();
  }
}
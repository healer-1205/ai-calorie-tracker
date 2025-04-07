class UserData {
  final double weight;
  final double height;
  final int age;
  final String activityLevel;
  final String gender; // New gender field
  final String goal;
  final int estimatedCalories;
  final int proteinGoal;
  final int fatGoal;
  final int carbsGoal;

  UserData({
    required this.weight,
    required this.height,
    required this.age,
    required this.activityLevel,
    required this.gender, // Include gender
    required this.goal,
    required this.estimatedCalories,
    required this.proteinGoal,
    required this.fatGoal,
    required this.carbsGoal,
  });

  Map<String, dynamic> toJson() => {
        'weight': weight,
        'height': height,
        'age': age,
        'activityLevel': activityLevel,
        'gender': gender, // Save gender
        'goal': goal,
        'estimatedCalories': estimatedCalories,
        'proteinGoal': proteinGoal,
        'fatGoal': fatGoal,
        'carbsGoal': carbsGoal,
      };

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        weight: json['weight'],
        height: json['height'],
        age: json['age'],
        activityLevel: json['activityLevel'],
        gender: json['gender'], // Load gender
        goal: json['goal'],
        estimatedCalories: json['estimatedCalories'],
        proteinGoal: json['proteinGoal'],
        fatGoal: json['fatGoal'],
        carbsGoal: json['carbsGoal'],
      );
}
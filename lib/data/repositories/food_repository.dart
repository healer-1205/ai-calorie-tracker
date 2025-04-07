import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_item.dart';
import '../services/food_service.dart';

class FoodRepository {
  final FoodService _foodService;
  final SharedPreferences _prefs;
  
  FoodRepository(this._foodService, this._prefs);

  Future<List<FoodItem>> getDailyFoodLog(DateTime date) async {
    final String key = 'food_log_${date.toIso8601String().split('T')[0]}';
    final String? storedData = _prefs.getString(key);
    
    if (storedData != null) {
      final List<dynamic> jsonList = json.decode(storedData);
      return jsonList.map((json) => FoodItem.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> addFoodItem(FoodItem item) async {
    final String key = 'food_log_${item.timestamp.toIso8601String().split('T')[0]}';
    List<FoodItem> currentLog = await getDailyFoodLog(item.timestamp);
    currentLog.add(item);
    
    await _prefs.setString(
      key,
      json.encode(currentLog.map((item) => item.toJson()).toList()),
    );
  }

  Future<Either<String, FoodItem>> detectFoodFromImage(File image) async {
    return await _foodService.detectFoodAndCalories(image);
  }

    Future<void> deleteFoodItem(FoodItem item) async {
    final String key = 'food_log_${item.timestamp.toIso8601String().split('T')[0]}';
    List<FoodItem> currentLog = await getDailyFoodLog(item.timestamp);
    currentLog.removeWhere((existingItem) => existingItem.id == item.id);

    await _prefs.setString(
      key,
      json.encode(currentLog.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> updateFoodItem(FoodItem item) async {
    final String key = 'food_log_${item.timestamp.toIso8601String().split('T')[0]}';
    List<FoodItem> currentLog = await getDailyFoodLog(item.timestamp);
    final index = currentLog.indexWhere((existingItem) => existingItem.id == item.id);

    if (index != -1) {
      currentLog[index] = item;
      await _prefs.setString(
        key,
        json.encode(currentLog.map((item) => item.toJson()).toList()),
      );
    }
  }
}
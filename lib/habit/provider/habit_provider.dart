import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:habit_tracker/habit/models/habit_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitProvider extends ChangeNotifier {
  // Existing lists for habits and goals
  List<HabitModel> _habits = [];
  List<HabitModel> get habits => _habits;

  List<HabitModel> _goals = [];
  List<HabitModel> get goals => _goals;

  // --- STORING THE DATA INFOS METHODS ---

  // save  both lists to device memmory
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    // Converting list to the Json  strings by TOMAP()
    String habitsJson = jsonEncode(_habits.map((h) => h.toMap()).toList());
    String goalsJson = jsonEncode(_goals.map((g) => g.toMap()).toList());

    await prefs.setString('saved_habits', habitsJson);
    await prefs.setString('saved_goals', goalsJson);
  }

  // Load data from device memory on startup
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    String? habitsJson = prefs.getString('saved_habits');
    String? goalsJson = prefs.getString('saved_goals');
    if (habitsJson != null) {
      Iterable decoded = jsonDecode(habitsJson);
      _habits = decoded.map((h) => HabitModel.fromMap(h)).toList();
    }
    print("Loaded habits: ${_habits.length}");
    if (goalsJson != null) {
      Iterable decoded = jsonDecode(goalsJson);
      _goals = decoded.map((h) => HabitModel.fromMap(h)).toList();
    }
    notifyListeners();
  }

  // --- EXISTING METHODS ---

  void addHabit(HabitModel newHabit) {
    _habits.add(newHabit);
    _saveToPrefs(); //<---- save after adding
    notifyListeners();
  }

  void toggleHabitStatus(int index) {
    final habit = _habits[index];
    final bool newStatus = !habit.isCompleted;

    // updating status situation in habits list
    _habits[index] = habit.copyWith(isCompleted: newStatus);

    // updating goallist situation
    final int goalIndex = _goals.indexWhere(
      (g) => g.goalTitle == habit.goalTitle,
    );

    if (goalIndex != -1) {
      _goals[goalIndex] = _goals[goalIndex].copyWith(isCompleted: newStatus);
    }

    _saveToPrefs(); // Save after changing status
    notifyListeners();
  }

  int get totalHabits => _habits.length;
  int get completedHabits => _habits.where((h) => h.isCompleted).length;

  double get progressPercentage {
    if (totalHabits == 0) return 0;
    return completedHabits / totalHabits;
  }

  void addGoal(HabitModel newGoal) {
    _goals.add(newGoal);
    _saveToPrefs(); // Save after adding
    notifyListeners();
  }

  // --- ADDED METHODS FOR YOUR GOALS LOGIC ---

  // 1. Extracts the numeric value from the period string (e.g., "30 Days" -> 30)
  int _getTotalDaysFromPeriod(String period) {
    try {
      // Removes non-digit characters and parses to integer
      final String numericPart = period.replaceAll(RegExp(r'[^0-9]'), '');
      return numericPart.isNotEmpty ? int.parse(numericPart) : 1;
    } catch (e) {
      return 1; // Default fallback if parsing fails
    }
  }

  // 2. Calculates progress percentage for each Goal's orange bar (0.0 to 1.0)
  double calculateGoalProgress(HabitModel goalItem) {
    int total = _getTotalDaysFromPeriod(goalItem.period);

    // Logic: If isCompleted is true, progress is 1 (or current day count)
    int current = goalItem.isCompleted ? 1 : 0;

    if (total <= 0) return 0.0;
    return (current / total).clamp(0.0, 1.0);
  }

  //  Optional: Helper to get progress text (e.g., "1 from 7 days target")
  String getGoalStatusText(HabitModel goalItem) {
    int total = _getTotalDaysFromPeriod(goalItem.period);
    int current = goalItem.isCompleted ? 1 : 0;
    return "$current from $total days target";
  }

  // -----DELETE METHOD FOR DELETEING HABITS------
  void deleteHabit(HabitModel deleteHabit) {
    _habits.removeWhere((habit) => habit.title == deleteHabit.title);
    _goals.removeWhere((goal) => goal.goalTitle == deleteHabit.goalTitle);
    _saveToPrefs();
    notifyListeners();
  }

             // ------Editing Habits&Goals-------
  void updateHabitGoal(HabitModel updatedHabit, String oldHabitTitle) {
    //--------------- Finding Loacation--------
    final habitIndex = _habits.indexWhere((h) => h.title == oldHabitTitle);

    if (habitIndex != -1) {
      ///---------- before Editing we pick up date old goal-----
      String oldGoalTitle = _habits[habitIndex].goalTitle;

      //---Goal location---
      final goalIndex = _goals.indexWhere((g) => g.goalTitle == oldGoalTitle);

      _habits[habitIndex] = updatedHabit;

      if (goalIndex != -1) {
        _goals[goalIndex] = updatedHabit;
      }

      _saveToPrefs();
      notifyListeners();
    }
  }
}

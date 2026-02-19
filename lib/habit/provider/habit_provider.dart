import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:habit_tracker/habit/models/habit_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitProvider extends ChangeNotifier {
  List<HabitModel> _habits = [];
  List<HabitModel> _goals = [];

  List<HabitModel> get habits => _habits;
  List<HabitModel> get goals => _goals;

  // --- PERSISTENCE (Saving & Loading) ---

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    // English comment: Encode both lists to JSON strings
    String habitsJson = jsonEncode(_habits.map((h) => h.toMap()).toList());
    String goalsJson = jsonEncode(_goals.map((g) => g.toMap()).toList());

    await prefs.setString('saved_habits', habitsJson);
    await prefs.setString('saved_goals', goalsJson);
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? habitsJson = prefs.getString('saved_habits');
    String? goalsJson = prefs.getString('saved_goals');

    if (habitsJson != null) {
      Iterable decoded = jsonDecode(habitsJson);
      _habits = decoded.map((h) => HabitModel.fromMap(h)).toList();
    }
    if (goalsJson != null) {
      Iterable decoded = jsonDecode(goalsJson);
      _goals = decoded.map((h) => HabitModel.fromMap(h)).toList();
    }
    
    // English comment: Always reset daily status after loading data
    resetDailyHabits();
    notifyListeners();
  }

  // --- DAILY RESET LOGIC ---

  void resetDailyHabits() {
    bool changed = false;
    DateTime now = DateTime.now();

    for (int i = 0; i < _habits.length; i++) {
      // English comment: If the habit was completed on a different day, reset its daily status
      if (_habits[i].isCompleted && _habits[i].lastCompleted != null) {
        if (_habits[i].lastCompleted!.day != now.day ||
            _habits[i].lastCompleted!.month != now.month ||
            _habits[i].lastCompleted!.year != now.year) {
          
          _habits[i] = _habits[i].copyWith(isCompleted: false);
          changed = true;
        }
      }
    }
    if (changed) {
      _saveToPrefs();
      notifyListeners();
    }
  }

  // --- CORE ACTIONS (Add, Toggle, Delete, Update) ---

  void addHabit(HabitModel newHabit) {
    _habits.add(newHabit);
    _saveToPrefs();
    notifyListeners();
  }

  void addGoal(HabitModel newGoal) {
    _goals.add(newGoal);
    _saveToPrefs();
    notifyListeners();
  }

  void toggleHabitStatus(int index) {
    final habit = _habits[index];
    final bool newStatus = !habit.isCompleted;

    // 1. Update Habit list status (Daily reset part)
    _habits[index] = habit.copyWith(
      isCompleted: newStatus,
      lastCompleted: newStatus ? DateTime.now() : null,
    );

    // 2. Update Goal list status (Cumulative progress part)
    final int goalIndex = _goals.indexWhere((g) => g.goalTitle == habit.goalTitle);

    if (goalIndex != -1) {
      int currentProgress = _goals[goalIndex].completedDays;
      
      // English comment: Increment or decrement the cumulative day counter
      int updatedProgress = newStatus ? currentProgress + 1 : (currentProgress > 0 ? currentProgress - 1 : 0);

      _goals[goalIndex] = _goals[goalIndex].copyWith(
        completedDays: updatedProgress,
        // English comment: For the Goal, isCompleted reflects "Done Today" for the badge
        isCompleted: newStatus,
        lastCompleted: newStatus ? DateTime.now() : null,
      );
    }

    _saveToPrefs();
    notifyListeners();
  }

  void deleteHabit(HabitModel habitToDelete) {
    _habits.removeWhere((h) => h.id == habitToDelete.id);
    _goals.removeWhere((g) => g.goalTitle == habitToDelete.goalTitle);
    _saveToPrefs();
    notifyListeners();
  }

  void updateHabitGoal(HabitModel updatedHabit, String oldHabitTitle) {
    final habitIndex = _habits.indexWhere((h) => h.title == oldHabitTitle);
    if (habitIndex != -1) {
      String oldGoalTitle = _habits[habitIndex].goalTitle;
      final goalIndex = _goals.indexWhere((g) => g.goalTitle == oldGoalTitle);

      _habits[habitIndex] = updatedHabit;
      if (goalIndex != -1) {
        _goals[goalIndex] = updatedHabit;
      }
      _saveToPrefs();
      notifyListeners();
    }
  }

  // --- PROGRESS & UI HELPERS ---

  int _getTotalDaysFromPeriod(String period) {
    try {
      final String numericPart = period.replaceAll(RegExp(r'[^0-9]'), '');
      int days = numericPart.isNotEmpty ? int.parse(numericPart) : 1;
      return days <= 0 ? 1 : days;
    } catch (e) {
      return 1;
    }
  }

  double calculateGoalProgress(HabitModel goalItem) {
    int total = _getTotalDaysFromPeriod(goalItem.period);
    int current = goalItem.completedDays;
    return (current / total).clamp(0.0, 1.0);
  }

  String getGoalStatusText(HabitModel goalItem) {
    int total = _getTotalDaysFromPeriod(goalItem.period);
    int current = goalItem.completedDays;
    return "$current from $total days target";
  }

  double getProgressByPeriod(String period) {
    if (_goals.isEmpty) return 0.0;
    
    final filtered = _goals.where((g) {
      if (period == 'All Time') return true;
      if (period == 'This Week') return g.period.toLowerCase().contains('week') || g.period.contains('7');
      if (period == 'This Month') return g.period.toLowerCase().contains('month') || g.period.contains('30');
      return true;
    }).toList();

    if (filtered.isEmpty) return 0.0;

    double sumProgress = 0.0;
    for (var goal in filtered) {
      sumProgress += calculateGoalProgress(goal);
    }
    return (sumProgress / filtered.length).clamp(0.0, 1.0);
  }

  // --- GETTERS FOR HABIT SCREEN CARD ---

  int get totalHabits => _habits.length;

  int get completedToday {
    DateTime now = DateTime.now();
    return _habits.where((h) => 
      h.isCompleted && 
      h.lastCompleted?.day == now.day &&
      h.lastCompleted?.month == now.month &&
      h.lastCompleted?.year == now.year
    ).length;
  }

  // English comment: Returns the average percentage for today's habits
  double get progressPercentage {
    if (totalHabits == 0) return 0.0;
    return (completedToday / totalHabits).clamp(0.0, 1.0);
  }
}
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class HabitModel {
  final String id;
  final String title;
  final String goalTitle;
  final String period;
  final String habitType;
  final bool isCompleted;
  final DateTime? lastCompleted;
  // English comment: Added to track cumulative progress (e.g., 5 out of 30 days)
  final int completedDays; 

  HabitModel({
    String? id,
    required this.title,
    required this.goalTitle,
    required this.habitType,
    required this.period,
    this.isCompleted = false,
    this.lastCompleted,
    this.completedDays = 0, // English comment: Defaults to 0 for new habits
  }) : id = id ?? uuid.v4();

  // English comment: Used to store in memory (SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'goalTitle': goalTitle,
      'habitType': habitType,
      'period': period,
      'isCompleted': isCompleted,
      'lastCompleted': lastCompleted?.toIso8601String(),
      'completedDays': completedDays, // English comment: Store the progress count
    };
  }

  // English comment: Create from Map for loading data
  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'],
      title: map['title'],
      goalTitle: map['goalTitle'],
      habitType: map['habitType'],
      period: map['period'],
      isCompleted: map['isCompleted'] ?? false,
      completedDays: map['completedDays'] ?? 0, // English comment: Load the progress count
      lastCompleted: map['lastCompleted'] != null
          ? DateTime.parse(map['lastCompleted'])
          : null,
    );
  }

  // English comment: Helper to create a copy of the model with updated fields
  HabitModel copyWith({
    String? id,
    String? title,
    String? goalTitle,
    String? period,
    String? habitType,
    bool? isCompleted,
    DateTime? lastCompleted,
    int? completedDays, // English comment: Allow updating the count
  }) {
    return HabitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      goalTitle: goalTitle ?? this.goalTitle,
      period: period ?? this.period,
      habitType: habitType ?? this.habitType,
      isCompleted: isCompleted ?? this.isCompleted,
      lastCompleted: lastCompleted ?? this.lastCompleted,
      completedDays: completedDays ?? this.completedDays,
    );
  }
}
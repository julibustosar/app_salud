import '../../domain/models/habit.dart';

class HabitModel extends Habit {
  HabitModel({
    required super.id,
    required super.name,
    required super.frequency,
    super.isCompleted,
  });
}

Map<String, dynamic> toJson() {
  return {
    'name': name,
    'frequency': frequency,
    'isCompleted': isCompleted,
  };
}
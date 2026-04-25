import '../../domain/models/habit.dart';

class HabitModel extends Habit {
  HabitModel({
    required super.id,
    required super.name,
    required super.frequency,
    super.isCompleted,
  });
  
  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      frequency: json['frequency'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'frequency': frequency,
      'isCompleted': isCompleted,
      // No enviamos el ID al crear, recuerda que la API lo genera
    };
  }
}
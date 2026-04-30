import 'package:tienda_app/domain/models/habit.dart';
import 'package:tienda_app/domain/repositories/habit_repository.dart';

class UpdateHabitUseCase {
  final HabitRepository repository;

  UpdateHabitUseCase(this.repository);

  Future<void> call(Habit habit) async {
    return await repository.updateHabit(habit);
  }
}
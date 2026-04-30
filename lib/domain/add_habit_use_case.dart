import 'package:tienda_app/domain/models/habit.dart';
import 'package:tienda_app/domain/repositories/habit_repository.dart';

class AddHabitsUseCase {
  final HabitRepository repository;

  AddHabitsUseCase(this.repository);

  Future<void> call(Habit habit) async {
    return await repository.addHabit(habit);
  }
}
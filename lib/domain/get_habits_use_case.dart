import 'package:tienda_app/domain/models/habit.dart';
import 'package:tienda_app/domain/repositories/habit_repository.dart';

class GetHabitsUseCase {
  final HabitRepository repository;

  GetHabitsUseCase(this.repository);

  Future<List<Habit>> call() async {
    return await repository.getHabits();
  }
}
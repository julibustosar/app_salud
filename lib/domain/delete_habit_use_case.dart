import 'package:tienda_app/domain/repositories/habit_repository.dart';

class DeleteHabitUseCase {
  final HabitRepository repository;

  DeleteHabitUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteHabit(id);
  }
}
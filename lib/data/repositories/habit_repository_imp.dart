import '../../domain/models/habit.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/habit_remote_datasource.dart';

class HabitRepositoryImp implements HabitRepository {
  final HabitRemoteDatasource remoteDataSource;

  HabitRepositoryImp(this.remoteDataSource);

  @override
  Future<List<Habit>> getHabits() async {
    return await remoteDataSource.getHabits();
  }

  @override
  Future<void> addHabit(Habit habit) async {
    await remoteDataSource.addHabit(habit);
  }
  
  @override
  Future<void> updateHabit(Habit habit) async {

  }
}
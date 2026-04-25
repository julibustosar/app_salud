import 'package:tienda_app/domain/models/habit.dart';

abstract class HabitRepository {
  //Obtener la lista de los hábitos.
  Future<List<Habit>> getHabits();

  //Guardar un nuevo hábito.
  Future<void> addHabit(Habit habit);

  //Actualizar el estado de uno de los hábitos.
  Future<void> updateHabit(Habit habit);
}
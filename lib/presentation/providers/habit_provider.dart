import 'package:flutter/cupertino.dart';
import 'package:tienda_app/domain/add_habit_use_case.dart';
import 'package:tienda_app/domain/get_habit_use_case.dart';
import 'package:tienda_app/domain/models/habit.dart';
import 'package:tienda_app/domain/delete_habit_use_case.dart';
import 'package:tienda_app/domain/update_habit_use_case.dart';

class HabitProvider extends ChangeNotifier {
  final GetHabitsUseCase getHabitsUseCase;
  final AddHabitsUseCase addHabitUseCase;
  final UpdateHabitUseCase updateHabitUseCase;
  final DeleteHabitUseCase deleteHabitUseCase;

  HabitProvider({
    required this.getHabitsUseCase,
    required this.addHabitUseCase,
    required this.updateHabitUseCase,
    required this.deleteHabitUseCase,
  });

  List<Habit> _habits = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchHabits() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _habits = await getHabitsUseCase.call();
    } catch (e) {
      _errorMessage = 'No pudimos conectar con la API.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createHabit(String name, String frequency) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newHabit = Habit(id: '', name: name, frequency: frequency);
      await addHabitUseCase.call(newHabit);
      await fetchHabits();
    } catch (e) {
      _errorMessage = 'Error al guardar el hábito.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleHabitCompletion(Habit habit) async {
    try {
      final updatedHabit = Habit(
        id: habit.id,
        name: habit.name,
        frequency: habit.frequency,
        isCompleted: !habit.isCompleted,
      );
      
      await updateHabitUseCase.call(updatedHabit); 
      
      await fetchHabits(); 
    } catch (e) {
      _errorMessage = 'No se pudo actualizar el hábito';
      notifyListeners();
    }
  }

  Future<void> deleteHabit(String id) async {
    try {
      await deleteHabitUseCase.call(id);
      await fetchHabits(); 
    } catch (e) {
      _errorMessage = 'No se pudo eliminar el hábito';
      notifyListeners();
    }
  }
}

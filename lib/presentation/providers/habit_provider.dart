import 'package:flutter/cupertino.dart';
import 'package:tienda_app/domain/add_habits_use_case.dart';
import 'package:tienda_app/domain/get_habits_use_case.dart';
import 'package:tienda_app/domain/models/habit.dart';

class HabitProvider extends ChangeNotifier {
  final GetHabitsUseCase getHabitsUseCase;
  final AddHabitsUseCase addHabitUseCase;

  HabitProvider({
    required this.getHabitsUseCase,
    required this.addHabitUseCase,
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
      _errorMessage = 'No pudimos conectar con la API de Python.';
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
}

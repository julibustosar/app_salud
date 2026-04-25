import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/habit_model.dart';
import '../../domain/models/habit.dart';

class HabitRemoteDataSource {
  final String baseUrl = 'http://10.0.2.2:8000'; // URL de tu API FastAPI

  Future<List<HabitModel>> getHabits() async {
    final response = await http.get(Uri.parse('$baseUrl/habits'));

    if (response.statusCode == 200) {
      // Le decimos a Dart que esto es una Lista dinámica
      final List<dynamic> jsonResponse = json.decode(response.body);
      
      // SOLUCIÓN AQUÍ: Usamos "as Map<String, dynamic>" para calmar a Dart
      return jsonResponse.map((habit) => 
        HabitModel.fromJson(habit as Map<String, dynamic>)
      ).toList();
      
    } else {
      throw Exception('Error al cargar los hábitos');
    }
  }

  Future<void> addHabit(Habit habit) async {
    // Nos aseguramos de crear explícitamente un HabitModel
    final habitModel = HabitModel(
      id: habit.id, 
      name: habit.name, 
      frequency: habit.frequency, 
      isCompleted: habit.isCompleted
    );

    final response = await http.post(
      Uri.parse('$baseUrl/habits'),
      headers: {"Content-Type": "application/json"},
      // SOLUCIÓN AQUÍ: Ahora habitModel sabe perfectamente que tiene toJson()
      body: json.encode(habitModel.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al guardar el hábito');
    }
  }
}

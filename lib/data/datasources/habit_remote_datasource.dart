import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/habit_model.dart';
import '../../domain/models/habit.dart';

class HabitRemoteDataSource {
  final String baseUrl = 'http://10.0.2.2:8000';

  Future<List<HabitModel>> getHabits() async {
    final response = await http.get(Uri.parse('$baseUrl/habits'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      
      return jsonResponse.map((habit) => 
        HabitModel.fromJson(habit as Map<String, dynamic>)
      ).toList();
      
    } else {
      throw Exception('Error al cargar los hábitos');
    }
  }

  Future<void> addHabit(Habit habit) async {
    final habitModel = HabitModel(
      id: habit.id, 
      name: habit.name, 
      frequency: habit.frequency, 
      isCompleted: habit.isCompleted
    );

    final response = await http.post(
      Uri.parse('$baseUrl/habits'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(habitModel.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al guardar el hábito');
    }
  }

  Future<void> updateHabit(Habit habit) async {
    final response = await http.put(
      Uri.parse('$baseUrl/habits/${habit.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': habit.id,
        'name': habit.name,
        'frequency': habit.frequency,
        'isCompleted': habit.isCompleted,
      }),
    );
    if (response.statusCode != 200) throw Exception('Error al actualizar');
  }

  Future<void> deleteHabit(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/habits/$id'));
    if (response.statusCode != 200) throw Exception('Error al eliminar');
  }
}

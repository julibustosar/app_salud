import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/habit_model.dart';
import '../../domain/models/habit.dart';

class HabitRemoteDatasource {
  final String baseUrl = 'http://10.0.2.2:8000';

  Future<List<HabitModel>> getHabits() async {
    final response = await http.get(Uri.parse('$baseUrl/habits'));

    if(response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((habit) => HabitModel.fromJson(habit)).toList();
    } else {
    throw Exception("Error al cargar los hábitos");
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
}

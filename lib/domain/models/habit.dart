class Habit {
  final String id;
  final String name;
  final String frequency;
  final bool isCompleted;

  //Datos del hábito como el nombre, la frecuencia y si se completa la frecuencia.
  
  Habit({
    required this.id,
    required this.name,
    required this.frequency,
    this.isCompleted = false,
  })
}
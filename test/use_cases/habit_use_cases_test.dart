import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tienda_app/domain/add_habit_use_case.dart';
import 'package:tienda_app/domain/delete_habit_use_case.dart';
import 'package:tienda_app/domain/get_habit_use_case.dart';
import 'package:tienda_app/domain/models/habit.dart';
import 'package:tienda_app/domain/repositories/habit_repository.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  late MockHabitRepository mockRepository;
  late GetHabitsUseCase getHabitsUseCase;
  late AddHabitsUseCase addHabitUseCase;
  late DeleteHabitUseCase deleteHabitUseCase;

  setUp(() {
    mockRepository = MockHabitRepository();
    getHabitsUseCase = GetHabitsUseCase(mockRepository);
    addHabitUseCase = AddHabitsUseCase(mockRepository);
    deleteHabitUseCase = DeleteHabitUseCase(mockRepository);
  });

  final testHabit = Habit(
    id: '1',
    name: 'Beber Agua',
    frequency: 'Diario',
    isCompleted: false,
  );

  final testHabitList = [testHabit];

  group('Pruebas de Casos de Uso de Hábitos', () {
    
    test('Debe obtener una lista de hábitos desde el repositorio', () async {
      when(() => mockRepository.getHabits()).thenAnswer((_) async => testHabitList);

      final result = await getHabitsUseCase.call();

      expect(result, testHabitList);
      verify(() => mockRepository.getHabits()).called(1);
    });

    test('Debe llamar al método createHabit del repositorio', () async {
      when(() => mockRepository.addHabit(testHabit)).thenAnswer((_) async => {});

      await addHabitUseCase.call(testHabit);

      verify(() => mockRepository.addHabit(testHabit)).called(1);
    });

    test('Debe llamar al método deleteHabit del repositorio con el ID correcto', () async {
      when(() => mockRepository.deleteHabit('1')).thenAnswer((_) async => {});

      await deleteHabitUseCase.call('1');

      verify(() => mockRepository.deleteHabit('1')).called(1);
    });
    
  });
}
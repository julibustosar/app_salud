import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tienda_app/domain/models/habit.dart';
import '../providers/habit_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitProvider>().fetchHabits();
    });
  }

  void _mostrarEditor(BuildContext context, Habit habit) {
  final nameController = TextEditingController(text: habit.name);
  String selectedFrequency = habit.frequency;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20, right: 20, top: 20
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Editar Hábito', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: selectedFrequency,
              items: ['Diario', 'Semanal', 'Mensual'].map((f) => 
                DropdownMenuItem(value: f, child: Text(f))).toList(),
              onChanged: (val) => selectedFrequency = val!,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updated = Habit(
                  id: habit.id,
                  name: nameController.text,
                  frequency: selectedFrequency,
                  isCompleted: habit.isCompleted,
                );
                if (!context.mounted) return;
                context.read<HabitProvider>().updateHabitUseCase.call(updated).then((_) {
                  if (!context.mounted) return;
                  context.read<HabitProvider>().fetchHabits();
                  Navigator.pop(context);
                });
              },
              child: const Text('Guardar Cambios'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Hábitos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.go('/login'),
          )
        ],
      ),
      body: Consumer<HabitProvider>(
        builder: (context, provider, child) {
          
          if (provider.isLoading && provider.habits.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage.isNotEmpty && provider.habits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(provider.errorMessage, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchHabits(),
                    child: const Text('Reintentar conexión'),
                  )
                ],
              ),
            );
          }

          if (provider.habits.isEmpty) {
            return const Center(
              child: Text(
                'No tienes hábitos aún.\n¡Presiona el botón + para crear uno!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.habits.length,
            itemBuilder: (context, index) {
              final habit = provider.habits[index];
              
              return Dismissible(
                key: Key(habit.id), 
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  provider.deleteHabit(habit.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hábito eliminado')),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _mostrarEditor(context, habit),
                    ),
                    onTap: () {
                      provider.toggleHabitCompletion(habit);
                    },
                    leading: CircleAvatar(
                      backgroundColor: habit.isCompleted 
                          ? Colors.green.withValues(alpha: 0.2)
                          : Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        habit.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                        color: habit.isCompleted ? Colors.green : Colors.grey,
                      ),
                    ),
                    title: Text(
                      habit.name, 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: habit.isCompleted ? TextDecoration.lineThrough : null,
                        color: habit.isCompleted ? Colors.grey : null,
                      ),
                    ),
                    subtitle: Text(habit.frequency),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-habit'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
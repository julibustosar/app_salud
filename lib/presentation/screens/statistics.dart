import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final habits = provider.habits;

    final int total = habits.length;
    final int completados = habits.where((h) => h.isCompleted).length;
    final double porcentaje = total == 0 ? 0 : (completados / total);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Progreso'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    const Text('Nivel de Cumplimiento', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 120,
                          width: 120,
                          child: CircularProgressIndicator(
                            value: porcentaje,
                            strokeWidth: 12,
                            backgroundColor: Colors.grey.shade200,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          '${(porcentaje * 100).toInt()}%',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tarjetas de Conteo
            Row(
              children: [
                _buildStatCard(
                  context, 
                  'Totales', 
                  total.toString(), 
                  Icons.list, 
                  Colors.blue
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  context, 
                  'Logrados', 
                  completados.toString(), 
                  Icons.check_circle, 
                  Colors.green
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(title, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();

  String _selectedFrequency = 'Diario'; 
  
  final List<String> _frequencyOptions = ['Diario', 'Semanal', 'Mensual'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _guardarHabito() async {
    if (_formKey.currentState!.validate()) {
      
      final provider = context.read<HabitProvider>();

      await provider.createHabit(
        _nameController.text.trim(),
        _selectedFrequency,
      );

      if (!mounted) return;

      if (provider.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage), backgroundColor: Colors.red),
        );
      } else {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<HabitProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nuevo Hábito'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¿Qué nuevo hábito quieres construir?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Campo de Nombre
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del hábito (ej. Beber agua)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.star_border),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo de Frecuencia
              DropdownButtonFormField<String>(
                initialValue: _selectedFrequency,
                decoration: const InputDecoration(
                  labelText: 'Frecuencia',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                items: _frequencyOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFrequency = newValue!;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Botón de Guardar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _guardarHabito,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Guardar Hábito', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda_app/services/notificacion_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosLocales();
  }

  Future<void> _cargarDatosLocales() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('userName') ?? '';
      _goalController.text = prefs.getString('userGoal') ?? '';
      _isLoading = false;
    });
  }

  Future<void> _guardarDatosLocales() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text.trim());
    await prefs.setString('userGoal', _goalController.text.trim());
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Perfil guardado en el dispositivo!'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tu Nombre',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
            ),
            const SizedBox(height: 16), 
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  NotificationService.showNotification(
                    title: '¡Recordatorio de Salud!',
                    body: 'Hola ${_nameController.text}, no olvides completar tus hábitos de hoy.',
                  );
                },
                icon: const Icon(Icons.notifications_active),
                label: const Text('Probar Notificación'),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _goalController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Tu meta principal (Ej: Ser más saludable)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _guardarDatosLocales,
                icon: const Icon(Icons.save),
                label: const Text('Guardar Perfil', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
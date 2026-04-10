import 'package:flutter/material.dart';

void main() {
  runApp(login());
}

class login extends StatelessWidget {
  login({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text("hola mundo",
          style: TextStyle(fontSize: 60),
          ),
        )
      ),
    );
  }
}

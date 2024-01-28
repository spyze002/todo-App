import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_todo.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  void navigateTo() {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodo(),
    );
    Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo List "),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateTo,
        label: const Text(
          'Add Todo',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromRGBO(22, 219, 219, 1),
      ),
    );
  }
}

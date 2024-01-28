import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_todo.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }

  void navigateTo() {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodo(),
    );
    Navigator.push(context, route);
  }

  Future<void> fetchTodo() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.statusCode);
    print(response.body);
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

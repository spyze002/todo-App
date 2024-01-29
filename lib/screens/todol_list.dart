import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_todo.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List items = [];
  bool isloading = true;

  Future<void> deleteByID(String id) async {
    //; delete the item
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final res = await http.delete(uri);
    if (res.statusCode == 200) {
      // remove item from the list
    } else {
      //show error
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

// navigation route function
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
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json["items"] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo List "),
      ),
      body: Visibility(
        visible: isloading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final id = item['_id'] as String;
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Text(item['title']),
                subtitle: Text(item['description']),
                trailing: PopupMenuButton(onSelected: (value) {
                  if (value == 'edit') {
                    // Open edit page
                  } else if (value == 'delete') {
                    //delete items from todo list
                    deleteByID(id);
                  }
                }, itemBuilder: (context) {
                  return const [
                    PopupMenuItem(
                      child: Text('Edit'),
                      value: 'edit',
                    ),
                    PopupMenuItem(
                      child: Text('Delete'),
                      value: 'delete',
                    )
                  ];
                }),
              );
            },
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateTo,
        label: const Text('Add Todo', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromRGBO(22, 219, 219, 1),
      ),
    );
  }
}

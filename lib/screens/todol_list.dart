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
      final filteredItem =
          items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filteredItem;
      });
      showSuccessMessage('Item deleted');
    } else {
      //show error
      showErrorMessage(' Deletion failed');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

// navigation to add_todo
  Future<void> navigateTo() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodo(),
    );
    await Navigator.push(context, route);

    setState(() {
      isloading = true;
    });
    fetchTodo();
  }

  // Navigate to edit page
  Future<void> navigateToEdit(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodo(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    fetchTodo();
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

  void showSuccessMessage(String message) {
    final snackbar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void showErrorMessage(String message) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Todo item, click on the button to add todo',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    trailing: PopupMenuButton(onSelected: (value) {
                      if (value == 'edit') {
                        // Open edit page
                        navigateToEdit(item);
                      } else if (value == 'delete') {
                        //delete items from todo list
                        deleteByID(id);
                      }
                    }, itemBuilder: (context) {
                      return const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        )
                      ];
                    }),
                  ),
                );
              },
            ),
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodo extends StatefulWidget {
  final Map? todo;
  const AddTodo({
    super.key,
    this.todo,
  });

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleTitle = TextEditingController();
  TextEditingController titleDescription = TextEditingController();

  bool isEdit = false;

  Future<void> submitData() async {
    // get the data from form
    final title = titleTitle.text;
    final description = titleDescription.text;
    final requestbody = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    // submit data to the server
    const url = 'https://api.nstack.in/v1/todos';
    //converting URL to uri
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(requestbody),
        headers: {'content-type': 'application/json'});

    // show user if the data is successfully submited or not
    if (response.statusCode == 201) {
      titleTitle.text = ''; //setting text fields to blank when data is sent
      titleDescription.text = '';
      showSuccessMessage(' Data Sent');
    } else {
      showErrorMessage('Something unexpected Occur');
    }
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
  void initState() {
    super.initState();
    final sectodo = widget.todo;
    if (sectodo != null) {
      isEdit = true;
      final title = sectodo['title'];
      final description = sectodo['description'];
      titleTitle.text = title;
      titleDescription.text = description;
    }
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('You can not update without Todo Data');
      return;
    }
    final id = todo['_id'];
    final title = titleTitle.text;
    final description = titleDescription.text;
    final requestbody = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(requestbody),
      headers: {'content-type': 'application/json'},
    );
    if (response.statusCode == 200) {
      showSuccessMessage(' Update Successful ');
    } else {
      showErrorMessage('Something unexpected Occur');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: titleTitle,
              decoration: const InputDecoration(hintText: 'title'),
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Description'),
              controller: titleDescription,
              minLines: 5,
              maxLines: 8,
              keyboardAppearance: Brightness.dark,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Text(isEdit ? 'Update' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

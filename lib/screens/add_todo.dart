import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleTitle = TextEditingController();
  TextEditingController titleDescription = TextEditingController();

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
      print(response.body);
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
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
              onPressed: submitData,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

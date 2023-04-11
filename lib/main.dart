import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      home: SignInSignUp(
        onSignUpSuccess: () {
          TodoList();
        },
      ),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  List<String> _todoItems = [];
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void _onSignUpSuccess() {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoList()),
    );
  }

  void initState() {
    super.initState();
    getDetailsList();
  }

  Future<void> _showSignInDialog() async {
    // Show the sign-in dialog
    await showDialog(
      context: context,
      builder: (context) {
        return SignInSignUp(
          onSignUpSuccess: _onSignUpSuccess, // Pass the callback function
        );
      },
    );

    // Clear the email and password fields
    _emailController.clear();
    _passwordController.clear();
  }

  Future<void> _addTask(String taskName) async {
    await FirebaseFirestore.instance.collection('tasks').add({
      'taskName': taskName,
      'completed': false,
    });
  }

  void _addTodoItem(String task) {
    if (task.length > 0) {
      _addTask(task);
      setState(() => _todoItems.add(task));
    }
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todoItems.length,
      itemBuilder: (context, index) {
        return _buildTodoItem(_todoItems[index], index);
      },
    );
  }

  Widget _buildTodoItem(String todoText, int index) {
    return ListTile(title: Text(todoText), onTap: () => _removeTodoItem(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('Todo App'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.greenAccent,
          onPressed: _addTodo,
          tooltip: 'Add task',
          child: const Icon(Icons.add)),
    );
  }

  void _addTodo() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.greenAccent,
              title: const Text('Add a task')),
          body: TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addTodoItem(val);
              Navigator.pop(context);
            },
            decoration: const InputDecoration(
              hintText: 'Enter task ',
            ),
          ));
    }));
  }

  void _removeTodoItem(int index) {
    setState(() => _todoItems.removeAt(index));
  }

  void _removeTodo(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Mark item as done?'),
              actions: <Widget>[
                OutlinedButton(
                    child: const Text('CANCEL'),
                    onPressed: () => Navigator.of(context).pop()),
                OutlinedButton(
                    child: const Text('MARK AS DONE'),
                    onPressed: () {
                      _removeTodoItem(index);
                      Navigator.of(context).pop();
                    })
              ]);
        });

    Future<void> _addTask(String taskName) async {
      // Check if the user is signed in
      if (FirebaseAuth.instance.currentUser == null) {
        // If not, show the sign-in dialog
        await _showSignInDialog();
      }

      // Add the task to the database
      await FirebaseFirestore.instance.collection('tasks').add({
        'taskName': taskName,
        //'completed': false,
        'userId': FirebaseAuth
            .instance.currentUser!.uid, // Set the user ID for this task
      });
    }
  }
}

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App with Lottie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<String> _tasks = [];
  final List<bool> _taskCompletion = [];
  final TextEditingController _taskController = TextEditingController();
  Color _backgroundColor = Colors.white;

  // Add task to the list
  void _addTask(String task) {
    setState(() {
      _tasks.add(task);
      _taskCompletion.add(false);
    });
    _taskController.clear();
  }

  // Toggle task completion status
  void _toggleTaskCompletion(int index) {
    setState(() {
      _taskCompletion[index] = !_taskCompletion[index];
      // Change background color when a task is completed
      _backgroundColor = _taskCompletion.contains(false)
          ? Colors.white
          : Colors.green.shade100;
    });
  }

  // Delete task from the list
  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      _taskCompletion.removeAt(index);
    });
  }

  // Edit task (update)
  void _updateTask(int index, String updatedTask) {
    setState(() {
      _tasks[index] = updatedTask;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do App with Lottie'),
      ),
      body: Container(
        color: _backgroundColor, // Apply dynamic background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              color: Colors.amber.shade300,
              child: const Center(
                child: Icon(
                  Icons.task_alt_sharp,
                  size: 200,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const Divider(
              color: Colors.black,
              thickness: 10,
            ),
            const SizedBox(
              height: 40,
            ),
            // Input field for adding a task
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'Enter task',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  _addTask(_taskController.text);
                }
              },
              child: const Text('Add Task'),
            ),
            const SizedBox(height: 20),
            // Display tasks in a ListView
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(_tasks[index]),
                    onDismissed: (direction) {
                      // Handle task deletion on swipe
                      _deleteTask(index);
                    },
                    child: ListTile(
                      title: Text(
                        _tasks[index],
                        style: TextStyle(
                          decoration: _taskCompletion[index]
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              _taskCompletion[index]
                                  ? Icons.check_circle
                                  : Icons.check_circle_outline,
                            ),
                            onPressed: () {
                              _toggleTaskCompletion(index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showUpdateDialog(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Show Lottie animation when a task is completed
            if (_taskCompletion.contains(true))
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Lottie.asset('asss/123.json', height: 150),
              ),
          ],
        ),
      ),
    );
  }

  // Show dialog to update task
  void _showUpdateDialog(int index) {
    TextEditingController updateController =
        TextEditingController(text: _tasks[index]);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Task'),
          content: TextField(
            controller: updateController,
            decoration: const InputDecoration(labelText: 'Task'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (updateController.text.isNotEmpty) {
                  _updateTask(index, updateController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

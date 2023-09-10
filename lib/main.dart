import 'package:flutter/material.dart';
import 'to_do_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  List<String> tasks = [];
  bool isChecked = false;
  late SharedPreferences prefs; // SharedPreferences instance

  @override
  void initState() {
    super.initState();
    loadTasks(); // Load tasks when the widget initializes
  }

  // Load tasks from SharedPreferences
  Future<void> loadTasks() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      tasks = prefs.getStringList('tasks') ?? [];
    });
  }

  // Save tasks to SharedPreferences
  Future<void> saveTasks() async {
    await prefs.setStringList('tasks', tasks);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('To Do List'),
      ),
      body:Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                return ToDoItem(
                  title: tasks[index],
                  onDelete: () {
                    setState(() {
                      tasks.removeAt(index);
                      saveTasks(); // Save tasks after deletion
                    });
                  },
                  onUpdateTitle: (newTitle, isChecked) { // Update the function signature
                    setState(() {
                      // Update the title of the task in your tasks list
                      tasks[index] = newTitle;
                      saveTasks(); // Save tasks after updating
                    });
                  },
                  isChecked: false, // Provide the initial isChecked value
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left:290,bottom: 20),
            child:FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Add Name of Task'),
                    content: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(hintText: 'Type name of task...'),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          String newTask = _textEditingController.text;
                          if (newTask.isNotEmpty) {
                            setState(() {
                              tasks.add(newTask);
                              saveTasks(); // Save tasks after addition
                            });
                            _textEditingController.clear();
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],

      ),

    );
  }
}
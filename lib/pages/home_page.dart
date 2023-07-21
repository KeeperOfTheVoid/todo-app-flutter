import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/boxes.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/util/dialog_box.dart';
import '../util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final Box taskBox;

  List<Task> tasks = [];

  @override
  void initState() {

    // Reference the box
    taskBox = Boxes.getTasks();

    // If first time ever to load, create default data
    if (taskBox.values.isEmpty) {
      createInitialData();
    }

    super.initState();
  }

  @override
  void dispose() {
    // Hive.close();
    Hive.box('myBox').close();

    super.dispose();
  }

  // Text controller
  final _controller = TextEditingController();

  void createInitialData() {
    List<Task> initialToDoList = [
      Task()..taskName = "Make tutorial"..taskCompleted = false,
      Task()..taskName = "Do exercise"..taskCompleted = false,
    ];

    final box = Boxes.getTasks();
    box.addAll(initialToDoList);
  }

  // Checkbox action
  void checkBoxChanged(Task task, bool? value) {
    task.taskCompleted = !task.taskCompleted;
    task.save();
  }

  // Save new task
  void saveNewTask() {

    final task = Task()
      ..taskName = _controller.text
      ..taskCompleted = false;

    // setState(() => tasks.add(task));
    final box = Boxes.getTasks();
    box.add(task);

    // Clear and close modal
    _controller.clear();
    Navigator.of(context).pop();
  }

  // Create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // Remove task
  void deleteTask(Task task) {
    task.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        centerTitle: true,
        title: const Text("TO DO"),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: taskBox.listenable(),
        builder: (context, Box box, _) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              var currentBox = box;
              var task = currentBox.getAt(index)!;
              return ToDoTile(
                taskName: task.taskName,
                taskCompleted: task.taskCompleted,
                onChanged: (value) => checkBoxChanged(task, value),
                deleteFunction: (context) => deleteTask(task),
              );
            },
          );
        },
      ),
    );
  }
}
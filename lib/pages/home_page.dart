import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/database.dart';
import '../util/dialog_box.dart';
import '../util/todo_tile.dart';
import 'dart:async';

/********************************************
 * 
 * Icon search from : 
 *                https://api.flutter.dev/flutter/material/Icons-class.html
 *                https://fonts.google.com/icons
 * 
 * 
********************************************/

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // if this is the 1st time ever openin the app, then create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }
    super.initState();
  }

  // text controller
  final _controller = TextEditingController();

  // checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  // save new task
  void saveNewTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        db.toDoList.add([_controller.text, false]);
        _controller.clear();
      });
      Navigator.of(context).pop();
      db.updateDataBase();
    } else {
      //print("text is empty");
      //print(db.toDoList);
      _showErrorDialog(context, "Empty task is no allow.");
    }
  }

  // create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          //onCancel: () => Navigator.of(context).pop(),
          onCancel: () {
            _controller.clear();
            Navigator.of(context).pop();
          },
          onClear: () {
            // clear the textfeild
            _controller.clear();
          },
        );
      },
    );
  }

  _showErrorDialog(BuildContext context, String msg) {
    // Create a Completer to represent the future result of the dialog
    Completer<void> completer = Completer();

    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dialog from closing when touching outside
      builder: (context) {
        // Close the dialog after 5 seconds
        Future.delayed(const Duration(seconds: 5), () {
          if (!completer.isCompleted) {
            Navigator.of(context).pop();
            completer.complete();
          }
        });

        return AlertDialog(
          title: Text("Warring"),
          content: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 24.0,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(msg),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (!completer.isCompleted) {
                  Navigator.of(context).pop();
                  completer.complete();
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  // // edit task
  // void editTask(int index) {
  //   createNewTask();
  //   _controller.text = db.toDoList[index][0]; // fill-in the task when edit
  //   /*
  //   setState(() {
  //     db.toDoList.removeAt(index);
  //   });
  //   db.updateDataBase();
  //   */
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*
          Image.asset(
            'assets/logo.png',  // Replace with your logo asset path
            fit: BoxFit.contain,
            height: 32,
          ),
          */
            Icon(
              Icons.edit_square,
              color: Colors.green,
              size: 30.0,
            ),
            SizedBox(width: 8),
            Text('TO DO LIST'),
          ],
        ),
        centerTitle: true, // centers the title text
        elevation: 0, // Removes the shadow below the app bar
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
            //editFunction: (context) => editTask(index),
          );
        },
      ),
    );
  }
}

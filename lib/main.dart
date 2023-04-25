import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textController = TextEditingController();
  List<List<dynamic>> _tasks = [];
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'To-Do List',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              alignment: Alignment.center,
              child: SizedBox(
                width: 450,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            labelText: 'Enter your task',
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                _tasks.add([value, false]);
                              });
                              _textController.clear();
                            }
                            print(_tasks);
                          },
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String inputText = _textController.text;
                        if (inputText.isNotEmpty) {
                          setState(() {
                            _tasks.add([inputText, false]);
                          });
                          _textController.clear();
                        }
                        print(_tasks);
                      },
                      child: const Text('+ Add Task'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  alignment: Alignment.topCenter,
                  child: ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.blue[400],
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 3,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          width: 500,
                          height: 50,
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Checkbox(
                                    value: _tasks[index][1],
                                    onChanged: (bool? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          _tasks[index][1] = newValue;
                                        });
                                      }
                                      print(_tasks);
                                    },
                                  ),
                                  Text(
                                    _tasks[index][0],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _tasks.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

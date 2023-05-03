import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
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
        primarySwatch: myColorSwatch,
      ),
      home: const MyHomePage(),
    );
  }
}

MaterialColor myColorSwatch = const MaterialColor(0xFF673AB7, <int, Color>{
  // <--- Définir la couleur principale ici
  50: Color(0xFFF2E7FE),
  100: Color(0xFFD7B8FF),
  200: Color(0xFFC094FF),
  300: Color(0xFFA370FE),
  400: Color(0xFF855CFF),
  500: Color(0xFF673AB7),
  600: Color(0xFF5F33A6),
  700: Color(0xFF542E90),
  800: Color(0xFF4A277A),
  900: Color(0xFF3B1D5C),
});

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
  final TextEditingController _textController = TextEditingController();
  bool isChecked = false;
  List<List<dynamic>> _tasks = [];
  String _email = '';

  @override
  void initState() {
    super.initState();
    getUserEmail().then((email) {
      setState(() {
        _email = email!;
      });
    });
    checkAndCreateDocument();
    readTasks().then((tasks) {
      setState(() {
        _tasks = tasks;
      });
    });
  }

  Future<List<List<dynamic>>> readTasks() async {
    final email = await getUserEmail();
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('tasks')
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return [doc.id, data['content'], data['isChecked']];
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 500,
          ),
          child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('To-Do App'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.account_circle),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<ProfileScreen>(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                  automaticallyImplyLeading: false,
                ),
                body: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'To-Do App',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 500,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: TextField(
                                    cursorColor: Colors.deepPurpleAccent,
                                    style: const TextStyle(
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    controller: _textController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(4),
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.deepPurpleAccent,
                                        ),
                                      ),
                                      labelText: 'Add your new To-do',
                                    ),
                                    onSubmitted: (value) {
                                      if (value.isNotEmpty) {
                                        createTask(content: value).then((id) {
                                          setState(() {
                                            _tasks.add([id, value, false]);
                                          });
                                          _textController.clear();
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurpleAccent,
                                ),
                                onPressed: () {
                                  String inputText = _textController.text;
                                  if (inputText.isNotEmpty) {
                                    createTask(content: inputText).then((id) {
                                      setState(() {
                                        _tasks.add([id, inputText, false]);
                                      });
                                      _textController.clear();
                                    });
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 25,
                                  height: 50,
                                  child: const Text(
                                    '+',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
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
                                      color: Colors.grey[300],
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 3,
                                            offset: Offset(0, 1)),
                                      ],
                                    ),
                                    width: 500,
                                    height: 50,
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Checkbox(
                                              value: _tasks[index][2],
                                              onChanged: (bool? newValue) {
                                                if (newValue != null) {
                                                  final docTask =
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(_email)
                                                          .collection('tasks')
                                                          .doc(
                                                              _tasks[index][0]);
                                                  docTask.update({
                                                    'isChecked': newValue,
                                                  });
                                                  setState(() {
                                                    _tasks[index][2] = newValue;
                                                  });
                                                }
                                              },
                                            ),
                                            Text(
                                              _tasks[index][1],
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(4.0),
                                                  bottomRight:
                                                      Radius.circular(4.0),
                                                ),
                                                color: Colors.red,
                                              ),
                                              padding: const EdgeInsets.all(5),
                                              child: IconButton(
                                                onPressed: () {
                                                  final docTask =
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(_email)
                                                          .collection('tasks')
                                                          .doc(
                                                              _tasks[index][0]);
                                                  docTask.delete();
                                                  setState(() {
                                                    _tasks.removeAt(index);
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                              ),
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
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        width: 150,
                        height: 43,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                            ),
                            onPressed: () {
                              final docTask = FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(_email)
                                  .collection('tasks');
                              docTask.get().then((snapshot) {
                                for (DocumentSnapshot ds in snapshot.docs) {
                                  ds.reference.delete();
                                }
                              });
                              setState(() {
                                _tasks.clear();
                              });
                            },
                            child: const Text('Clear All')),
                      ),
                    ],
                  ),
                ),
              )));
    });
  }

  String getMaxId(List<List<dynamic>> tasks) {
    int max = 0;
    for (var task in tasks) {
      if (task[0] is String && RegExp(r'^\d+$').hasMatch(task[0])) {
        int id = int.parse(task[0]);
        if (id > max) {
          max = id;
        }
      }
    }
    max += 1;
    return max.toString();
  }

  Future<String> createTask({required String content}) async {
    final docTask = FirebaseFirestore.instance
        .collection('users')
        .doc(_email)
        .collection('tasks')
        .doc(getMaxId(_tasks));

    final task = Task(
      id: docTask.id,
      content: content,
      isChecked: false,
    );
    final json = task.toJson();

    await docTask.set(json);
    return docTask.id;
  }

  Future<String?> getUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email;
    }
    return null;
  }

  Future<void> checkAndCreateDocument() async {
    final email = await getUserEmail();
    if (email == null || email.isEmpty) {
      return;
    }
    String documentPath = 'users/$email';
    bool documentExists = await FirebaseFirestore.instance.doc(documentPath).get().then((doc) => doc.exists);
    if (!documentExists) {
      await FirebaseFirestore.instance.doc(documentPath).set({
        'created_at': FieldValue.serverTimestamp(),
      });
    }
  }
}

class Task {
  String id;
  String content;
  bool isChecked;

  Task({
    this.id = '',
    required this.content,
    required this.isChecked,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'isChecked': isChecked,
      };

  static Task fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        content: json['content'],
        isChecked: json['isChecked'],
      );
}

import 'package:flutter/material.dart';
import 'package:to_do_list_flutter/logic/models/mysql.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
  var db = Mysql();
  final List<List<dynamic>> _tasks = [];

  void _getTasks() async {
    var conn = await db.getConnection();
    var results = await conn.query('SELECT content,isChecked FROM task');
    for (var element in results) {
      _tasks.add([element[0], element[1]]);
    }
    print(_tasks);
    await conn.close();
  }

  @override
  Widget build(BuildContext context) {
    _getTasks();
    return Scaffold(
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
                              setState(() {
                                _tasks.add([value, false]);
                              });
                              _textController.clear();
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
                          setState(() {
                            _tasks.add([inputText, false]);
                          });
                          _textController.clear();
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
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                                    },
                                  ),
                                  Text(
                                    _tasks[index][0],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(4.0),
                                        bottomRight: Radius.circular(4.0),
                                      ),
                                      color: Colors.red,
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: IconButton(
                                      onPressed: () {
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
                    setState(() {
                      _tasks.clear();
                    });
                  },
                  child: const Text('Clear All')),
            ),
          ],
        ),
      ),
    );
  }
}

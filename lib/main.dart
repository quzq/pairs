import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pairs',
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
      home: Scaffold(body: MyHomePage(title: 'title is here!')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> _numbers = [];
  int? _selectedIndex = null;

  void _initNumbers() {
    List<int> seed = new List.generate(8, (i) => i);
    setState(() {
      _numbers = seed + seed;
    });
  }

  void _selectIndex(int? index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List _chunk(list, int length) {
    List chunkedList = [
      [1, 2, 3, 4],
      [5, 6, 7, 8],
      [1, 2, 3, 4],
      [5, 6, 7, 8]
    ];
    return chunkedList;
  }

  @override
  Widget build(BuildContext context) {
    _initNumbers();

    Widget getButtonMatrix(List<int> numbers) {
      var rows = _chunk(numbers, 4).map((childArray) {
        List<int> array = childArray;
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: array.map((i) {
              return OutlinedButton(
                child: Text(i.toString()),
                style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: const BorderSide(),
                ),
                onPressed: () {},
              );
            }).toList());
      });
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rows.toList());
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: getButtonMatrix(_numbers),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _initNumbers,
        tooltip: 'Increment',
        child: Icon(Icons.sync),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

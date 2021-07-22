import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

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

// List shuffleArray(List items) {
//   var random = new Random();

//   // Go through all elements.
//   for (var i = items.length - 1; i > 0; i--) {
//     // Pick a pseudorandom number according to the list length
//     var n = random.nextInt(i + 1);

//     var temp = items[i];
//     items[i] = items[n];
//     items[n] = temp;
//   }

//   return items;
// }

class _MyHomePageState extends State<MyHomePage> {
  List<int> _numbers = [];
  List<bool> _visibilities = [];
  int? _selectedIndex;
  bool _showAnswer = false;
  String _debug = '';
  int _score = 0;
  bool isStarting = false;
  _MyHomePageState() {
    //_init();
  }

  List chunkArray(list, int length) {
    List chunks = [];
    for (var i = 0; i < list.length; i += length) {
      chunks
          .add(list.sublist(i, i + 2 > list.length ? list.length : i + length));
    }
    return chunks;
  }

  void _init() {
    List<int> seed = new List.generate(8, (i) => i);
    setState(() {
      _numbers = seed + seed;
      //_numbers = shuffleArray(_numbers) as List<int>;
      _visibilities = new List.generate(_numbers.length, (i) => true);
      _score = seed.length;
      _selectedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    Widget getButtonMatrix(List<int> numbers) {
      int columnsLength = 4;
      var rows =
          chunkArray(numbers, columnsLength).asMap().entries.map((rowEntry) {
        int rowIndex = rowEntry.key;
        List<int> rowValue = rowEntry.value;
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: rowValue.asMap().entries.map((colEntry) {
              int colIndex = rowIndex * columnsLength + colEntry.key;
              int colValue = colEntry.value;
              bool colVisibility = _visibilities[colIndex];
              return OutlinedButton(
                child: Text(
                    _showAnswer || _selectedIndex == colIndex || !colVisibility
                        ? colValue.toString()
                        : colVisibility.toString()),
                style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: const BorderSide(),
                ),
                onPressed: !_visibilities[colIndex]
                    ? null
                    : () {
                        setState(() {
                          if (_selectedIndex != null) {
                            int lastValue = _numbers[_selectedIndex ?? 99];
                            _debug = colValue.toString() +
                                ':' +
                                lastValue.toString();
                            if (colValue == lastValue &&
                                _selectedIndex != colIndex) {
                              _visibilities = _visibilities
                                  .asMap()
                                  .entries
                                  .map((visibilityEntry) {
                                return visibilityEntry.key == colIndex ||
                                        visibilityEntry.key == _selectedIndex
                                    ? false
                                    : visibilityEntry.value;
                              }).toList();
                            } else {
                              _score--;
                            }
                          }
                          _selectedIndex = colIndex;
                        });
                      },
              );
            }).toList());
      });
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rows.toList());
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
        widget.title + ' ' + _score.toString() + ' ' + _debug,
      )),
      body: Center(
        child: _score > 0 ? getButtonMatrix(_numbers) : Text('game over'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAnswer
            ? null
            : () {
                _init();
                setState(() {
                  _showAnswer = true;
                });
                Timer.periodic(
                  Duration(seconds: 1),
                  (Timer t) {
                    setState(() {
                      _showAnswer = false;
                    });
                  },
                );
              },
        tooltip: 'start',
        child: Icon(Icons.sync),
      ),
    );
  }
}

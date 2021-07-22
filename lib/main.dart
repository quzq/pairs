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
      home: Scaffold(body: MyHomePage(title: 'Pairs ')),
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

List shuffleArray(List items) {
  var random = new Random();

  for (var i = items.length - 1; i > 0; i--) {
    var n = random.nextInt(i + 1);

    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }

  return items;
}

List chunkArray(list, int length) {
  List chunks = [];
  for (var i = 0; i < list.length; i += length) {
    chunks.add(list.sublist(i, i + 2 > list.length ? list.length : i + length));
  }
  return chunks;
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> _numbers = [];
  List<bool> _visibilities = [];
  int? _selectedIndex;
  bool _showAnswer = false;
  String _debug = '';
  int _score = 0;
  int _highScore = 0;
  bool _isStarting = false;
  _MyHomePageState() {
    //_init();
  }

  void _init() {
    List<int> seed = new List.generate(8, (i) => i);
    setState(() {
      _numbers = seed + seed;
      _numbers = shuffleArray(_numbers) as List<int>;
      _visibilities = new List.generate(_numbers.length, (i) => true);
      _score = seed.length;
      _selectedIndex = null;
    });
  }

  int _countVisibled() {
    return _visibilities.fold<int>(0, (prev, i) {
      return prev + (i ? 1 : 0);
    });
  }

  Color _getColor(int number) {
    List<Color> colors = [
      Colors.red,
      Colors.lightGreen,
      Colors.blue,
      Colors.amber,
      Colors.brown,
      Colors.indigo,
      Colors.teal,
      Colors.purple,
    ];
    return colors[number];
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    Widget gameScreen() {
      int columnsLength = 4;
      var rows =
          chunkArray(_numbers, columnsLength).asMap().entries.map((rowEntry) {
        int rowIndex = rowEntry.key;
        List<int> rowValue = rowEntry.value;
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: rowValue.asMap().entries.map((colEntry) {
              int colIndex = rowIndex * columnsLength + colEntry.key;
              int colValue = colEntry.value;
              bool colVisibility = _visibilities[colIndex];
              return TextButton(
                child: Text(''),
                style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: const BorderSide(),
                  backgroundColor: _showAnswer ||
                          _selectedIndex == colIndex ||
                          !colVisibility
                      ? _getColor(colValue)
                      : Colors.white,
                ),
                onPressed: !_visibilities[colIndex]
                    ? null
                    : () {
                        setState(() {
                          int? lastValue = _selectedIndex == null
                              ? null
                              : _numbers[_selectedIndex ?? 99];
                          if (colValue == lastValue) {
                            if (_selectedIndex != colIndex) {
                              _visibilities = _visibilities
                                  .asMap()
                                  .entries
                                  .map((visibilityEntry) {
                                return visibilityEntry.key == colIndex ||
                                        visibilityEntry.key == _selectedIndex
                                    ? false
                                    : visibilityEntry.value;
                              }).toList();
                            }
                            _selectedIndex = null;
                          } else {
                            if (_selectedIndex != null) _score--;
                            _selectedIndex = colIndex;
                          }
                          if (_score == 0) {
                            _isStarting = false;
                          }
                          if (_countVisibled() == 0) {
                            _isStarting = false;
                            _highScore =
                                _score > _highScore ? _score : _highScore;
                          }
                        });
                      },
              );
            }).toList());
      });
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rows.toList());
    }

    Widget resultScrreen() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(_score == 0 ? 'game over' : 'clear !'),
          Text(_score == 0 ? '' : 'Your score is ' + _score.toString()),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
        ' score : ' + _score.toString() + ' ' + _debug,
      )),
      body: Center(
        child: _isStarting ? gameScreen() : resultScrreen(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAnswer
            ? null
            : () {
                _init();
                setState(() {
                  _showAnswer = true;
                  _isStarting = true;
                });
                Timer.periodic(
                  Duration(seconds: 3),
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

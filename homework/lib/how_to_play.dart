import 'package:flutter/material.dart';

class HowToPlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    ' Find out the right word. After each try, the tiles will show how close you are to the solution.',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 224, 213, 213)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGridCell('T', const Color.fromRGBO(27, 162, 149, 1)),
                    _buildGridCell('E', const Color.fromRGBO(98, 85, 89, 1)),
                    _buildGridCell('R', const Color.fromRGBO(98, 85, 89, 1)),
                    _buildGridCell('M', const Color.fromRGBO(98, 85, 89, 1)),
                    _buildGridCell('O', const Color.fromRGBO(98, 85, 89, 1)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'The letter ',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 224, 213, 213)),
                        textAlign: TextAlign.center,
                      ),
                      _buildGridCell(
                          'T', const Color.fromRGBO(27, 162, 149, 1)),
                      const Text(
                        ' is in the right position.',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 224, 213, 213)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGridCell('V', const Color.fromRGBO(98, 85, 89, 1)),
                    _buildGridCell('I', const Color.fromRGBO(98, 85, 89, 1)),
                    _buildGridCell('O', const Color.fromRGBO(216, 172, 108, 1)),
                    _buildGridCell('L', const Color.fromRGBO(98, 85, 89, 1)),
                    _buildGridCell('A', const Color.fromRGBO(98, 85, 89, 1)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'The letter ',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 224, 213, 213)),
                        textAlign: TextAlign.center,
                      ),
                      _buildGridCell(
                          'O', const Color.fromRGBO(216, 172, 108, 1)),
                      const Text(
                        ' is part of the word.',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 224, 213, 213)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGridCell('P', const Color.fromRGBO(98, 85, 89, 1)),
                    _buildGridCell('U', const Color.fromRGBO(98, 85, 89, 1)),
                    _buildGridCell('L', const Color.fromRGBO(98, 85, 89, 1)),
                    _buildGridCell('G', const Color.fromRGBO(50, 42, 44, 1)),
                    _buildGridCell('A', const Color.fromRGBO(98, 85, 89, 1)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'The letter ',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 224, 213, 213)),
                        textAlign: TextAlign.center,
                      ),
                      _buildGridCell('G', const Color.fromRGBO(50, 42, 44, 1)),
                      const Text(
                        " isn't part of the word.",
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 224, 213, 213)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "The accents aren't taken into account automatically, nor are they considered in the hints.",
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 224, 213, 213)),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'The word can contain repeated letters',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 224, 213, 213)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridCell(String letter, Color color) {
    return Container(
      margin: const EdgeInsets.all(2),
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        color: color == Colors.transparent
            ? const Color.fromRGBO(98, 85, 89, 1)
            : color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            fontSize: 32.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

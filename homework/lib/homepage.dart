import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import 'game_history.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // palavra aleatoria
  String chosenWord = '';
  final int totalWords = 1000;

  @override
  void initState() {
    super.initState();
    pickRandomWord();
  }

  Future<void> pickRandomWord() async {
    final random = Random();
    int randomIndex = random.nextInt(totalWords);

    String jsonString = await rootBundle.loadString('assets/words.json');
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    setState(() {
      chosenWord = jsonMap['words'][randomIndex].toUpperCase();

      // replace caracteres especiais
      chosenWord = chosenWord.replaceAll(RegExp(r'[ÀÁÂÃÄÅ]'), 'A');
      chosenWord = chosenWord.replaceAll(RegExp(r'[ÈÉÊË]'), 'E');
      chosenWord = chosenWord.replaceAll('Í', 'I');
      chosenWord = chosenWord.replaceAll('Ó', 'O');
      chosenWord = chosenWord.replaceAll('Ú', 'U');
      chosenWord = chosenWord.replaceAll('Ç', 'C');

      print(chosenWord);
    });
  }

  // fim de palavra aleatoria

  // visual grelha

  List<List<String>> grid =
      List.generate(6, (i) => List.generate(5, (j) => ''));
  List<List<Color>> gridColors =
      List.generate(6, (i) => List.generate(5, (j) => Colors.transparent));

  int currentRow = 0;
  int currentLetterIndex = 0;

  Map<String, Color> keyColors = {};

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

  // fim de visual grelha

  // teclado

  Widget _buildKeyboard() {
    List<String> keys = [
      'Q',
      'W',
      'E',
      'R',
      'T',
      'Y',
      'U',
      'I',
      'O',
      'P',
      'A',
      'S',
      'D',
      'F',
      'G',
      'H',
      'J',
      'K',
      'L',
      'Z',
      'X',
      'C',
      'V',
      'B',
      'N',
      'M',
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Define o tamanho máximo do teclado
        double maxKeyboardWidth = 500; 
        double keyboardWidth = constraints.maxWidth > maxKeyboardWidth
            ? maxKeyboardWidth
            : constraints.maxWidth;

        double buttonWidth =
            (keyboardWidth - 11 * 2) / 10; // 10 botões por linha, 11 espaços
        double buttonHeight = buttonWidth * 1.2; // Proporção de 1.2
        double fontSize =
            buttonWidth * 0.4; 

        return Center(
          child: SizedBox(
            width: keyboardWidth,
            child: Column(
              children: [
                for (var row in [0, 10, 20])
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          keys.skip(row).take(row == 19 ? 7 : 10).map((key) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1),
                          child: SizedBox(
                            width: buttonWidth,
                            height: buttonHeight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: keyColors[key] ??
                                    const Color.fromRGBO(76, 66, 71, 1),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                if (currentLetterIndex < 5) {
                                  setState(() {
                                    grid[currentRow][currentLetterIndex] = key;
                                    currentLetterIndex++;
                                  });
                                }
                              },
                              child: Text(key,
                                  style: TextStyle(fontSize: fontSize)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: buttonWidth * 3,
                        height: buttonHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(76, 66, 71, 1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          onPressed: () {
                            if (currentLetterIndex == 5) {
                              _checkWord();
                            }
                          },
                          child: Text("ENTER",
                              style: TextStyle(fontSize: fontSize)),
                        ),
                      ),
                      SizedBox(width: buttonWidth * 0.5),
                      SizedBox(
                        width: buttonWidth * 3,
                        height: buttonHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(76, 66, 71, 1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          onPressed: () {
                            if (currentLetterIndex > 0) {
                              setState(() {
                                currentLetterIndex--;
                                grid[currentRow][currentLetterIndex] = '';
                              });
                            }
                          },
                          child: Icon(Icons.backspace, size: fontSize * 1.2),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // verificar se a palavra está correta e mete corzinhas
  void _checkWord() {
    String enteredWord = grid[currentRow].join();
    List<Color> rowColors = List.filled(5, Colors.transparent);

    // Contagem de letras da palavra correta
    Map<String, int> targetLetterCounts = {};
    for (var letter in chosenWord.split('')) {
      targetLetterCounts[letter] = (targetLetterCounts[letter] ?? 0) + 1;
    }

    // Primeira verificação: letras na posição correta
    for (int i = 0; i < 5; i++) {
      if (enteredWord[i] == chosenWord[i]) {
        rowColors[i] = const Color.fromRGBO(27, 162, 149, 1);
        targetLetterCounts[enteredWord[i]] =
            targetLetterCounts[enteredWord[i]]! - 1;
        keyColors[enteredWord[i]] = const Color.fromRGBO(27, 162, 149, 1);
      }
    }

    // Segunda verificação: letras que estão na palavra, mas em outra posição
    for (int i = 0; i < 5; i++) {
      if (enteredWord[i] != chosenWord[i] &&
          targetLetterCounts[enteredWord[i]] != null &&
          targetLetterCounts[enteredWord[i]]! > 0) {
        rowColors[i] = const Color.fromRGBO(216, 172, 108, 1);
        targetLetterCounts[enteredWord[i]] =
            targetLetterCounts[enteredWord[i]]! - 1;

        // Se a letra já está verde no teclado, não se altera para amarelo
        if (keyColors[enteredWord[i]] !=
            const Color.fromRGBO(27, 162, 149, 1)) {
          keyColors[enteredWord[i]] = const Color.fromRGBO(216, 172, 108, 1);
        }
      } else if (rowColors[i] == Colors.transparent) {
        // Letra errada
        rowColors[i] = const Color.fromRGBO(
            50, 42, 44, 1); // Cor escura para letras erradas
        if (keyColors[enteredWord[i]] == null) {
          keyColors[enteredWord[i]] = const Color.fromARGB(255, 252, 235, 244)
              .withOpacity(0.1); // Letra mais clara no teclado
        }
      }
    }

    setState(() {
      gridColors[currentRow] = rowColors;
      currentRow++;
      currentLetterIndex = 0;
    });

    if (enteredWord == chosenWord) {
      _showWinorLoseDialog("WON");
      Provider.of<GameHistory>(context, listen: false)
          .addGame(chosenWord, currentRow);
    } else if (currentRow == 6) {
      _showWinorLoseDialog("LOST");
      currentRow++;
      Provider.of<GameHistory>(context, listen: false)
          .addGame(chosenWord, currentRow);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Grelha de jogo
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: grid.asMap().entries.map((entry) {
                  int rowIndex = entry.key;
                  List<String> row = entry.value;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: row.asMap().entries.map((entry) {
                      int letterIndex = entry.key;
                      String letter = entry.value;
                      return _buildGridCell(
                          letter, gridColors[rowIndex][letterIndex]);
                    }).toList(),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              _buildKeyboard(),
                    ],
          ),
        ),
      ),
    );
  }

  void _showWinorLoseDialog(String winorlose) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("YOU $winorlose!"),
          content: Text("The word was: $chosenWord"),
          actions: [
            TextButton(
              child: Text("Play Again"),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame(); // Função para reiniciar o jogo
              },
            ),
          ],
        );
      },
    );
  }

// Função para reiniciar o jogo
  void _resetGame() {
    setState(() {
      grid = List.generate(6, (i) => List.generate(5, (j) => ''));
      gridColors =
          List.generate(6, (i) => List.generate(5, (j) => Colors.transparent));
      currentRow = 0;
      currentLetterIndex = 0;
      keyColors = {};
      pickRandomWord(); // Escolhe uma nova palavra aleatória
    });
  }
}

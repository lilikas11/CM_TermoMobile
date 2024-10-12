import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'game_history.dart'; // Certifica-te de importar o GameHistory

class Statistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GameHistory>(
        builder: (context, gameHistory, child) {
          // games played
          if (gameHistory.gameHistory.isEmpty) {
            return Center(child: Text('No games played yet'));
          }
          final count = gameHistory.gameHistory.length;

          var right = 0;
          gameHistory.gameHistory.forEach((key, value) {
            if (value != 7) {
              right++;
            }
          });
          final correct = ((right * 100) / count).round();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Words: $count',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      'Score: $correct%',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: count,
                  itemBuilder: (context, index) {
                    String word = gameHistory.gameHistory.keys.elementAt(index);
                    int attempts = gameHistory.gameHistory[word]!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Slidable(
                        key: ValueKey(word),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                // Podes adicionar mais ações se necessário
                              },
                              backgroundColor: attempts == 7
                                  ? const Color.fromARGB(255, 175, 86, 86)
                                  : const Color.fromRGBO(27, 162, 149, 1),
                              foregroundColor: Colors.white,
                              icon: Icons.info,
                              label: 'Attemps: $attempts',
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            word,
                            style: TextStyle(fontSize: 20),
                          ),
                          tileColor: const Color.fromRGBO(76, 66, 71, 1),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

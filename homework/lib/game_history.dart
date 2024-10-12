import 'package:flutter/material.dart';

class GameHistory with ChangeNotifier {
  Map<String, int> _gameHistory = {};

  Map<String, int> get gameHistory => _gameHistory;

  void addGame(String word, int attempts) {
    _gameHistory[word] = attempts;
    notifyListeners();
  }
}

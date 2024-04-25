import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardCollection with ChangeNotifier {
  List<dynamic> _cards = [];

  List<dynamic> get cards => _cards;

  void addCard(dynamic card) {
    _cards.add(card);
    notifyListeners();
  }

  void removeCard(dynamic card) {
    _cards.remove(card);
    notifyListeners();
  }
}

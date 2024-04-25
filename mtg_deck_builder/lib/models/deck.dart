import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:mtg_deck_builder/services/sqlite_service.dart';
import 'dart:convert';

class Deck {
  final String id;
  final String name;
  List<CardModel> cards;

  Deck({required this.id, required this.name, List<CardModel>? cards})
      : cards = cards ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cards': jsonEncode(cards.map((x) => x.toMap()).toList()), // Convert cards to JSON string
    };
  }

  static Deck fromMap(Map<String, dynamic> map) {
    return Deck(
      id: map['id'],
      name: map['name'],
      cards: (jsonDecode(map['cards']) as List).map((x) => CardModel.fromMap(x)).toList(), // Decode JSON string back into List of Cards
    );
  }
}

class CardModel {
  final String id;
  final String name;
  final String type;

  CardModel({
    required this.id,
    required this.name,
    required this.type,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String? ?? 'Unknown',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }

   static CardModel fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map['id'] as String,
      name: map['name'] as String,
      type: map['type'] as String? ?? 'Unknown',
    );
   }
}

 // Provider for managing decks
class DeckProvider with ChangeNotifier {
  List<Deck> _decks = [];

  List<Deck> get decks => _decks;

  void addDeck(String name) {
    Deck newDeck = Deck(id: DateTime.now().toString(), name: name);
    _decks.add(newDeck);
    notifyListeners();
  }

  Deck? findDeck(String deckId) {
    // Using firstWhereOrNull for safe search without throwing exceptions
    return _decks.firstWhereOrNull((deck) => deck.id == deckId);
  }

  bool addCardToDeck(String deckId, CardModel card) {
    Deck? deck = findDeck(deckId);
    if (deck != null) {
      deck.cards.add(card);
      notifyListeners();
      return true; // Return true if card is successfully added
    }
    return false; // Return false if the deck was not found
  }
}

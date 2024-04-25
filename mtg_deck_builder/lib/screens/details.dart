import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mtg_deck_builder/models/deck.dart';
import 'package:mtg_deck_builder/screens/search.dart';
import 'package:collection/collection.dart';

class DeckDetailsScreen extends StatelessWidget {
  final String deckId;

  const DeckDetailsScreen({Key? key, required this.deckId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final decks = Provider.of<DeckProvider>(context).decks;
    final Deck? deck = decks.firstWhereOrNull((d) => d.id == deckId);

    return Scaffold(
      appBar: AppBar(
        title: Text(deck?.name ?? 'Deck Details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Add Cards to Deck',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: deck == null
          ? const Center(child: Text("Deck not found"))
          : buildDeckDetails(deck, context),
    );
  }

  Widget buildDeckDetails(Deck deck, BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Cards in ${deck.name}',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: deck.cards.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.style),
                  title: Text(deck.cards[index].name),
                  subtitle: Text(deck.cards[index].type),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

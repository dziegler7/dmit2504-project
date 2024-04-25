import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mtg_deck_builder/models/deck.dart';
import 'package:mtg_deck_builder/screens/details.dart';
import 'package:mtg_deck_builder/screens/search.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final decks = Provider.of<DeckProvider>(context).decks;

    return Scaffold(
      appBar: AppBar(
        title: Text("MTG Decks"),
      ),
      body: decks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("No decks available. Please create a deck first."),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _showAddDeckDialog(context),
                    child: Text('Create New Deck'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // background
                      onPrimary: Colors.white, // foreground
                    ),
                  )
                ],
              ),
            )
          : ListView.builder(
              itemCount: decks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(decks[index].name),
                  subtitle: Text("Tap to view deck details or add cards"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeckDetailsScreen(deckId: decks[index].id),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddDeckDialog(context),
          child: Icon(Icons.add),
          tooltip: 'Create New Deck',
      ),
    );
  }

  void _showAddDeckDialog(BuildContext context) {
    TextEditingController _deckNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Create New Deck"),
          content: TextField(
            controller: _deckNameController,
            decoration: InputDecoration(hintText: "Enter deck name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context). pop(),
            ),
            TextButton(
              child: Text("Create"),
              onPressed: () {
                if (_deckNameController.text.isNotEmpty) {
                  Provider.of<DeckProvider>(context, listen: false).addDeck(_deckNameController.text);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Deck created! Now you can add cards.")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a name for the deck."))
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
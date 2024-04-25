import 'package:flutter/material.dart';
import 'package:mtg_deck_builder/services/api_service.dart';
import 'package:mtg_deck_builder/models/deck.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _results = [];
  bool _isLoading = false;
  String _error = '';

  void _search() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final results = await MTGApiService().fetchCards(_controller.text);
      setState(() {
        _results = results;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

 void _addToDeck(dynamic cardJson) {
  var cardModel = CardModel.fromJson(cardJson);

  // Access DeckProvider from the current BuildContext
  var deckProvider = Provider.of<DeckProvider>(context, listen: false);

  // Show a dialog to select a deck if decks are available
  if (deckProvider.decks.isNotEmpty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select a Deck"),
          content: Container(
            width: double.maxFinite, // Ensures the dialog is wide enough
            child: ListView.builder(
              shrinkWrap: true, // Ensures the ListView only occupies needed space
              itemCount: deckProvider.decks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(deckProvider.decks[index].name),
                  onTap: () {
                    deckProvider.addCardToDeck(deckProvider.decks[index].id, cardModel);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added ${cardModel.name} to ${deckProvider.decks[index].name}'),
                        duration: Duration(seconds: 2),
                      )
                    );
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      }
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No decks available. Create a deck first.'),
        duration: Duration(seconds: 2),
      )
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Cards'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter card name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
              onSubmitted: (value) => _search(),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _error.isNotEmpty
                    ? Center(child: Text('Error: $_error'))
                    : _results.isEmpty
                        ? Center(child: Text('No results found.'))
                        : ListView.builder(
                            itemCount: _results.length,
                            itemBuilder: (context, index) {
                              var card = _results[index];
                              return ListTile(
                                title: Text(card['name']),
                                subtitle: Text(card.containsKey('type')
                                    ? card['type']
                                    : ''),
                                trailing: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () => _addToDeck(card),
                                ),
                                onTap: () {
                                  print('Tap on ${card['name']}');
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

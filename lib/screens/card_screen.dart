import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';

class CardScreen extends StatefulWidget {
  final int folderId;
  final String folderName;

  CardScreen({required this.folderId, required this.folderName});

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  List<Map<String, dynamic>> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final data = await DatabaseHelper.instance.getCards(widget.folderId);
    setState(() {
      _cards = data;
    });
  }

  Future<void> _addCard() async {
    if (_cards.length >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("This folder can only hold 6 cards.")),
      );
      return;
    }

    TextEditingController nameController = TextEditingController();
    TextEditingController suitController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Card"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(hintText: "Enter card name")),
              TextField(controller: suitController, decoration: InputDecoration(hintText: "Enter card suit")),
              TextField(controller: imageUrlController, decoration: InputDecoration(hintText: "Enter image URL")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty && suitController.text.isNotEmpty) {
                  await DatabaseHelper.instance.addCard(
                    nameController.text,
                    suitController.text,
                    imageUrlController.text,
                    widget.folderId,
                  );
                  _loadCards();
                }
                Navigator.of(context).pop();
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCard(int id) async {
    if (_cards.length <= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You need at least 3 cards in this folder.")),
      );
      return;
    }

    await DatabaseHelper.instance.deleteCard(id);
    _loadCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.folderName)),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: _cards[index]['image_url'] != null && _cards[index]['image_url'].isNotEmpty
                  ? Image.network(_cards[index]['image_url'], width: 50, height: 50, fit: BoxFit.cover)
                  : Icon(Icons.image_not_supported),
              title: Text(_cards[index]['name']),
              subtitle: Text(_cards[index]['suit']),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteCard(_cards[index]['id']),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCard,
        child: Icon(Icons.add),
      ),
    );
  }
}
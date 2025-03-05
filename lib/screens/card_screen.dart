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
              leading: _cards[index]['image_url'] != null
                  ? Image.network(_cards[index]['image_url'], width: 50, height: 50, fit: BoxFit.cover)
                  : Icon(Icons.image_not_supported),
              title: Text(_cards[index]['name']),
              subtitle: Text(_cards[index]['suit']),
            ),
          );
        },
      ),
    );
  }
}

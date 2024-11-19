import 'package:flutter/material.dart';
import 'package:airbnbcliente/components/searchbar.component.dart' as custom;
import 'package:airbnbcliente/components/lugarlist.component.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _searchResults = [];

  void _updateSearchResults(List<dynamic> results) {
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Lugares'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            custom.SearchBar(onSearchResults: _updateSearchResults),
            Expanded(
              child: _searchResults.isNotEmpty
                  ? LugarList(lugares: _searchResults)
                  : Center(
                      child: Text(
                        'No se encontraron lugares.',
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

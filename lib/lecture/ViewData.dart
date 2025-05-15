import 'package:flutter/material.dart';

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = "";
  List<String> items = [
    "Apple",
    "Banana",
    "Cherry",
    "Date",
    "Grape",
    "Lemon",
    "Mango",
    "Orange",
    "Pineapple",
    "Strawberry",
  ]; // Example data

  List<String> searchResults = [];

  @override
  void initState() {
    super.initState();
    searchResults = items;
  }

  void updateSearch(String input) {
    setState(() {
      query = input;
      searchResults = items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Bar Example"),
      ),
      body: Padding(
        padding:   EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: updateSearch, // Call updateSearch on input change
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Display Search Results
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(searchResults[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

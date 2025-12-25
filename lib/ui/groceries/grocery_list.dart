import 'package:flutter/material.dart';
import '../../data/mock_grocery_repository.dart';
import '../../models/grocery.dart';
import 'grocery_form.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  int currentIndex = 0;
  void onCreate() async {
    // Navigate to the form screen using the Navigator push
    Grocery? newGrocery = await Navigator.push<Grocery>(
      context,
      MaterialPageRoute(builder: (context) => const GroceryForm()),
    );
    if (newGrocery != null) {
      setState(() {
        dummyGroceryItems.add(newGrocery);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));

    if (dummyGroceryItems.isNotEmpty) {
      //  Display groceries with an Item builder and  LIst Tile

      content = IndexedStack(
        index: currentIndex,
        children: [
          GroceryTab(),
          SearchTab(items: dummyGroceryItems),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: onCreate, icon: const Icon(Icons.add))],
      ),
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.lightBlue,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            label: "Groceries",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        ],
        onTap: (value) => setState(() {
          currentIndex = value;
        }),
      ),
    );
  }
}

class SearchTab extends StatefulWidget {
  const SearchTab({super.key, required this.items});
  final List<Grocery> items;

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  List<Grocery> currentList = [];

  @override
  void initState() {
    super.initState();
    currentList.addAll(widget.items);
  }

  void onSearchChange(String value) => setState(() {
    List<Grocery> newList = [];
    if (value.isNotEmpty) {
      newList = currentList
          .where((e) => e.name.toLowerCase().startsWith(value.toLowerCase()))
          .toList();
    } else {
      newList.addAll(widget.items);
    }

    currentList = newList;
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        SearchBar(
          hintText: "Search",
          leading: Icon(Icons.search),
          onChanged: onSearchChange,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: currentList.length,
            itemBuilder: (context, index) {
              return GroceryTile(grocery: currentList[index]);
            },
          ),
        ),
      ],
    );
  }
}

class GroceryTab extends StatelessWidget {
  const GroceryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dummyGroceryItems.length,
      itemBuilder: (context, index) =>
          GroceryTile(grocery: dummyGroceryItems[index]),
    );
  }
}

class GroceryTile extends StatelessWidget {
  const GroceryTile({super.key, required this.grocery});

  final Grocery grocery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(width: 15, height: 15, color: grocery.category.color),
      title: Text(grocery.name),
      trailing: Text(grocery.quantity.toString()),
    );
  }
}

import 'package:flutter/material.dart';
import 'add_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Shows'),
      ),
      body: ListView.builder(
        itemCount: 3, // À remplacer par la vraie donnée plus tard
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Show ${index + 1}'),
            subtitle: Text('Description du show'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
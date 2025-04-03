import 'package:flutter/material.dart';
import '../models/show.dart';
import '../services/api_service.dart';
import '../widgets/show_card.dart';
import 'add_page.dart';
import 'update_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Show> shows = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShows();
  }

  Future<void> _loadShows() async {
    setState(() => isLoading = true);
    try {
      shows = await ApiService.getShows();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteShow(int id) async {
    try {
      await ApiService.deleteShow(id);
      _loadShows();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Shows'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadShows,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : shows.isEmpty
              ? const Center(child: Text('Aucun show disponible'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: shows.length,
                  itemBuilder: (context, index) {
                    final show = shows[index];
                    return ShowCard(
                      show: show,
                      onDelete: () => _deleteShow(show.id),
                      onTap: () async {
                        final shouldRefresh = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdatePage(showToUpdate: show),
                          ),
                        );
                        if (shouldRefresh == true) _loadShows();
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final shouldRefresh = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => const AddPage()),
          );
          if (shouldRefresh == true) _loadShows();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/show.dart';

class ShowCard extends StatelessWidget {
  final Show show;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const ShowCard({
    super.key,
    required this.show,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (show.imageUrl != null)
                Image.network(
                  '${ApiService.baseUrl}${show.imageUrl}',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 12),
              Text(
                show.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                show.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Chip(
                    label: Text(show.category),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
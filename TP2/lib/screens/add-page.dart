import 'dart:io';
import 'package:flutter/material.dart';
import '../services/api-service.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'movie';
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _imageFile = File(image.path));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ApiService.addShow(
        {
          'title': _titleController.text,
          'description': _descriptionController.text,
          'category': _selectedCategory,
        },
        _imageFile,
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un Show')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (value) => value!.isEmpty ? 'Titre requis' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Description requise' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                value: _selectedCategory,
                items: const [
                  DropdownMenuItem(value: 'movie', child: Text('Film')),
                  DropdownMenuItem(value: 'anime', child: Text('Anime')),
                  DropdownMenuItem(value: 'serie', child: Text('Série')),
                ],
                onChanged: (value) => setState(() => _selectedCategory = value!),
                decoration: const InputDecoration(labelText: 'Catégorie'),
              ),
              const SizedBox(height: 20),
              _imageFile != null
                  ? Image.file(_imageFile!, height: 150)
                  : const Text('Aucune image sélectionnée'),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Choisir une image'),
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Ajouter'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/show.dart';
import '../services/api_service.dart';

class UpdatePage extends StatefulWidget {
  final Show showToUpdate;

  const UpdatePage({super.key, required this.showToUpdate});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _selectedCategory;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.showToUpdate.title);
    _descriptionController = TextEditingController(text: widget.showToUpdate.description);
    _selectedCategory = widget.showToUpdate.category;
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _imageFile = File(image.path));
    }
  }

  Future<void> _updateShow() async {
    setState(() => _isLoading = true);
    try {
      await ApiService.updateShow(
        widget.showToUpdate.id,
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
      appBar: AppBar(title: const Text('Modifier le Show')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
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
            ),
            const SizedBox(height: 20),
            if (widget.showToUpdate.imageUrl != null)
              Image.network(
                '${ApiService.baseUrl}${widget.showToUpdate.imageUrl}',
                height: 150,
              ),
            if (_imageFile != null)
              Image.file(_imageFile!, height: 150),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Changer l\'image'),
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _updateShow,
                    child: const Text('Enregistrer'),
                  ),
          ],
        ),
      ),
    );
  }
}
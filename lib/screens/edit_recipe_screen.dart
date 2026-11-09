
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/saved_recipe.dart';
import '../providers/saved_recipe_provider.dart';

class EditRecipeScreen extends StatefulWidget {
  final SavedRecipe recipe;

  const EditRecipeScreen({
    super.key,
    required this.recipe,
  });

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _ingredientsController;
  late final TextEditingController _instructionsController;
  late final TextEditingController _imageController;
  late final TextEditingController _cuisineController;
  late final TextEditingController _prepTimeController;
  late final TextEditingController _cookTimeController;
  late final TextEditingController _servingsController;

  late String _difficulty;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final recipe = widget.recipe;

    _nameController = TextEditingController(text: recipe.recipeName);
    _descriptionController =
        TextEditingController(text: recipe.description ?? '');
    _ingredientsController =
        TextEditingController(text: recipe.ingredients);
    _instructionsController =
        TextEditingController(text: recipe.instructions);
    _imageController =
        TextEditingController(text: recipe.imageUrl ?? '');
    _cuisineController =
        TextEditingController(text: recipe.cuisine ?? '');
    _prepTimeController =
        TextEditingController(text: recipe.prepTime.toString());
    _cookTimeController =
        TextEditingController(text: recipe.cookTime.toString());
    _servingsController =
        TextEditingController(text: recipe.servings.toString());

    _difficulty = recipe.difficulty;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    _imageController.dispose();
    _cuisineController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    super.dispose();
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool required = false,
    String? hint,
    TextInputAction? textInputAction,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: maxLines > 1
            ? TextInputType.multiline
            : keyboardType,
        textInputAction: textInputAction ??
            (maxLines > 1
                ? TextInputAction.newline
                : TextInputAction.done),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: required
            ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return '$label wajib diisi';
                }
                return null;
              }
            : null,
      ),
    );
  }

  Future<void> _updateRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final updatedRecipe = SavedRecipe(
      id: widget.recipe.id!,
      recipeName: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      ingredients: _ingredientsController.text.trim(),
      instructions: _instructionsController.text.trim(),
      imageUrl: _imageController.text.trim().isEmpty
          ? null
          : _imageController.text.trim(),
      cuisine: _cuisineController.text.trim().isEmpty
          ? null
          : _cuisineController.text.trim(),
      difficulty: _difficulty,
      prepTime: int.tryParse(_prepTimeController.text) ?? 0,
      cookTime: int.tryParse(_cookTimeController.text) ?? 0,
      servings: int.tryParse(_servingsController.text) ?? 1,
      createdAt: widget.recipe.createdAt,
      
    );

    final success = await context
    .read<SavedRecipeProvider>()
    .updateRecipe(widget.recipe.id!, updatedRecipe);

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resep berhasil diperbarui')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<SavedRecipeProvider>().errorMessage ??
                'Gagal memperbarui resep',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Resep'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField(
                'Nama Resep',
                _nameController,
                required: true,
              ),
              _buildField('Deskripsi', _descriptionController, maxLines: 2),
              _buildField(
                'Bahan-bahan',
                _ingredientsController,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                required: true,
                hint: 'Tuliskan satu bahan untuk setiap baris.',
              ),
              _buildField(
                'Langkah Memasak',
                _instructionsController,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                required: true,
                hint: 'Tuliskan satu langkah memasak untuk setiap baris.',
              ),
              _buildField('URL Gambar', _imageController),
              _buildField('Jenis Masakan', _cuisineController),
              _buildField(
                'Waktu Persiapan (menit)',
                _prepTimeController,
                keyboardType: TextInputType.number,
              ),
              _buildField(
                'Waktu Memasak (menit)',
                _cookTimeController,
                keyboardType: TextInputType.number,
              ),
              _buildField(
                'Jumlah Porsi',
                _servingsController,
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                initialValue: _difficulty,
                decoration: const InputDecoration(
                  labelText: 'Tingkat Kesulitan',
                  border: OutlineInputBorder(),
                ),
                items: ['Mudah', 'Sedang', 'Sulit']
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _difficulty = value);
                  }
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _updateRecipe,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(
                    _isSaving ? 'Menyimpan...' : 'Simpan Perubahan',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

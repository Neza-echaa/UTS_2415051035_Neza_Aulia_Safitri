import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/saved_recipe.dart';
import '../providers/saved_recipe_provider.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _imageController = TextEditingController();
  final _cuisineController = TextEditingController();
  final _prepTimeController = TextEditingController(text: '0');
  final _cookTimeController = TextEditingController(text: '0');
  final _servingsController = TextEditingController(text: '1');

  String _difficulty = 'Mudah';
  bool _isSaving = false;

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

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bagian ini wajib diisi.';
    }
    return null;
  }

  String? _validateNumber(String? value, {bool allowZero = true}) {
    final number = int.tryParse(value ?? '');

    if (number == null || number < (allowZero ? 0 : 1)) {
      return allowZero
          ? 'Masukkan angka 0 atau lebih.'
          : 'Masukkan angka minimal 1.';
    }

    return null;
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final recipe = SavedRecipe(
      recipeName: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      ingredients: _ingredientsController.text.trim(),
      instructions: _instructionsController.text.trim(),
      imageUrl: _imageController.text.trim().isEmpty
          ? null
          : _imageController.text.trim(),
      cuisine: _cuisineController.text.trim().isEmpty
          ? null
          : _cuisineController.text.trim(),
      difficulty: _difficulty,
      prepTime: int.parse(_prepTimeController.text),
      cookTime: int.parse(_cookTimeController.text),
      servings: int.parse(_servingsController.text),
    );

    final success = await context.read<SavedRecipeProvider>().addRecipe(recipe);

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resep berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan resep. Periksa koneksi dan database.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        keyboardType: maxLines > 1 ? TextInputType.multiline : keyboardType,
        textInputAction: maxLines > 1
            ? TextInputAction.newline
            : TextInputAction.done,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE8DCCF)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(title: const Text('Tambah Resep')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Informasi Resep',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildTextField(
              label: 'Nama Resep',
              controller: _nameController,
              validator: _validateRequired,
              hint: 'Contoh: Nasi Goreng Spesial',
            ),

            _buildTextField(
              label: 'Deskripsi',
              controller: _descriptionController,
              validator: (_) => null,
              maxLines: 2,
              hint: 'Ceritakan sedikit tentang resep ini',
            ),

            _buildTextField(
              label: 'Bahan-bahan',
              controller: _ingredientsController,
              validator: _validateRequired,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              hint: 'Tuliskan satu bahan untuk setiap baris',
            ),

            _buildTextField(
              label: 'Cara Membuat',
              controller: _instructionsController,
              validator: _validateRequired,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              hint: 'Tuliskan satu langkah memasak untuk setiap baris',
            ),

            const SizedBox(height: 8),
            const Text(
              'Informasi Tambahan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildTextField(
              label: 'URL Gambar (Opsional)',
              controller: _imageController,
              validator: (_) => null,
              keyboardType: TextInputType.url,
              hint: 'https://contoh.com/gambar.jpg',
            ),

            _buildTextField(
              label: 'Jenis Masakan (Opsional)',
              controller: _cuisineController,
              validator: (_) => null,
              hint: 'Contoh: Indonesia',
            ),

            DropdownButtonFormField<String>(
              initialValue: _difficulty,
              decoration: InputDecoration(
                labelText: 'Tingkat Kesulitan',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'Mudah', child: Text('Mudah')),
                DropdownMenuItem(value: 'Sedang', child: Text('Sedang')),
                DropdownMenuItem(value: 'Sulit', child: Text('Sulit')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _difficulty = value);
                }
              },
            ),

            const SizedBox(height: 16),

            _buildTextField(
              label: 'Waktu Persiapan (menit)',
              controller: _prepTimeController,
              validator: (value) => _validateNumber(value),
              keyboardType: TextInputType.number,
            ),

            _buildTextField(
              label: 'Waktu Memasak (menit)',
              controller: _cookTimeController,
              validator: (value) => _validateNumber(value),
              keyboardType: TextInputType.number,
            ),

            _buildTextField(
              label: 'Jumlah Porsi',
              controller: _servingsController,
              validator: (value) => _validateNumber(value, allowZero: false),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveRecipe,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_isSaving ? 'Menyimpan...' : 'Simpan Resep'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8873A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

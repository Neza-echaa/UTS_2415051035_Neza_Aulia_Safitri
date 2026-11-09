
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/saved_recipe.dart';
import '../providers/saved_recipe_provider.dart';
import 'add_recipe_screen.dart';
import 'edit_recipe_screen.dart';
import 'my_recipe_detail_screen.dart';

class MyRecipesScreen extends StatelessWidget {
  const MyRecipesScreen({super.key});

  Future<void> _openAddRecipe(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddRecipeScreen(),
      ),
    );

    if (result == true && context.mounted) {
      context.read<SavedRecipeProvider>().loadSavedRecipes();
    }
  }

  Future<void> _openEditRecipe(
    BuildContext context,
    SavedRecipe recipe,
  ) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditRecipeScreen(recipe: recipe),
      ),
    );

    if (result == true && context.mounted) {
      context.read<SavedRecipeProvider>().loadSavedRecipes();
    }
  }

  Future<void> _deleteRecipe(
    BuildContext context,
    SavedRecipe recipe,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Resep?'),
          content: Text(
            'Apakah kamu yakin ingin menghapus '
            '"${recipe.recipeName}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm != true || !context.mounted) return;

    final success = await context
        .read<SavedRecipeProvider>()
        .deleteRecipe(recipe.id!);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Resep berhasil dihapus'
              : context.read<SavedRecipeProvider>().errorMessage ??
                  'Gagal menghapus resep',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resepku'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddRecipe(context),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Resep'),
      ),
      body: Consumer<SavedRecipeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.errorMessage != null &&
              provider.savedRecipes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Gagal memuat resep',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: provider.loadSavedRecipes,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.savedRecipes.isEmpty) {
            return RefreshIndicator(
              onRefresh: provider.loadSavedRecipes,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 130),
                  Icon(
                    Icons.menu_book_outlined,
                    size: 80,
                    color: Color(0xFFE8873A),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Belum Ada Resep',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Tambahkan resep masakanmu sendiri!',
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadSavedRecipes,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
              itemCount: provider.savedRecipes.length,
              itemBuilder: (context, index) {
                final recipe = provider.savedRecipes[index];

                return _MyRecipeCard(
                  recipe: recipe,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MyRecipeDetailScreen(recipe: recipe),
                      ),
                    );
                  },
                  onEdit: () => _openEditRecipe(context, recipe),
                  onDelete: () => _deleteRecipe(context, recipe),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _MyRecipeCard extends StatelessWidget {
  final SavedRecipe recipe;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MyRecipeCard({
  required this.recipe,
  required this.onTap,
  required this.onEdit,
  required this.onDelete,
});

  @override
  Widget build(BuildContext context) {
    final totalTime = recipe.prepTime + recipe.cookTime;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            onTap: onTap,
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: recipe.imageUrl != null &&
                      recipe.imageUrl!.isNotEmpty
                  ? Image.network(
                      recipe.imageUrl!,
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) {
                        return _imagePlaceholder();
                      },
                    )
                  : _imagePlaceholder(),
            ),
            title: Text(
              recipe.recipeName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.cuisine ?? 'Masakan lainnya'),
                  const SizedBox(height: 5),
                  Text(
                    '$totalTime menit • ${recipe.servings} porsi',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            trailing: const Icon(
              Icons.cloud_done_outlined,
              color: Color(0xFFE8873A),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                ),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'Hapus',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 75,
      height: 75,
      color: const Color(0xFFFFE8D2),
      child: const Icon(
        Icons.restaurant,
        size: 32,
        color: Color(0xFFE8873A),
      ),
    );
  }
}

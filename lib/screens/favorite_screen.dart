
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../models/recipe.dart';
import 'recipe_detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resep Favorit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<RecipeProvider>(
        builder: (context, provider, child) {
          final favorites = provider.favoriteRecipes;

          if (favorites.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 75,
                      color: Color(0xFFE8873A),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Belum Ada Resep Favorit',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tandai resep yang kamu sukai dengan '
                      'menekan ikon hati.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final recipe = favorites[index];

              return _FavoriteRecipeCard(recipe: recipe);
            },
          );
        },
      ),
    );
  }
}

class _FavoriteRecipeCard extends StatelessWidget {
  final Recipe recipe;

  const _FavoriteRecipeCard({
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<RecipeProvider>();

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecipeDetailScreen(recipe: recipe),
            ),
          );
        },
        child: Row(
          children: [
            Image.network(
              recipe.image,
              width: 115,
              height: 115,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 115,
                  height: 115,
                  color: const Color(0xFFFFE0C2),
                  child: const Icon(
                    Icons.restaurant,
                    size: 40,
                    color: Color(0xFFE8873A),
                  ),
                );
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      recipe.cuisineLabel,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 15,
                          color: Color(0xFFE8873A),
                        ),
                        const SizedBox(width: 4),
                        Text('${recipe.totalTime} menit'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              tooltip: 'Hapus dari favorit',
              onPressed: () {
                provider.toggleFavorite(recipe.id);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Resep dihapus dari favorit.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(
                Icons.favorite,
                color: Color(0xFFE8873A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

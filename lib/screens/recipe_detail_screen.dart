import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../providers/recipe_provider.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();
    final isFavorite = provider.isFavorite(recipe.id);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(title: const Text('Detail Resep')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              recipe.image,
              height: 240,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                height: 240,
                color: colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.restaurant,
                  size: 60,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Judul resep dan tombol Favorite
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  recipe.name,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<RecipeProvider>().toggleFavorite(recipe.id);
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : colorScheme.onSurfaceVariant,
                  size: 30,
                ),
                tooltip: isFavorite
                    ? 'Hapus dari Favorite'
                    : 'Tambah ke Favorite',
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            '${recipe.cuisineLabel} • ${recipe.difficultyLabel}',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _info(colorScheme, Icons.star, recipe.rating.toStringAsFixed(1)),
              _info(
                colorScheme,
                Icons.access_time,
                '${recipe.totalTime} menit',
              ),
              _info(colorScheme, Icons.people, '${recipe.servings} porsi'),
            ],
          ),

          const SizedBox(height: 25),

          // Bahan-bahan
          Text(
            'Bahan-bahan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 10),

          ...recipe.ingredients.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle, size: 8, color: Color(0xFFE8873A)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          // Cara membuat
          Text(
            'Cara Membuat',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 10),

          ...recipe.instructions.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: const Color(0xFFFFE0C2),
                    child: Text(
                      '${entry.key + 1}',
                      style: const TextStyle(
                        color: Color(0xFF38251C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Kategori hidangan
          if (recipe.mealTypeLabels.isNotEmpty) ...[
            Text(
              'Kategori Hidangan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recipe.mealTypeLabels
                  .map(
                    (type) => Chip(
                      label: Text(
                        type,
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      side: BorderSide.none,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _info(ColorScheme colorScheme, IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFE8873A)),
        const SizedBox(height: 5),
        Text(value, style: TextStyle(color: colorScheme.onSurface)),
      ],
    );
  }
}

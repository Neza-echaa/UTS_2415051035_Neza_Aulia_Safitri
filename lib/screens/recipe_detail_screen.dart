import 'package:flutter/material.dart';

import '../models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        title: const Text('Detail Resep'),
      ),
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
                color: const Color(0xFFF5E5D5),
                child: const Icon(
                  Icons.restaurant,
                  size: 60,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            recipe.name,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF38251C),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '${recipe.cuisineLabel} • ${recipe.difficultyLabel}',
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _info(
                Icons.star,
                recipe.rating.toStringAsFixed(1),
              ),
              _info(
                Icons.access_time,
                '${recipe.totalTime} menit',
              ),
              _info(
                Icons.people,
                '${recipe.servings} porsi',
              ),
            ],
          ),

          const SizedBox(height: 25),

          const Text(
            'Bahan-bahan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ...recipe.ingredients.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.circle,
                    size: 8,
                    color: Color(0xFFE8873A),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Cara Membuat',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
                  Expanded(child: Text(entry.value)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          if (recipe.mealTypeLabels.isNotEmpty) ...[
            const Text(
              'Kategori Hidangan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recipe.mealTypeLabels.map(
                (type) => Chip(
                  label: Text(type),
                  backgroundColor: const Color(0xFFFFE0C2),
                  side: BorderSide.none,
                ),
              ).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _info(IconData icon, String value) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFFE8873A),
        ),
        const SizedBox(height: 5),
        Text(value),
      ],
    );
  }
}
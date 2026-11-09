
import 'package:flutter/material.dart';

import '../models/saved_recipe.dart';

class SavedRecipeCard extends StatelessWidget {
  final SavedRecipe recipe;
  final VoidCallback onTap;
  final bool compact;

  const SavedRecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: compact ? 190 : double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: recipe.imageUrl != null &&
                      recipe.imageUrl!.trim().isNotEmpty
                  ? Image.network(
                      recipe.imageUrl!,
                      height: compact ? 125 : 145,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.recipeName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF38251C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.cuisine?.isNotEmpty == true
                        ? recipe.cuisine!
                        : 'Resep buatan sendiri',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 15,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.prepTime + recipe.cookTime} menit',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.person_outline,
                        size: 15,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${recipe.servings}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: compact ? 125 : 145,
      width: double.infinity,
      color: const Color(0xFFF5E5D5),
      child: const Center(
        child: Icon(
          Icons.restaurant,
          size: 40,
          color: Color(0xFFE8873A),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/saved_recipe.dart';

class MyRecipeDetailScreen extends StatelessWidget {
  final SavedRecipe recipe;

  const MyRecipeDetailScreen({super.key, required this.recipe});

  List<String> _getLines(String value) {
    return value
        .split('\n')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, color: const Color(0xFFE8873A), size: 23),
        const SizedBox(width: 9),
        Text(
          title,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('NAMA RESEP: ${recipe.recipeName}');
    debugPrint('URL GAMBAR: ${recipe.imageUrl}');

    final colorScheme = Theme.of(context).colorScheme;

    final ingredients = _getLines(recipe.ingredients);
    final instructions = _getLines(recipe.instructions);
    final totalTime = recipe.prepTime + recipe.cookTime;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(title: const Text('Detail Resep')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty)
              Image.network(
                recipe.imageUrl!,
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,

                webHtmlElementStrategy: WebHtmlElementStrategy.fallback,

                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return const SizedBox(
                    width: double.infinity,
                    height: 240,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFE8873A),
                      ),
                    ),
                  );
                },

                errorBuilder: (context, error, stackTrace) {
                  debugPrint('GAGAL MEMUAT GAMBAR: $error');
                  return _imagePlaceholder(context);
                },
              )
            else
              _imagePlaceholder(context),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.recipeName,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    recipe.cuisine ?? 'Masakan lainnya',
                    style: TextStyle(
                      fontSize: 15,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),

                  if (recipe.description != null &&
                      recipe.description!.trim().isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      recipe.description!,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _infoItem(
                          context,
                          Icons.schedule,
                          'Waktu',
                          '$totalTime menit',
                        ),
                        _infoItem(
                          context,
                          Icons.people_outline,
                          'Porsi',
                          '${recipe.servings}',
                        ),
                        _infoItem(
                          context,
                          Icons.bar_chart,
                          'Kesulitan',
                          recipe.difficulty,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  _buildSectionTitle(
                    context,
                    'Bahan-bahan',
                    Icons.shopping_basket_outlined,
                  ),

                  const SizedBox(height: 14),

                  if (ingredients.isEmpty)
                    Text(
                      'Belum ada bahan yang ditambahkan.',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    )
                  else
                    ...ingredients.map(
                      (ingredient) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: Color(0xFFE8873A),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                ingredient,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.4,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  _buildSectionTitle(
                    context,
                    'Cara Memasak',
                    Icons.menu_book_outlined,
                  ),

                  const SizedBox(height: 14),

                  if (instructions.isEmpty)
                    Text(
                      'Belum ada langkah memasak yang ditambahkan.',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    )
                  else
                    ...instructions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final instruction = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8873A),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                instruction,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(icon, color: const Color(0xFFE8873A), size: 23),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _imagePlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: 240,
      color: colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.restaurant, size: 75, color: Color(0xFFE8873A)),
    );
  }
}

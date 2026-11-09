
import 'package:flutter/material.dart';

import '../models/saved_recipe.dart';

class MyRecipeDetailScreen extends StatelessWidget {
  final SavedRecipe recipe;

  const MyRecipeDetailScreen({
    super.key,
    required this.recipe,
  });

  List<String> _getLines(String value) {
    return value
        .split('\n')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFFE8873A),
          size: 23,
        ),
        const SizedBox(width: 9),
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Color(0xFF38251C),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = _getLines(recipe.ingredients);
    final instructions = _getLines(recipe.instructions);
    final totalTime = recipe.prepTime + recipe.cookTime;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        title: const Text('Detail Resep'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe.imageUrl != null &&
                recipe.imageUrl!.isNotEmpty)
              Image.network(
                recipe.imageUrl!,
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return _imagePlaceholder();
                },
              )
            else
              _imagePlaceholder(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.recipeName,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF38251C),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    recipe.cuisine ?? 'Masakan lainnya',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF9B6846),
                    ),
                  ),

                  if (recipe.description != null &&
                      recipe.description!.trim().isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      recipe.description!,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE8D2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                      children: [
                        _infoItem(
                          Icons.schedule,
                          'Waktu',
                          '$totalTime menit',
                        ),
                        _infoItem(
                          Icons.people_outline,
                          'Porsi',
                          '${recipe.servings}',
                        ),
                        _infoItem(
                          Icons.bar_chart,
                          'Kesulitan',
                          recipe.difficulty,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  _buildSectionTitle(
                    'Bahan-bahan',
                    Icons.shopping_basket_outlined,
                  ),

                  const SizedBox(height: 14),

                  if (ingredients.isEmpty)
                    const Text('Belum ada bahan yang ditambahkan.')
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
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  _buildSectionTitle(
                    'Cara Memasak',
                    Icons.menu_book_outlined,
                  ),

                  const SizedBox(height: 14),

                  if (instructions.isEmpty)
                    const Text(
                      'Belum ada langkah memasak yang ditambahkan.',
                    )
                  else
                    ...instructions.asMap().entries.map(
                      (entry) {
                        final index = entry.key;
                        final instruction = entry.value;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
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
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

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
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFF9B6846),
          size: 23,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 240,
      color: const Color(0xFFFFE8D2),
      child: const Icon(
        Icons.restaurant,
        size: 75,
        color: Color(0xFFE8873A),
      ),
    );
  }
}

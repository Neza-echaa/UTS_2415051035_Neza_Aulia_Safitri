import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/recipe.dart';

class RecipeApiService {
  static const String _baseUrl = 'https://dummyjson.com/recipes';

  Future<List<Recipe>> fetchRecipes() async {
    final uri = Uri.parse(_baseUrl);

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final List<dynamic> recipeList = data['recipes'];

        return recipeList
            .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Gagal mengambil resep. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Tidak dapat memuat resep: $e');
    }
  }

  Future<Recipe> fetchRecipeDetail(int id) async {
    final uri = Uri.parse('$_baseUrl/$id');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Recipe.fromJson(data);
      } else {
        throw Exception(
          'Gagal mengambil detail resep. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Tidak dapat memuat detail resep: $e');
    }
  }
}

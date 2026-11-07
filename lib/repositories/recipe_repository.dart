
import '../models/recipe.dart';
import '../services/recipe_api_service.dart';

class RecipeRepository {
  final RecipeApiService _apiService;

  RecipeRepository({RecipeApiService? apiService})
      : _apiService = apiService ?? RecipeApiService();

  Future<List<Recipe>> getRecipes() async {
    return await _apiService.fetchRecipes();
  }

  Future<Recipe> getRecipeDetail(int id) async {
    return await _apiService.fetchRecipeDetail(id);
  }
}

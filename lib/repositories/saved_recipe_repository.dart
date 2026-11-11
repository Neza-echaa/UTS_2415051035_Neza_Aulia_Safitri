import '../models/saved_recipe.dart';
import '../services/supabase_service.dart';

class SavedRecipeRepository {
  final SupabaseService _service;

  SavedRecipeRepository({SupabaseService? service})
    : _service = service ?? SupabaseService();

  Future<List<SavedRecipe>> getSavedRecipes() {
    return _service.fetchSavedRecipes();
  }

  Future<SavedRecipe> createRecipe(SavedRecipe recipe) {
    return _service.addRecipe(recipe);
  }

  Future<SavedRecipe> editRecipe(int id, SavedRecipe recipe) {
    return _service.updateRecipe(id, recipe);
  }

  Future<void> removeRecipe(int id) {
    return _service.deleteRecipe(id);
  }
}


import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/saved_recipe.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<SavedRecipe>> fetchSavedRecipes() async {
    final response = await _client
        .from('saved_recipes')
        .select()
        .order('created_at', ascending: false);

    return response
        .map((item) => SavedRecipe.fromJson(item))
        .toList();
  }

  Future<SavedRecipe> addRecipe(SavedRecipe recipe) async {
    final response = await _client
        .from('saved_recipes')
        .insert(recipe.toJson())
        .select()
        .single();

    return SavedRecipe.fromJson(response);
  }

  Future<SavedRecipe> updateRecipe(
    int id,
    SavedRecipe recipe,
  ) async {
    final response = await _client
        .from('saved_recipes')
        .update(recipe.toJson())
        .eq('id', id)
        .select()
        .single();

    return SavedRecipe.fromJson(response);
  }

  Future<void> deleteRecipe(int id) async {
    await _client
        .from('saved_recipes')
        .delete()
        .eq('id', id);
  }
}

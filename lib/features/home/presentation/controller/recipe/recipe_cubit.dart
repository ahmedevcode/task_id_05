import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/model/recipe_model.dart';

part 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  List<Recipe> recipes = []; // List to hold all recipes

  RecipeCubit() : super(RecipeInitial());

  // Load all recipes (e.g., from API or local storage)
  void loadRecipes() {
    if (recipes.isEmpty) {
      emit(RecipeEmpty());
    } else {
      emit(RecipeLoaded(
          List.from(recipes))); // Use List.from to avoid reference issues
    }
  }

  // Add a new recipe and emit the success state
  void addRecipe(Recipe recipe) {
    recipes.add(recipe); // Mutate the list
    emit(
        RecipeLoaded(List.from(recipes))); // Emit the updated list after adding
  }

  // Filter recipes by a query string (name)
  void filterRecipes(String query) {
    final filteredRecipes = recipes
        .where(
            (recipe) => recipe.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    if (filteredRecipes.isEmpty) {
      emit(RecipeEmpty());
    } else {
      emit(RecipeLoaded(filteredRecipes));
    }
  }
}

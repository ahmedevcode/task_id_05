part of 'recipe_cubit.dart';

@immutable
abstract class RecipeState {}

// Initial state before any recipes are loaded
class RecipeInitial extends RecipeState {}

// State when recipes are being loaded from the source (e.g., API or local storage)
class RecipeLoading extends RecipeState {}

// State when recipes have been successfully loaded
class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;
  RecipeLoaded(this.recipes);
}

// State when no recipes are available
class RecipeEmpty extends RecipeState {}

// State when a recipe is successfully added
class RecipeAddedSuccess extends RecipeState {
  final Recipe recipe;
  RecipeAddedSuccess(this.recipe);
}

// State when an error occurs (e.g., network error, parsing issue)
class RecipeError extends RecipeState {
  final String errorMessage;
  RecipeError(this.errorMessage);
}

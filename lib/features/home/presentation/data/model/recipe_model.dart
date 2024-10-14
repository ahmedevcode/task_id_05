class Recipe {
  final String name;
  final List<String>? ingredients;
  final List<String>? steps;
  final String? imagePath; // Changed from imageUrl to imagePath

  Recipe({
    required this.name,
    this.ingredients,
    this.steps,
    this.imagePath, // Image path (local file or URL)
  });
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_id_05/core/theme/colors.dart';
import 'package:task_id_05/features/home/presentation/controller/recipe/recipe_cubit.dart';
import 'package:task_id_05/features/home/presentation/data/model/recipe_model.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: secondColor, title: Text(recipe.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ListView(
            children: [
              Image.file(
                File(recipe.imagePath!), // Use Image.file for local images
                fit: BoxFit.cover, // Adjust to fit the card
                height: 150, // Set a fixed height for consistent UI
              ),
              const SizedBox(height: 20),
              const Text('Ingredients',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ...?recipe.ingredients?.map((ingredient) => Text(ingredient)),
              const SizedBox(height: 20),
              const Text('Steps',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ...?recipe.steps?.map((step) => Text(step)),
            ],
          ),
        ),
      ),
    );
  }
}

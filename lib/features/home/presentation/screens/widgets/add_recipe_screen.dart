import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_id_05/core/theme/colors.dart';
import 'package:task_id_05/features/home/presentation/controller/recipe/recipe_cubit.dart';

import '../../data/model/recipe_model.dart';
import 'dart:io'; // For File class
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image picker package

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  List<String> ingredients = [];
  List<String> steps = [];
  File? _imageFile; // File for storing the selected image
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  // Method to pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path); // Assign the image to _imageFile
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: secondColor,
        title: const Text('Add Recipe'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Recipe Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the recipe name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Ingredients (comma-separated)'),
                  onSaved: (value) =>
                      ingredients = value!.split(','), // Split by comma
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter ingredients';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Steps (comma-separated)'),
                  onSaved: (value) =>
                      steps = value!.split(','), // Split by comma
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter steps';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50),
                // Display image picker options
                _imageFile == null
                    ? const Text('No image selected')
                    : Image.file(
                        _imageFile!,
                        height: 200,
                        width: 200,
                      ),
                const SizedBox(height: 50),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll<Color>(secondColor)),
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: Text(
                    'Pick Image from Gallery',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save(); // Save all form fields

                      // Ensure an image has been picked before proceeding
                      if (_imageFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please select an image')),
                        );
                        return;
                      }

                      final recipe = Recipe(
                        name: _nameController.text,
                        ingredients: ingredients,
                        steps: steps,
                        imagePath: _imageFile!.path, // Save the local file path
                      );
                      Navigator.pop(context, recipe); // Pass the recipe back
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(secondColor)),
                  child: Text(
                    'Save Recipe',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_id_05/core/theme/colors.dart';
import 'package:task_id_05/features/home/presentation/controller/recipe/recipe_cubit.dart';
import 'package:task_id_05/features/home/presentation/data/model/recipe_model.dart';
import 'package:task_id_05/features/home/presentation/screens/widgets/add_recipe_screen.dart';
import 'package:task_id_05/features/home/presentation/screens/widgets/recipe_details_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Recipe> recipe = [];
  late List<Recipe> searchedForrecipe = [];
  bool isSearching = false;
  final searchTextController = TextEditingController();

  Widget buildSearchFiled() {
    return TextField(
      controller: searchTextController,
      cursorColor: primaryColor,
      decoration: InputDecoration(
        hintText: 'Find a recipe',
        border: InputBorder.none,
        hintStyle: TextStyle(color: primaryColor, fontSize: 18),
      ),
      style: TextStyle(color: primaryColor, fontSize: 18),
      onChanged: (searchedCharacter) {
        addSearchedForItemsToSearchedList(searchedCharacter);
      },
    );
  }

  void addSearchedForItemsToSearchedList(String searchedCharacter) {
    searchedForrecipe = recipe.where((recipe) {
      return recipe.name
          .toLowerCase()
          .contains(searchedCharacter.toLowerCase());
    }).toList();
    setState(() {});
  }

  List<Widget> buildAppBarActions() {
    if (isSearching) {
      return [
        IconButton(
            onPressed: () {
              clearSearch();
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.clear,
              color: primaryColor,
            )),
      ];
    } else {
      return [
        IconButton(
            onPressed: startSearch,
            icon: Icon(
              Icons.search,
              color: primaryColor,
            )),
      ];
    }
  }

  void startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearch));
    setState(() {
      isSearching = true;
    });
  }

  void stopSearch() {
    clearSearch();
    setState(() {
      isSearching = false;
    });
  }

  void clearSearch() {
    setState(() {
      searchTextController.clear();
    });
  }

  Widget buildAppBarTitle() {
    return Text(
      'Recipes',
      style: TextStyle(color: primaryColor, fontSize: 24),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: secondColor,
        title: isSearching ? buildSearchFiled() : buildAppBarTitle(),
        leading: isSearching
            ? BackButton(
                color: primaryColor,
              )
            : Container(),
        actions: buildAppBarActions(),
      ),
      body: BlocBuilder<RecipeCubit, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoaded) {
            recipe = state.recipes; // Assign recipes from state

            // Check if search text is empty, and if searched results are empty.
            final recipesToShow =
                searchTextController.text.isEmpty ? recipe : searchedForrecipe;

            if (recipesToShow.isEmpty) {
              return Center(
                child: Text(
                  'No recipes found.',
                  style: TextStyle(fontSize: 18, color: primaryColor),
                ),
              );
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of items in one row
                childAspectRatio: 3 / 4, // Aspect ratio for each grid item
                crossAxisSpacing: 5, // Horizontal spacing between grid items
                mainAxisSpacing: 1, // Vertical spacing between grid items
              ),
              shrinkWrap: true, // Makes the grid view shrink to fit its content
              padding: EdgeInsets.zero, // No padding around the grid
              physics:
                  const ClampingScrollPhysics(), // Controls scrolling behavior
              itemCount: recipesToShow.length,
              itemBuilder: (context, index) {
                final currentRecipe = recipesToShow[index];

                return GestureDetector(
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RecipeDetailPage(recipe: currentRecipe),
                          ),
                        ),
                    child: Card(
                      color: primaryColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Check if the recipe has a local file or network URL
                          if (currentRecipe.imagePath != null &&
                              currentRecipe.imagePath!.isNotEmpty)
                            Image.file(
                              File(currentRecipe
                                  .imagePath!), // Use Image.file for local images
                              fit: BoxFit.cover, // Adjust to fit the card
                              height:
                                  150, // Set a fixed height for consistent UI
                            )
                          else if (currentRecipe.imagePath != null &&
                              currentRecipe.imagePath!.isNotEmpty)
                            Image.network(
                              currentRecipe
                                  .imagePath!, // Use Image.network for URLs
                              fit: BoxFit.cover,
                              height: 150,
                            )
                          else
                            const SizedBox(
                              height: 150,
                              child: Center(child: Text('No Image Available')),
                            ),
                          Text(
                            currentRecipe.name, // Recipe name
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ));
              },
            );
          } else if (state is RecipeEmpty) {
            return const Center(child: Text('No recipes available.'));
          } else {
            return const Center(child: Text('There are no recipe data yet.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondColor,
        onPressed: () async {
          final newRecipe = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRecipePage()),
          );

          if (newRecipe != null) {
            context.read<RecipeCubit>().addRecipe(newRecipe);
          }
        },
        child: Icon(
          Icons.add,
          opticalSize: 40,
          color: primaryColor,
        ),
      ),
    );
  }
}

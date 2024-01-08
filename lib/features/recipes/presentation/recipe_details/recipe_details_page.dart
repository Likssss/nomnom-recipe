import 'package:flutter/material.dart';
import 'package:NOMNOM/router/router_context_extension.dart';
import 'package:NOMNOM/utils/widgets/add_space.dart';
import '../../../../common/main_button_widget.dart';
import '../../../../constants/string_constants.dart';
import '../../../../theme/theme.dart';
import '../../domain/recipe.dart';
import 'widgets/ingredients_list.dart';
import 'widgets/recipe_description.dart';
import 'widgets/recipe_detail_app_bar.dart';
import 'widgets/recipe_name_and_points.dart';
import 'widgets/subtitle_horizontal_line.dart';

class RecipeDetailsPage extends StatelessWidget {
  const RecipeDetailsPage({super.key, required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: MainButtonWidget(
        label: StringConstants.cook,
        style: TextStyles.mainButton,
        onPressed: () => context.pushStepsPage(recipe: recipe),
        backgorundColor: ThemeColors.primary,
      ),
      body: CustomScrollView(
        slivers: [
          RecipeDetailAppBar(recipe: recipe),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RecipeNameAndPoints(recipe: recipe),
                  recipe.description.isNotEmpty
                      ? RecipeDescription(recipe: recipe)
                      : const SizedBox.shrink(),
                  const SubtitleHorizontalLine(
                      label: StringConstants.ingredients),
                  IngredientsList(recipe: recipe),
                  addVerticalSpace(50),
                ]
                    .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: e,
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

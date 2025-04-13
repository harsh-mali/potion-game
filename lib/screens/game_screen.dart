import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/pixel_background.dart';
import '../widgets/pixel_cauldron.dart';
import '../widgets/pixel_ingredient.dart';
import '../widgets/pixel_icons.dart';
import '../utils/theme_colors.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Timer? _gameTimer;

  @override
  void initState() {
    super.initState();
    _startGameTimer();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  void _startGameTimer() {
    _gameTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final gameState = context.read<GameState>();

      // Check each cauldron
      for (var i = 0; i < gameState.cauldrons.length; i++) {
        final cauldron = gameState.cauldrons[i];
        if (cauldron.isCooking && !cauldron.isBurned) {
          final recipe = gameState.getMatchingRecipe(cauldron.ingredients);
          if (recipe != null) {
            final cookingTime =
                DateTime.now().difference(cauldron.startCookingTime!);
            if (cookingTime >= recipe.cookTime) {
              gameState.addScore(recipe.points);
              gameState.emptyCauldron(i);
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const PixelBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom -
                            80, // Fixed height instead of using preferredSize
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left sidebar - Recipe cards
                            Flexible(
                              flex: 3,
                              child: _buildRecipeList(),
                            ),
                            const SizedBox(width: 16),
                            // Main area - Cauldrons
                            Flexible(
                              flex: 4,
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  _buildCauldrons(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Right sidebar - Ingredients
                            Flexible(
                              flex: 3,
                              child: _buildIngredients(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildTopBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              PixelTheme.darkPurple.withOpacity(0.9),
              PixelTheme.shadowPurple.withOpacity(0.95),
            ],
          ),
          border: Border(
            bottom: BorderSide(
              color: PixelTheme.uiAccent,
              width: 3,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: PixelTheme.shadowPurple.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                PixelPotionIcon(
                  size: 48,
                  color: PixelTheme.candleYellow,
                ),
                const SizedBox(width: 16),
                Text(
                  'Potion Kitchen',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: PixelTheme.candleYellow,
                    shadows: [
                      Shadow(
                        color: PixelTheme.bloodRed,
                        offset: const Offset(3, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                _buildStatusItem(
                  icon: Icons.stars,
                  color: PixelTheme.candleYellow,
                  value: context.watch<GameState>().score.toString(),
                  label: 'Score',
                ),
                const SizedBox(width: 32),
                _buildStatusItem(
                  icon: Icons.favorite,
                  color: PixelTheme.bloodRed,
                  value: context.watch<GameState>().lives.toString(),
                  label: 'Lives',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PixelTheme.uiDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: PixelTheme.uiAccent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: PixelTheme.boneWhite,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: PixelTheme.uiAccent,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeList() {
    return Container(
      decoration: BoxDecoration(
        color: PixelTheme.uiDark.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: PixelTheme.uiAccent,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: PixelTheme.shadowPurple.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: PixelTheme.uiAccent,
                  width: 2,
                ),
              ),
            ),
            child: Row(
              children: [
                PixelBookIcon(
                  size: 32,
                  color: PixelTheme.candleYellow,
                ),
                const SizedBox(width: 12),
                Text(
                  'Recipe Book',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: PixelTheme.boneWhite,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: context.watch<GameState>().activeRecipes.length,
              itemBuilder: (context, index) {
                final recipe = context.watch<GameState>().activeRecipes[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: PixelTheme.uiMid.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: PixelTheme.uiAccent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: PixelTheme.uiDark,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          recipe.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: PixelTheme.candleYellow,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...recipe.ingredients.map((ingredient) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      PixelIngredient(
                                        type: ingredient,
                                        size: 32,
                                        isDraggable: false,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        ingredient,
                                        style: TextStyle(
                                          color: PixelTheme.boneWhite,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            const Divider(
                              color: PixelTheme.uiAccent,
                              height: 24,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      color: PixelTheme.uiAccent,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${recipe.cookTime.inSeconds}s',
                                      style: TextStyle(
                                        color: PixelTheme.boneWhite,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        PixelTheme.poisonGreen.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: PixelTheme.poisonGreen,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    '+${recipe.points}',
                                    style: TextStyle(
                                      color: PixelTheme.poisonGreen,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCauldrons() {
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: BoxDecoration(
        color: PixelTheme.uiDark.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: PixelTheme.uiAccent,
          width: 3,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            context.watch<GameState>().cauldrons.length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DragTarget<String>(
                onWillAccept: (data) => true,
                onAccept: (ingredient) {
                  context
                      .read<GameState>()
                      .addIngredientToCauldron(index, ingredient);
                },
                builder: (context, candidateData, rejectedData) {
                  final cauldron = context.watch<GameState>().cauldrons[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: PixelTheme.uiAccent.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: PixelCauldron(
                          isGlowing: cauldron.isCooking,
                          isCooking: cauldron.isCooking,
                          ingredientCount: cauldron.ingredients.length,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildCauldronButton(
                            onPressed: cauldron.ingredients.isNotEmpty &&
                                    !cauldron.isCooking
                                ? () => context
                                    .read<GameState>()
                                    .startCooking(index)
                                : null,
                            text: 'Cook',
                            icon: Icons.local_fire_department,
                            color: PixelTheme.poisonGreen,
                          ),
                          const SizedBox(width: 12),
                          _buildCauldronButton(
                            onPressed: cauldron.ingredients.isNotEmpty
                                ? () => context
                                    .read<GameState>()
                                    .emptyCauldron(index)
                                : null,
                            text: 'Empty',
                            icon: Icons.delete_outline,
                            color: PixelTheme.bloodRed,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCauldronButton({
    required VoidCallback? onPressed,
    required String text,
    required IconData icon,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: onPressed != null
                ? color.withOpacity(0.2)
                : PixelTheme.uiDark.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: onPressed != null
                  ? color
                  : PixelTheme.uiAccent.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: onPressed != null
                    ? color
                    : PixelTheme.uiAccent.withOpacity(0.5),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: onPressed != null
                      ? PixelTheme.boneWhite
                      : PixelTheme.boneWhite.withOpacity(0.5),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredients() {
    return Container(
      decoration: BoxDecoration(
        color: PixelTheme.uiDark.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: PixelTheme.uiAccent,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: PixelTheme.shadowPurple.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(-4, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: PixelTheme.uiAccent,
                  width: 2,
                ),
              ),
            ),
            child: Row(
              children: [
                PixelInventoryIcon(
                  size: 32,
                  color: PixelTheme.candleYellow,
                ),
                const SizedBox(width: 12),
                Text(
                  'Ingredients',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: PixelTheme.boneWhite,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: context.watch<GameState>().availableIngredients.length,
              itemBuilder: (context, index) {
                final ingredient =
                    context.watch<GameState>().availableIngredients[index];
                return Container(
                  decoration: BoxDecoration(
                    color: PixelTheme.uiMid.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: PixelTheme.uiAccent,
                      width: 2,
                    ),
                  ),
                  child: Draggable<String>(
                    data: ingredient,
                    feedback: PixelIngredient(
                      type: ingredient,
                      size: 80,
                      isGlowing: true,
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: PixelIngredient(
                        type: ingredient,
                        size: 80,
                      ),
                    ),
                    child: PixelIngredient(
                      type: ingredient,
                      size: 80,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

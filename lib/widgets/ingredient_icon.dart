import 'package:flutter/material.dart';

class IngredientIcon extends StatelessWidget {
  final String type;
  final double size;
  final bool isGlowing;

  const IngredientIcon({
    super.key,
    required this.type,
    this.size = 64,
    this.isGlowing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getBaseColor(),
        boxShadow: isGlowing
            ? [
                BoxShadow(
                  color: _getBaseColor().withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Icon(
          _getIcon(),
          color: Colors.white,
          size: size * 0.6,
        ),
      ),
    );
  }

  Color _getBaseColor() {
    switch (type) {
      case 'mushroom':
        return Colors.purple;
      case 'herb':
        return Colors.green;
      case 'crystal':
        return Colors.blue;
      case 'flower':
        return Colors.pink;
      case 'root':
        return Colors.brown;
      case 'berry':
        return Colors.red;
      case 'leaf':
        return Colors.teal;
      case 'gem':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case 'mushroom':
        return Icons.spa;
      case 'herb':
        return Icons.eco;
      case 'crystal':
        return Icons.diamond;
      case 'flower':
        return Icons.local_florist;
      case 'root':
        return Icons.grass;
      case 'berry':
        return Icons.circle;
      case 'leaf':
        return Icons.energy_savings_leaf;
      case 'gem':
        return Icons.auto_awesome;
      default:
        return Icons.help_outline;
    }
  }
}

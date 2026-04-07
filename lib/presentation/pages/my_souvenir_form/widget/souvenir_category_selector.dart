import 'package:flutter/material.dart';
import 'package:test2/domain/entities/souvenir_category.dart';
import 'package:test2/presentation/extensions/souvenir_category_extension.dart';

/// お土産カテゴリセレクター Widget
class SouvenirCategorySelector extends StatelessWidget {
  const SouvenirCategorySelector({
    super.key,
    this.selectedCategory,
    required this.onChanged,
  });

  final SouvenirCategory? selectedCategory;
  final ValueChanged<SouvenirCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('カテゴリ *', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final category in SouvenirCategory.values)
              _CategoryChip(
                category: category,
                isSelected: selectedCategory == category,
                onSelected: () => onChanged(category),
              ),
          ],
        ),
      ],
    );
  }
}

/// カテゴリ選択チップ
class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onSelected,
  });

  final SouvenirCategory category;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: isSelected,
      onSelected: (_) => onSelected(),
      avatar: Icon(category.icon, size: 18, color: category.color),
      label: Text(category.label),
      backgroundColor: Colors.grey[200],
      selectedColor: category.badgeColor,
      labelStyle: TextStyle(
        color: isSelected ? category.color : Colors.black87,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}

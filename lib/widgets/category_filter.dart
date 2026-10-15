import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Kategoriler veriden üretilir; JSON'a yeni bir tür eklenince burada kendiliğinden görünür.
class CategoryFilter extends StatelessWidget {
  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chip('Tümü', null),
          for (final category in categories) _chip(category, category),
        ],
      ),
    );
  }

  Widget _chip(String label, String? value) {
    final isSelected = selected == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        showCheckmark: false,
        onSelected: (_) => onSelected(value),
        backgroundColor: KunyeColors.surface,
        selectedColor: KunyeColors.gold,
        side: const BorderSide(color: KunyeColors.border),
        shape: const StadiumBorder(),
        labelStyle: TextStyle(
          color: isSelected ? KunyeColors.background : KunyeColors.text,
        ),
      ),
    );
  }
}

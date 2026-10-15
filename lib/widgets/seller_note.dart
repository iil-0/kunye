import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Sahafın o nüsha için düştüğü not; kitabın arasına sıkıştırılmış bir kâğıt gibi.
class SellerNote extends StatelessWidget {
  const SellerNote({super.key, required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.012,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: KunyeColors.parchment,
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              color: KunyeColors.shadow.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: DefaultTextStyle.merge(
          style: const TextStyle(color: KunyeColors.parchmentInk),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.edit_note, color: KunyeColors.oxblood),
                SizedBox(width: 6),
                Text(
                  'Sahafın Notu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              note,
              style: const TextStyle(fontStyle: FontStyle.italic, height: 1.5),
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                '— Künye',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: KunyeColors.parchmentMuted,
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}

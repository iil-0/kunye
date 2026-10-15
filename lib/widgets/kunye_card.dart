import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/book.dart';

/// Uygulamaya adını veren kart: eski kütüphane fişlerini andıran bir künye.
class KunyeCard extends StatelessWidget {
  const KunyeCard({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[
      ('Eser', book.title),
      ('Yazar', book.author),
      ('Yayınevi', book.publisher),
      ('Yıl', '${book.year}'),
      ('Baskı', book.edition),
      ('Sayfa', '${book.pages}'),
      ('Tür', book.category),
      ('Durum', '${book.condition.label}. ${book.condition.description}'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: KunyeColors.parchment,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: KunyeColors.parchmentLine),
        boxShadow: [
          BoxShadow(
            color: KunyeColors.shadow.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                const Text(
                  'KÜNYE',
                  style: TextStyle(
                    color: KunyeColors.oxblood,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                const Spacer(),
                Text(
                  'No. ${book.id.toString().padLeft(4, '0')}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: KunyeColors.parchmentMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1.5, color: KunyeColors.oxblood),
          for (final (label, value) in rows)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: KunyeColors.parchmentLine)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 84,
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: KunyeColors.parchmentMuted,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        color: KunyeColors.parchmentInk,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Fişin altındaki delik
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: KunyeColors.background,
                border: Border.all(color: KunyeColors.parchmentLine),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

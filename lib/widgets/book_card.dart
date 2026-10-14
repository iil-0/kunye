import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/book.dart';
import '../utils/formatters.dart';
import 'condition_badge.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.book, required this.onTap});

  final Book book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: KunyeColors.surface,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: KunyeColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'cover-${book.id}',
                    child: Image.asset(book.image, fit: BoxFit.cover),
                  ),
                  if (book.rare)
                    const Positioned(top: 8, left: 8, child: _RareTag()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: KunyeColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        formatPrice(book.price),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: KunyeColors.gold,
                        ),
                      ),
                      const Spacer(),
                      ConditionBadge(condition: book.condition, compact: true),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RareTag extends StatelessWidget {
  const _RareTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: KunyeColors.oxblood,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: KunyeColors.gold, width: 0.8),
      ),
      child: const Text(
        'NADİR',
        style: TextStyle(
          color: KunyeColors.parchment,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

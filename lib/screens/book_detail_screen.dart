import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/book.dart';
import '../utils/formatters.dart';
import '../widgets/condition_badge.dart';
import '../widgets/flip_cover.dart';
import '../widgets/kunye_card.dart';
import '../widgets/seller_note.dart';

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final book = ModalRoute.of(context)!.settings.arguments as Book;
    final theme = Theme.of(context);
    const sectionStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(title: Text(book.category)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Center(
            child: Hero(
              tag: 'cover-${book.id}',
              child: FlipCover(book: book),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Kapağa dokun, arkasını çevir',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: KunyeColors.textMuted,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            book.title,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            book.author,
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: KunyeColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                formatPrice(book.price),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: KunyeColors.gold,
                ),
              ),
              const Spacer(),
              ConditionBadge(condition: book.condition),
            ],
          ),
          if (book.rare) ...[
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.workspace_premium, size: 18, color: KunyeColors.gold),
                SizedBox(width: 6),
                Text(
                  'Nadir bulunan eser',
                  style: TextStyle(color: KunyeColors.gold),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          KunyeCard(book: book),
          const SizedBox(height: 24),
          const Text('Hakkında', style: sectionStyle),
          const SizedBox(height: 6),
          Text(book.description, style: const TextStyle(height: 1.5)),
          if (book.note.isNotEmpty) ...[
            const SizedBox(height: 24),
            SellerNote(note: book.note),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: () => Navigator.pop(context, book),
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Çantaya Ekle'),
          ),
        ),
      ),
    );
  }
}

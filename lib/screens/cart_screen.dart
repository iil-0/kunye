import 'dart:math';

import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/book.dart';
import '../models/cart.dart';
import '../utils/formatters.dart';
import '../widgets/condition_badge.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  /// Bu kadar eser alana el yapımı ayraç hediye.
  static const giftThreshold = 3;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<void> checkout(Cart cart) async {
    final hasGift = cart.count >= CartScreen.giftThreshold;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.auto_stories, color: KunyeColors.gold),
        title: const Text('Kitapların paketleniyor'),
        content: Text(
          'Her kitap, yeni sahibini bulmuş bir hikâye. İyi okumalar!'
          '${hasGift ? '\n\nHediye ayracın da paketin içinde.' : ''}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Raflara dön'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    setState(cart.clear);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cart = ModalRoute.of(context)!.settings.arguments as Cart;

    return Scaffold(
      appBar: AppBar(title: const Text('Çantam')),
      body: cart.isEmpty
          ? const _EmptyCart()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cart.count,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final book = cart.items[index];
                return _CartItem(
                  book: book,
                  onRemove: () => setState(() => cart.remove(book)),
                );
              },
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _GiftProgress(count: cart.count),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text('Toplam · ${cart.count} eser'),
                        const Spacer(),
                        Text(
                          formatPrice(cart.total),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: KunyeColors.gold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => checkout(cart),
                      child: const Text('Satın Al'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _CartItem extends StatelessWidget {
  const _CartItem({required this.book, required this.onRemove});

  final Book book;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: KunyeColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KunyeColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(book.image, width: 52, height: 78, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  book.author,
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: KunyeColors.textMuted,
                  ),
                ),
                const SizedBox(height: 6),
                ConditionBadge(condition: book.condition),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                tooltip: 'Çantadan çıkar',
                onPressed: onRemove,
              ),
              Text(
                formatPrice(book.price),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: KunyeColors.gold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GiftProgress extends StatelessWidget {
  const _GiftProgress({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final remaining = max(0, CartScreen.giftThreshold - count);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: KunyeColors.forest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.bookmark, size: 18, color: KunyeColors.gold),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  remaining > 0
                      ? 'El yapımı deri ayraç hediyesine $remaining eser kaldı.'
                      : 'El yapımı deri ayraç hediyen çantanda!',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: min(count / CartScreen.giftThreshold, 1),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
            color: KunyeColors.gold,
            backgroundColor: KunyeColors.border,
          ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_stories_outlined, size: 64, color: KunyeColors.textMuted),
            const SizedBox(height: 16),
            const Text(
              'Çantan henüz boş',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Raflarda seni bekleyen hikâyeler var.',
              textAlign: TextAlign.center,
              style: TextStyle(color: KunyeColors.textMuted),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Raflara dön'),
            ),
          ],
        ),
      ),
    );
  }
}

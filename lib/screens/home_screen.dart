import 'dart:math';

import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../app/theme.dart';
import '../data/book_repository.dart';
import '../models/book.dart';
import '../models/cart.dart';
import '../models/sort_option.dart';
import '../widgets/book_card.dart';
import '../widgets/category_filter.dart';
import '../widgets/serendipity_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.repository = const AssetBookRepository()});

  final BookRepository repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Cart cart = Cart();
  final Random _random = Random();

  List<Book> books = [];
  bool loading = true;
  String query = '';
  String? category;
  SortOption sort = SortOption.recommended;

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
    final result = await widget.repository.fetchBooks();
    if (!mounted) return;
    setState(() {
      books = result;
      loading = false;
    });
  }

  List<String> get categories => books.map((b) => b.category).toSet().toList();

  List<Book> get visibleBooks {
    final filtered = books
        .where((b) => (category == null || b.category == category) && b.matches(query))
        .toList();
    return sort.apply(filtered);
  }

  Future<void> openDetail(Book book) async {
    final result =
        await Navigator.pushNamed(context, AppRoutes.detail, arguments: book);
    if (result is! Book || !mounted) return;

    final added = cart.add(result);
    setState(() {});
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            added
                ? '"${result.title}" çantana eklendi.'
                : 'Bu nüsha zaten çantanda. Sahafta her kitaptan tek bir tane olur.',
          ),
        ),
      );
  }

  Future<void> openCart() async {
    // Çanta referans olarak gönderilir; sepette yapılan değişiklikler burada da görünür.
    await Navigator.pushNamed(context, AppRoutes.cart, arguments: cart);
    setState(() {});
  }

  void openRandomBook() {
    final pool = visibleBooks.isEmpty ? books : visibleBooks;
    if (pool.isEmpty) return;
    openDetail(pool[_random.nextInt(pool.length)]);
  }

  @override
  Widget build(BuildContext context) {
    final items = visibleBooks;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Künye',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Text(
              'SAHAF',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 4,
                color: KunyeColors.gold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: openCart,
            tooltip: 'Çantam',
            icon: Badge(
              label: Text('${cart.count}'),
              isLabelVisible: !cart.isEmpty,
              backgroundColor: KunyeColors.oxblood,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset('assets/images/banner.png'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Eser ya da yazar ara',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) => setState(() => query = value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _SortButton(
                      value: sort,
                      onSelected: (value) => setState(() => sort = value),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                CategoryFilter(
                  categories: categories,
                  selected: category,
                  onSelected: (value) => setState(() => category = value),
                ),
                const SizedBox(height: 12),
                SerendipityCard(onTap: openRandomBook),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      '${items.length} eser rafta',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: KunyeColors.textMuted,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Divider(color: KunyeColors.border, thickness: 1),
                    ),
                    const SizedBox(width: 8),
                    const Text('❦', style: TextStyle(color: KunyeColors.gold)),
                  ],
                ),
                const SizedBox(height: 8),
                if (items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: Text('Bu rafta aradığın eser yok.')),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.52,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) => BookCard(
                      book: items[index],
                      onTap: () => openDetail(items[index]),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({required this.value, required this.onSelected});

  final SortOption value;
  final ValueChanged<SortOption> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortOption>(
      tooltip: 'Sırala',
      initialValue: value,
      onSelected: onSelected,
      itemBuilder: (context) => [
        for (final option in SortOption.values)
          PopupMenuItem(value: option, child: Text(option.label)),
      ],
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: KunyeColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: KunyeColors.border),
        ),
        child: const Icon(Icons.swap_vert),
      ),
    );
  }
}

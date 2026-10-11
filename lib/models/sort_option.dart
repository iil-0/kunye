import 'book.dart';

enum SortOption {
  recommended('Önerilen'),
  priceAsc('Fiyat: Artan'),
  priceDesc('Fiyat: Azalan'),
  oldest('En eski baskı');

  const SortOption(this.label);

  final String label;

  List<Book> apply(List<Book> books) {
    final sorted = [...books];
    switch (this) {
      case SortOption.recommended:
        break;
      case SortOption.priceAsc:
        sorted.sort((a, b) => a.price.compareTo(b.price));
      case SortOption.priceDesc:
        sorted.sort((a, b) => b.price.compareTo(a.price));
      case SortOption.oldest:
        sorted.sort((a, b) => a.year.compareTo(b.year));
    }
    return sorted;
  }
}

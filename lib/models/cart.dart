import 'book.dart';

/// Kitap çantası. Sahafta her kitaptan tek nüsha olduğu için
/// aynı kitap iki kez eklenemez.
class Cart {
  final List<Book> _items = [];

  List<Book> get items => List.unmodifiable(_items);
  int get count => _items.length;
  bool get isEmpty => _items.isEmpty;
  double get total => _items.fold(0, (sum, book) => sum + book.price);

  bool contains(Book book) => _items.any((b) => b.id == book.id);

  /// Eklendiyse true, kitap zaten çantadaysa false döner.
  bool add(Book book) {
    if (contains(book)) return false;
    _items.add(book);
    return true;
  }

  void remove(Book book) => _items.removeWhere((b) => b.id == book.id);

  void clear() => _items.clear();
}

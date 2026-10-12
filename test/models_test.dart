import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/models/book.dart';
import 'package:mini_katalog/models/book_condition.dart';
import 'package:mini_katalog/models/cart.dart';
import 'package:mini_katalog/utils/formatters.dart';

final _json = {
  'id': 1,
  'title': 'İnce Memed',
  'author': 'Yaşar Kemal',
  'publisher': 'Cem Yayınevi',
  'year': 1975,
  'edition': '1. Cilt',
  'pages': 436,
  'category': 'Roman',
  'condition': 'yipranmis',
  'rare': false,
  'price': 600,
  'image': 'assets/images/b7.png',
  'description': '',
  'note': '',
};

void main() {
  test('Book.fromJson ve toJson birbirini tutar', () {
    final book = Book.fromJson(_json);
    expect(book.condition, BookCondition.worn);
    expect(book.price, 600.0);
    expect(Book.fromJson(book.toJson()).toJson(), book.toJson());
  });

  test('Arama Türkçe harflere duyarsızdır', () {
    final book = Book.fromJson(_json);
    expect(book.matches('ince'), isTrue);
    expect(book.matches('YAŞAR'), isTrue);
    expect(book.matches('tanpınar'), isFalse);
  });

  test('Çantaya aynı nüsha iki kez eklenemez', () {
    final cart = Cart();
    final book = Book.fromJson(_json);
    expect(cart.add(book), isTrue);
    expect(cart.add(book), isFalse);
    expect(cart.count, 1);
    expect(cart.total, 600);
  });

  test('Fiyat binlik ayraçla yazılır', () {
    expect(formatPrice(4500), '₺4.500');
    expect(formatPrice(380), '₺380');
  });
}

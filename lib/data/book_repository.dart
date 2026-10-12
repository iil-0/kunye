import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/book.dart';

/// Kitapların nereden geldiğini ekranlardan saklar.
/// İleride bir API'ye geçmek için yalnızca yeni bir uygulama (ör. ApiBookRepository) yazmak yeter.
abstract class BookRepository {
  Future<List<Book>> fetchBooks();
}

class AssetBookRepository implements BookRepository {
  const AssetBookRepository({this.path = 'assets/data/books.json'});

  final String path;

  @override
  Future<List<Book>> fetchBooks() async {
    final data = await rootBundle.loadString(path);
    final List<dynamic> list = jsonDecode(data);
    return list.map((e) => Book.fromJson(e as Map<String, dynamic>)).toList();
  }
}

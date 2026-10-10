import '../utils/formatters.dart';
import 'book_condition.dart';

class Book {
  final int id;
  final String title;
  final String author;
  final String publisher;
  final int year;
  final String edition;
  final int pages;
  final String category;
  final BookCondition condition;
  final bool rare;
  final double price;
  final String image;
  final String description;
  final String note;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.publisher,
    required this.year,
    required this.edition,
    required this.pages,
    required this.category,
    required this.condition,
    required this.rare,
    required this.price,
    required this.image,
    required this.description,
    required this.note,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
      publisher: json['publisher'] as String? ?? '',
      year: json['year'] as int,
      edition: json['edition'] as String? ?? '',
      pages: json['pages'] as int? ?? 0,
      category: json['category'] as String,
      condition: BookCondition.fromKey(json['condition'] as String?),
      rare: json['rare'] as bool? ?? false,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      description: json['description'] as String? ?? '',
      note: json['note'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'publisher': publisher,
      'year': year,
      'edition': edition,
      'pages': pages,
      'category': category,
      'condition': condition.key,
      'rare': rare,
      'price': price,
      'image': image,
      'description': description,
      'note': note,
    };
  }

  /// Eser adında veya yazarda arama (Türkçe büyük/küçük harf duyarsız).
  bool matches(String query) {
    if (query.trim().isEmpty) return true;
    final q = searchKey(query.trim());
    return searchKey(title).contains(q) || searchKey(author).contains(q);
  }
}

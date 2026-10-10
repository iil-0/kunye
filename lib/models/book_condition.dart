/// İkinci el bir kitabın fiziksel durumu.
/// JSON'daki değer [key] ile eşleşir; yeni bir durum eklemek için buraya bir satır yeter.
enum BookCondition {
  likeNew('yeni_gibi', 'Yeni gibi', 'Neredeyse hiç okunmamış.', 3),
  good('iyi', 'İyi', 'Okunmuş ama özenle saklanmış.', 2),
  worn('yipranmis', 'Yıpranmış', 'Çok sevilmiş; izleri üzerinde.', 1);

  const BookCondition(this.key, this.label, this.description, this.level);

  final String key;
  final String label;
  final String description;

  /// 1 (en yıpranmış) ile 3 (en iyi) arası.
  final int level;

  static BookCondition fromKey(String? key) => BookCondition.values.firstWhere(
        (c) => c.key == key,
        orElse: () => BookCondition.good,
      );
}

/// 4500 -> ₺4.500
String formatPrice(num value) {
  final digits = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '₺$buffer';
}

/// Türkçe harfleri doğru küçülterek arama anahtarı üretir (İ -> i, I -> ı).
String searchKey(String text) =>
    text.replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase();

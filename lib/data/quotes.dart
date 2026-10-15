/// Gezgin kitaba dokununca söylediği dizeler. Yeni bir alıntı = listeye bir satır.
class Quote {
  const Quote(this.text, this.author);

  final String text;
  final String author;
}

const quotes = [
  Quote('İstanbul\'u dinliyorum, gözlerim kapalı.', 'Orhan Veli'),
  Quote('Ne içindeyim zamanın,\nne de büsbütün dışında.', 'Ahmet Hamdi Tanpınar'),
  Quote('Yaşamak bir ağaç gibi tek ve hür\nve bir orman gibi kardeşçesine.', 'Nâzım Hikmet'),
  Quote('Yaş otuz beş! Yolun yarısı eder.', 'Cahit Sıtkı Tarancı'),
  Quote('Sana dün bir tepeden baktım aziz İstanbul!', 'Yahya Kemal'),
  Quote('Sana gitme demeyeceğim.\nÜşüyorsun ceketimi al.', 'Cemal Süreya'),
];

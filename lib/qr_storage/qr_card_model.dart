class QrCard {
  final int id;
  final String title;
  final String imageUrl;
  final String createdAt;

  QrCard({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.createdAt,
  });

  factory QrCard.fromJson(Map<String, dynamic> json) {
    return QrCard(
      id: json['qrCodeId'],
      title: json['title'],
      imageUrl: json['qrCodeImageUrl'],
      createdAt: json['createdAt'],
    );
  }
}

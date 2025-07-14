class ChangelangModal {
  final String localeKey; // e.g., 'en_US', 'hi_IN'
  final Map<String, String> translations; // e.g., {'categories': 'Categories'}

  ChangelangModal({required this.localeKey, required this.translations});

  factory ChangelangModal.fromJson(Map<String, dynamic> json) {
    return ChangelangModal(
      localeKey: json['localeKey'],
      translations: Map<String, String>.from(json['translations']),
    );
  }
}

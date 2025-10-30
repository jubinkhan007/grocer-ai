// New File
class CompareBid {
  final CompareProvider provider;
  final String totalPrice;
  final String discountedPrice;
  final int totalItems;
  final DateTime? deliveryDate; // Added for UI consistency
  final String? deliveryTime; // Added for UI consistency

  CompareBid({
    required this.provider,
    required this.totalPrice,
    required this.discountedPrice,
    required this.totalItems,
    this.deliveryDate,
    this.deliveryTime,
  });

  factory CompareBid.fromJson(Map<String, dynamic> json) {
    return CompareBid(
      provider: CompareProvider.fromJson(json['provider'] ?? {}),
      totalPrice: json['total_price'] ?? '0.00',
      discountedPrice: json['discounted_price'] ?? '0.00',
      totalItems: json['total_items'] ?? 0,
      // API doesn't provide this, so we'll add mock data in controller
      // for UI completeness, or you can remove from UI.
      deliveryDate: null,
      deliveryTime: null,
    );
  }
}

class CompareProvider {
  final int id;
  final String name;
  final String? logo;

  CompareProvider({required this.id, required this.name, this.logo});

  factory CompareProvider.fromJson(Map<String, dynamic> json) {
    return CompareProvider(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Store',
      logo: json['logo'],
    );
  }

  // Helper to map provider name to a local asset
  String get localLogoAsset {
    switch (name.toLowerCase()) {
      case 'walmart':
        return 'assets/images/walmart.png';
      case 'kroger':
        return 'assets/images/kroger.png';
      case 'aldi':
        return 'assets/images/aldi.png';
      case 'fred myers':
        return 'assets/images/fred_meyer.png';
      case 'united supermarkets':
        return 'assets/images/united_supermarket.png';
      default:
        return 'assets/images/store.png'; // Fallback
    }
  }
}

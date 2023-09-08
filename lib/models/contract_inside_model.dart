class SeasonData {
  final int id;
  final String season;
  final List<Category> categories;

  SeasonData({
    required this.id,
    required this.season,
    required this.categories,
  });

  factory SeasonData.fromJson(Map<String, dynamic> json) {
    return SeasonData(
      id: json['id'],
      season: json['season'] ?? '',
      categories: List<Category>.from(
        json['categories'].map((x) => Category.fromJson(x)),
      ),
    );
  }
}

class Category {
  final int id;
  final String? category;
  final List<Contract> contracts;

  Category({
    required this.id,
    this.category,
    required this.contracts,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      category: json['category'],
      contracts: List<Contract>.from(
        json['contracts'].map((x) => Contract.fromJson(x)),
      ),
    );
  }
}

class Contract {
  final String productName;
  final String avgPrice;
  final String count;

  Contract({
    required this.productName,
    required this.avgPrice,
    required this.count,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      productName: json['productName'],
      avgPrice: json['avgPrice'],
      count: json['count'],
    );
  }
}

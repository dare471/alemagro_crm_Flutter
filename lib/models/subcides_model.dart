class SeasonData {
  final int id;
  final String season;
  final List<Category> categories;

  SeasonData(
      {required this.id, required this.season, required this.categories});

  factory SeasonData.fromJson(Map<String, dynamic> json) {
    return SeasonData(
      id: json['id'],
      season: json['season'],
      categories: List<Category>.from(
        json['categories'].map((x) => Category.fromJson(x)),
      ),
    );
  }
}

class Category {
  final int id;
  final String category;
  final List<Contract> contracts;

  Category({required this.id, required this.category, required this.contracts});

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
  final String clientName;
  final String region;
  final String usageArea;
  final String providerName;
  final String productName;
  final String productPrice;
  final String sum;
  final String count;
  final String unit;

  Contract({
    required this.clientName,
    required this.region,
    required this.usageArea,
    required this.providerName,
    required this.productName,
    required this.productPrice,
    required this.sum,
    required this.count,
    required this.unit,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      clientName: json['clientName'],
      region: json['region'],
      usageArea: json['usageArea'],
      providerName: json['providerName'],
      productName: json['productName'],
      productPrice: json['productPrice'],
      sum: json['sum'],
      count: json['count'],
      unit: json['unit'],
    );
  }
}

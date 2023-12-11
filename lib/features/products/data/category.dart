class Category {
  final String id;
  final String name;
  final String image;
  int? v;

  Category({
    required this.id,
    required this.name,
    required this.image,
    int? v,
  }) : v = v ?? 0;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'image': image,
      '__v': v,
    };
  }
}

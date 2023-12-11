// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:grocery_app/features/products/data/category.dart';

enum SortState {
  asc,
  desc,
}

class Filters {
  final Category? category;
  final SortState? priceSort;
  final SortState? ratingSort;
  final bool? isVeg;
  Filters({
    this.category,
    this.priceSort,
    this.ratingSort,
    this.isVeg,
  });
}

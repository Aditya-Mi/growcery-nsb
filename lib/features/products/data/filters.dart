enum SortState {
  asc,
  desc,
}

class Filters {
  final String? category;
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

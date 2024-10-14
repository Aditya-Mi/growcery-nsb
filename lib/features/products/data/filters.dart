enum SortState {
  asc,
  desc,
}

class Filters {
  final String? category;
  final SortState? priceSort;
  final SortState? ratingSort;
  Filters({
    this.category,
    this.priceSort,
    this.ratingSort,
  });
}

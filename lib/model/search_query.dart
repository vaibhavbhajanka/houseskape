class SearchQuery {
  final String? location;
  final num? minRent;
  final num? maxRent;
  final int? minBedrooms;
  final int? minBathrooms;
  final String? text;
  final String? propertyType;

  const SearchQuery({
    this.location,
    this.minRent,
    this.maxRent,
    this.minBedrooms,
    this.minBathrooms,
    this.text,
    this.propertyType,
  });

  SearchQuery copyWith({
    String? location,
    num? minRent,
    num? maxRent,
    int? minBedrooms,
    int? minBathrooms,
    String? text,
    String? propertyType,
  }) {
    return SearchQuery(
      location: location ?? this.location,
      minRent: minRent ?? this.minRent,
      maxRent: maxRent ?? this.maxRent,
      minBedrooms: minBedrooms ?? this.minBedrooms,
      minBathrooms: minBathrooms ?? this.minBathrooms,
      text: text ?? this.text,
      propertyType: propertyType ?? this.propertyType,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchQuery &&
          runtimeType == other.runtimeType &&
          location == other.location &&
          minRent == other.minRent &&
          maxRent == other.maxRent &&
          minBedrooms == other.minBedrooms &&
          minBathrooms == other.minBathrooms &&
          text == other.text &&
          propertyType == other.propertyType;

  @override
  int get hashCode => Object.hash(
        location,
        minRent,
        maxRent,
        minBedrooms,
        minBathrooms,
        text,
        propertyType,
      );

  @override
  String toString() {
    return 'SearchQuery(location: $location, minRent: $minRent, maxRent: $maxRent, minBedrooms: $minBedrooms, minBathrooms: $minBathrooms, text: $text, propertyType: $propertyType)';
  }
} 
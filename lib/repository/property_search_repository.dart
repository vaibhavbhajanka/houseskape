import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houseskape/model/search_query.dart';
import 'package:houseskape/model/property_model.dart';

/// A very small search repository that turns a [SearchQuery] into a
/// Firestore query and yields a stream of matching [Property] objects.
///
/// This is phase-1 of the unified search revamp; additional fields (text
/// search, bounds filtering, pagination, etc.) can be layered on later
/// without changing the consumer interface.
class PropertySearchRepository {
  final _collection = FirebaseFirestore.instance.collection('properties');

  Stream<List<Property>> watchProperties(SearchQuery query) {
    Query<Map<String, dynamic>> q = _collection;

    // Location (city) equality filter – most common use-case today.
    if (query.location != null && query.location!.isNotEmpty) {
      q = q.where('location', isEqualTo: query.location);
    }

    // Min / Max rent
    if (query.minRent != null) {
      q = q.where('monthlyRent', isGreaterThanOrEqualTo: query.minRent);
    }
    if (query.maxRent != null) {
      q = q.where('monthlyRent', isLessThanOrEqualTo: query.maxRent);
    }

    // Bedrooms / Bathrooms (gte filters)
    if (query.minBedrooms != null) {
      q = q.where('bedrooms', isGreaterThanOrEqualTo: query.minBedrooms);
    }
    if (query.minBathrooms != null) {
      q = q.where('bathrooms', isGreaterThanOrEqualTo: query.minBathrooms);
    }

    // Property type equality
    if (query.propertyType != null && query.propertyType!.isNotEmpty) {
      q = q.where('type', isEqualTo: query.propertyType);
    }

    // NOTE: Firestore composite indexes will be required for most
    // combinations of the above where() clauses. These will be added in the
    // Firebase console after the first query failure message.

    return q
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => Property.fromMap(doc.data(), id: doc.id))
            .toList());
  }
} 
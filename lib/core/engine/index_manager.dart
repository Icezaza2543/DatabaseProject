/// Relational Database Indexing Engine Simulation
/// Demonstrates Primary Hash Index (O(1)) & Secondary Non-Clustered Indexes (Inverted Lists)
class IndexManager<T> {
  // Primary Key Hash Index: PK -> Object Pointer
  final Map<String, T> _primaryIndex = {};

  // Secondary Non-Clustered Indexes: IndexName -> (FieldValue -> Set of PKs)
  final Map<String, Map<String, Set<String>>> _secondaryIndexes = {};

  Map<String, T> get primaryIndex => Map.unmodifiable(_primaryIndex);

  /// Register a secondary index (e.g. 'major', 'departmentId')
  void createSecondaryIndex(String indexName) {
    if (!_secondaryIndexes.containsKey(indexName)) {
      _secondaryIndexes[indexName] = {};
    }
  }

  /// Insert or Update Primary and Secondary Indexes
  void insert(String pk, T entity, Map<String, String> secondaryFields) {
    _primaryIndex[pk] = entity;

    // Update Secondary Indexes
    secondaryFields.forEach((indexName, fieldValue) {
      if (_secondaryIndexes.containsKey(indexName)) {
        _secondaryIndexes[indexName]!
            .putIfAbsent(fieldValue, () => {})
            .add(pk);
      }
    });
  }

  /// O(1) Primary Key Lookup
  T? lookupByPk(String pk) {
    return _primaryIndex[pk];
  }

  /// Secondary Index Lookup using Inverted List
  List<T> lookupBySecondaryIndex(String indexName, String fieldValue) {
    if (!_secondaryIndexes.containsKey(indexName)) return [];
    final pks = _secondaryIndexes[indexName]![fieldValue] ?? {};
    return pks.map((pk) => _primaryIndex[pk]!).whereType<T>().toList();
  }

  /// Delete from Primary & Secondary Indexes
  void remove(String pk, Map<String, String> secondaryFields) {
    _primaryIndex.remove(pk);

    secondaryFields.forEach((indexName, fieldValue) {
      if (_secondaryIndexes.containsKey(indexName) &&
          _secondaryIndexes[indexName]!.containsKey(fieldValue)) {
        _secondaryIndexes[indexName]![fieldValue]!.remove(pk);
        if (_secondaryIndexes[indexName]![fieldValue]!.isEmpty) {
          _secondaryIndexes[indexName]!.remove(fieldValue);
        }
      }
    });
  }

  void clear() {
    _primaryIndex.clear();
    _secondaryIndexes.forEach((_, map) => map.clear());
  }
}

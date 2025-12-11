import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';

import 'cache_strategy.dart';

/// Manager for caching network responses
class CacheManager {
  CacheManager({
    this.boxName = 'network_cache',
  });

  /// Name of the Hive box for caching
  final String boxName;

  /// Hive box instance
  Box<String>? _box;

  /// Initialize the cache manager
  Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<String>(boxName);
    }
  }

  /// Ensure box is initialized
  Future<Box<String>> _getBox() async {
    if (_box == null || !_box!.isOpen) {
      await init();
    }
    return _box!;
  }

  /// Generate a cache key from URL and parameters
  String generateKey(String url, {Map<String, dynamic>? queryParameters}) {
    final buffer = StringBuffer(url);
    if (queryParameters != null && queryParameters.isNotEmpty) {
      final sortedKeys = queryParameters.keys.toList()..sort();
      for (final key in sortedKeys) {
        buffer.write('&$key=${queryParameters[key]}');
      }
    }
    final bytes = utf8.encode(buffer.toString());
    return md5.convert(bytes).toString();
  }

  /// Get cached data
  Future<CacheEntry?> get(String key) async {
    final box = await _getBox();
    final jsonString = box.get(key);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return CacheEntry.fromJson(json);
    } catch (e) {
      await delete(key);
      return null;
    }
  }

  /// Store data in cache
  Future<void> put(
    String key,
    String data, {
    Duration maxAge = const Duration(minutes: 5),
    String? eTag,
    String? lastModified,
  }) async {
    final box = await _getBox();
    final entry = CacheEntry(
      data: data,
      createdAt: DateTime.now(),
      maxAge: maxAge,
      eTag: eTag,
      lastModified: lastModified,
    );
    await box.put(key, jsonEncode(entry.toJson()));
  }

  /// Delete a cached entry
  Future<void> delete(String key) async {
    final box = await _getBox();
    await box.delete(key);
  }

  /// Clear all cached data
  Future<void> clear() async {
    final box = await _getBox();
    await box.clear();
  }

  /// Delete expired entries
  Future<int> deleteExpired() async {
    final box = await _getBox();
    var deletedCount = 0;

    final keysToDelete = <dynamic>[];
    for (final key in box.keys) {
      final jsonString = box.get(key);
      if (jsonString == null) continue;

      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final entry = CacheEntry.fromJson(json);
        if (entry.isExpired) {
          keysToDelete.add(key);
        }
      } catch (e) {
        keysToDelete.add(key);
      }
    }

    for (final key in keysToDelete) {
      await box.delete(key);
      deletedCount++;
    }

    return deletedCount;
  }

  /// Get cache statistics
  Future<CacheStats> getStats() async {
    final box = await _getBox();
    var totalEntries = 0;
    var expiredEntries = 0;
    var totalSize = 0;

    for (final key in box.keys) {
      final jsonString = box.get(key);
      if (jsonString == null) continue;

      totalEntries++;
      totalSize += jsonString.length;

      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final entry = CacheEntry.fromJson(json);
        if (entry.isExpired) {
          expiredEntries++;
        }
      } catch (e) {
        expiredEntries++;
      }
    }

    return CacheStats(
      totalEntries: totalEntries,
      expiredEntries: expiredEntries,
      validEntries: totalEntries - expiredEntries,
      totalSizeBytes: totalSize,
    );
  }

  /// Close the cache
  Future<void> close() async {
    await _box?.close();
    _box = null;
  }
}

/// Cache statistics
class CacheStats {
  const CacheStats({
    required this.totalEntries,
    required this.expiredEntries,
    required this.validEntries,
    required this.totalSizeBytes,
  });

  final int totalEntries;
  final int expiredEntries;
  final int validEntries;
  final int totalSizeBytes;

  double get totalSizeKB => totalSizeBytes / 1024;
  double get totalSizeMB => totalSizeKB / 1024;

  @override
  String toString() {
    return 'CacheStats(total: $totalEntries, valid: $validEntries, expired: $expiredEntries, size: ${totalSizeKB.toStringAsFixed(2)} KB)';
  }
}

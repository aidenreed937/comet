/// Cache strategy for network requests
enum CacheStrategy {
  /// Only fetch from network, don't use cache
  networkOnly,

  /// Only fetch from cache, don't use network
  cacheOnly,

  /// Try cache first, fallback to network if cache miss or expired
  cacheFirst,

  /// Try network first, fallback to cache if network fails
  networkFirst,

  /// Use cache if available (even if expired), then refresh from network
  staleWhileRevalidate,
}

/// Cache entry metadata
class CacheEntry {
  const CacheEntry({
    required this.data,
    required this.createdAt,
    required this.maxAge,
    this.eTag,
    this.lastModified,
  });

  /// Create from JSON map
  factory CacheEntry.fromJson(Map<String, dynamic> json) {
    return CacheEntry(
      data: json['data'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      maxAge: Duration(seconds: json['maxAge'] as int),
      eTag: json['eTag'] as String?,
      lastModified: json['lastModified'] as String?,
    );
  }

  /// The cached data
  final String data;

  /// When the cache was created
  final DateTime createdAt;

  /// Maximum age of the cache in seconds
  final Duration maxAge;

  /// ETag for conditional requests
  final String? eTag;

  /// Last-Modified header for conditional requests
  final String? lastModified;

  /// Check if the cache entry is expired
  bool get isExpired {
    final expiresAt = createdAt.add(maxAge);
    return DateTime.now().isAfter(expiresAt);
  }

  /// Check if the cache entry is still valid
  bool get isValid => !isExpired;

  /// Time until expiration
  Duration get timeUntilExpiration {
    final expiresAt = createdAt.add(maxAge);
    final now = DateTime.now();
    if (now.isAfter(expiresAt)) {
      return Duration.zero;
    }
    return expiresAt.difference(now);
  }

  /// Convert to JSON map for storage
  Map<String, dynamic> toJson() => {
    'data': data,
    'createdAt': createdAt.toIso8601String(),
    'maxAge': maxAge.inSeconds,
    'eTag': eTag,
    'lastModified': lastModified,
  };
}

/// Options for cache behavior
class CacheOptions {
  const CacheOptions({
    this.strategy = CacheStrategy.networkFirst,
    this.maxAge = const Duration(minutes: 5),
    this.forceRefresh = false,
    this.shouldCache,
  });

  /// The caching strategy to use
  final CacheStrategy strategy;

  /// Maximum age of cached data
  final Duration maxAge;

  /// Force refresh from network, ignoring cache
  final bool forceRefresh;

  /// Custom function to determine if response should be cached
  /// Returns true if the response should be cached
  final bool Function(int statusCode)? shouldCache;

  /// Default cache options
  static const CacheOptions defaults = CacheOptions();

  /// No caching
  static const CacheOptions noCache = CacheOptions(
    strategy: CacheStrategy.networkOnly,
  );

  /// Cache first with 1 hour max age
  static const CacheOptions longCache = CacheOptions(
    strategy: CacheStrategy.cacheFirst,
    maxAge: Duration(hours: 1),
  );

  /// Stale-while-revalidate with 5 minutes max age
  static const CacheOptions staleWhileRevalidate = CacheOptions(
    strategy: CacheStrategy.staleWhileRevalidate,
  );

  /// Create a copy with modified values
  CacheOptions copyWith({
    CacheStrategy? strategy,
    Duration? maxAge,
    bool? forceRefresh,
    bool Function(int statusCode)? shouldCache,
  }) {
    return CacheOptions(
      strategy: strategy ?? this.strategy,
      maxAge: maxAge ?? this.maxAge,
      forceRefresh: forceRefresh ?? this.forceRefresh,
      shouldCache: shouldCache ?? this.shouldCache,
    );
  }
}

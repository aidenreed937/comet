class Counter {
  const Counter({required this.value});

  final int value;

  Counter copyWith({int? value}) {
    return Counter(value: value ?? this.value);
  }

  Counter increment() => Counter(value: value + 1);

  Counter decrement() => Counter(value: value - 1);

  Counter reset() => const Counter(value: 0);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Counter && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Counter(value: $value)';
}

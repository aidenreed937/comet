import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/counter_provider.dart';

class CounterView extends ConsumerWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterControllerProvider);
    final l10n = context.l10n;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.currentValue(counter.value),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: 'decrement',
              onPressed: () {
                ref.read(counterControllerProvider.notifier).decrement();
              },
              tooltip: l10n.decrement,
              child: const Icon(Icons.remove),
            ),
            const SizedBox(width: AppSpacing.md),
            FloatingActionButton(
              heroTag: 'increment',
              onPressed: () {
                ref.read(counterControllerProvider.notifier).increment();
              },
              tooltip: l10n.increment,
              child: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton.icon(
          onPressed: () {
            ref.read(counterControllerProvider.notifier).reset();
          },
          icon: const Icon(Icons.refresh),
          label: Text(l10n.reset),
        ),
      ],
    );
  }
}

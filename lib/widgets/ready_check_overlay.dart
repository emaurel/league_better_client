import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/gameflow_provider.dart';
import '../providers/lcu_actions.dart';
import '../theme/app_colors.dart';
import '../theme/league_decorations.dart';

class ReadyCheckOverlay extends ConsumerWidget {
  const ReadyCheckOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readyCheck = ref.watch(readyCheckProvider).valueOrNull;
    if (readyCheck == null || !readyCheck.isActive) {
      return const SizedBox.shrink();
    }

    final actions = ref.watch(lcuActionsProvider);
    final accepted = readyCheck.playerResponse == 'Accepted';
    final declined = readyCheck.playerResponse == 'Declined';

    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.74),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: LeaguePanel(
              title: 'Match Found',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    accepted
                        ? 'WAITING FOR OTHERS'
                        : declined
                            ? 'DECLINED'
                            : 'ACCEPT THE MATCH',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your queue has popped.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: accepted || declined
                            ? null
                            : actions.acceptReadyCheck,
                        child: const Text('ACCEPT'),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: declined
                            ? null
                            : actions.declineReadyCheck,
                        child: const Text('DECLINE'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

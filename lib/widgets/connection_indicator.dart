import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../lcu/lcu_connector.dart';
import '../providers/lcu_providers.dart';
import '../theme/app_colors.dart';

class ConnectionIndicator extends ConsumerWidget {
  const ConnectionIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lcuConnectionStateProvider).valueOrNull;
    final status = state?.status ?? LcuStatus.idle;
    final (label, color) = switch (status) {
      LcuStatus.connected => ('Connected', AppColors.online),
      LcuStatus.connecting => ('Connecting…', AppColors.warn),
      LcuStatus.searching => ('Looking for client…', AppColors.warn),
      LcuStatus.disconnected => ('Disconnected', AppColors.offline),
      LcuStatus.error => ('Error', AppColors.negative),
      LcuStatus.idle => ('Idle', AppColors.offline),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Dot(color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 1.0,
              ),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 6),
        ],
      ),
    );
  }
}

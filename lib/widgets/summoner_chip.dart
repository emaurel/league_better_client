import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/summoner.dart';
import '../providers/summoner_providers.dart';
import '../theme/app_colors.dart';
import 'lcu_image.dart';

class SummonerChip extends ConsumerWidget {
  const SummonerChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summoner = ref.watch(currentSummonerProvider).valueOrNull;
    if (summoner == null) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Icon(summoner: summoner),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              summoner.rifleName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.goldLight,
                    height: 1.0,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Level ${summoner.summonerLevel}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.gold,
                    letterSpacing: 1.2,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({required this.summoner});
  final Summoner summoner;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gold, width: 1.4),
        color: AppColors.navy,
      ),
      child: ClipRect(
        child: LcuImage(
          path: '/lol-game-data/assets/v1/profile-icons/${summoner.profileIconId}.jpg',
        ),
      ),
    );
  }
}

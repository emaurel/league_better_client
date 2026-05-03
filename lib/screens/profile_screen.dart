import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ranked_stats.dart';
import '../models/summoner.dart';
import '../providers/summoner_providers.dart';
import '../theme/app_colors.dart';
import '../theme/league_decorations.dart';
import '../widgets/lcu_image.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summoner = ref.watch(currentSummonerProvider).valueOrNull;
    final ranked = ref.watch(rankedStatsProvider).valueOrNull;

    if (summoner == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SummonerBanner(summoner: summoner),
          const SizedBox(height: 24),
          if (ranked != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _RankCard(label: 'Solo / Duo', stats: ranked.soloDuo)),
                const SizedBox(width: 16),
                Expanded(child: _RankCard(label: 'Flex 5v5', stats: ranked.flex)),
              ],
            ),
        ],
      ),
    );
  }
}

class _SummonerBanner extends StatelessWidget {
  const _SummonerBanner({required this.summoner});
  final Summoner summoner;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: leaguePanel(),
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.gold, width: 2),
            ),
            child: ClipRect(
              child: LcuImage(
                path: '/lol-game-data/assets/v1/profile-icons/${summoner.profileIconId}.jpg',
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  summoner.rifleName,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Level ${summoner.summonerLevel}',
                  style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.gold,
                      ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  child: SizedBox(
                    height: 6,
                    child: LinearProgressIndicator(
                      value: summoner.levelProgress.clamp(0.0, 1.0),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${summoner.xpSinceLastLevel} / '
                  '${summoner.xpSinceLastLevel + summoner.xpUntilNextLevel} XP',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RankCard extends StatelessWidget {
  const _RankCard({required this.label, required this.stats});
  final String label;
  final RankedQueueStats? stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LeaguePanel(
      title: label,
      child: stats == null || stats!.isUnranked
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Unranked',
                style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stats!.displayRank,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  '${stats!.wins}W / ${stats!.losses}L · '
                  '${(stats!.winRate * 100).toStringAsFixed(0)}% WR',
                  style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
    );
  }
}

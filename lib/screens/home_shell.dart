import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/gameflow.dart';
import '../providers/champ_select_provider.dart';
import '../providers/gameflow_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/connection_indicator.dart';
import '../widgets/nav_rail.dart';
import '../widgets/ready_check_overlay.dart';
import '../widgets/summoner_chip.dart';
import 'champ_select_screen.dart';
import 'champions_screen.dart';
import 'friends_screen.dart';
import 'play_screen.dart';
import 'profile_screen.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _selected = 0;

  static const _items = [
    NavItem(icon: Icons.sports_esports, label: 'Play'),
    NavItem(icon: Icons.person_outline, label: 'Profile'),
    NavItem(icon: Icons.shield_outlined, label: 'Champions'),
    NavItem(icon: Icons.group_outlined, label: 'Friends'),
  ];

  @override
  Widget build(BuildContext context) {
    final phase = ref.watch(gameflowPhaseProvider).valueOrNull;
    final inChampSelect = phase == GameflowPhase.champSelect &&
        ref.watch(champSelectProvider).valueOrNull != null;

    final body = inChampSelect
        ? const ChampSelectScreen()
        : switch (_selected) {
            0 => const PlayScreen(),
            1 => const ProfileScreen(),
            2 => const ChampionsScreen(),
            3 => const FriendsScreen(),
            _ => const PlayScreen(),
          };

    return Scaffold(
      backgroundColor: AppColors.hextechBlack,
      body: Stack(
        children: [
          Column(
            children: [
              const _TopBar(),
              Expanded(
                child: Row(
                  children: [
                    if (!inChampSelect)
                      LeagueNavRail(
                        items: _items,
                        selectedIndex: _selected,
                        onSelected: (i) => setState(() => _selected = i),
                      ),
                    Expanded(child: body),
                  ],
                ),
              ),
            ],
          ),
          const ReadyCheckOverlay(),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.deepNavy,
        border: Border(
          bottom: BorderSide(color: AppColors.goldMid.withValues(alpha: 0.6)),
        ),
      ),
      child: Row(
        children: [
          Text(
            'LEAGUE BETTER CLIENT',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  letterSpacing: 3,
                  color: AppColors.gold,
                ),
          ),
          const Spacer(),
          const ConnectionIndicator(),
          const SizedBox(width: 24),
          const SummonerChip(),
        ],
      ),
    );
  }
}

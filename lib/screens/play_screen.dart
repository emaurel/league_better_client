import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/gameflow.dart';
import '../providers/gameflow_provider.dart';
import '../providers/lcu_actions.dart';
import '../providers/lobby_provider.dart';
import '../theme/app_colors.dart';
import '../theme/league_decorations.dart';
import 'lobby_screen.dart';

class PlayScreen extends ConsumerWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phase = ref.watch(gameflowPhaseProvider).valueOrNull;
    final lobby = ref.watch(lobbyProvider).valueOrNull;

    if (phase == GameflowPhase.matchmaking) {
      return const _Matchmaking();
    }
    if (lobby != null) {
      return const LobbyScreen();
    }
    return const _QueuePicker();
  }
}

class _QueueOption {
  const _QueueOption({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });
  final int id;
  final String name;
  final String description;
  final IconData icon;
}

const _queues = <_QueueOption>[
  _QueueOption(
    id: 420,
    name: 'Ranked Solo/Duo',
    description: 'Summoner\'s Rift · 5v5 · Ladder',
    icon: Icons.military_tech_outlined,
  ),
  _QueueOption(
    id: 440,
    name: 'Ranked Flex',
    description: 'Summoner\'s Rift · 5v5 · Up to 5-stack',
    icon: Icons.shield_moon_outlined,
  ),
  _QueueOption(
    id: 400,
    name: 'Normal Draft',
    description: 'Summoner\'s Rift · 5v5 · Pick & Ban',
    icon: Icons.casino_outlined,
  ),
  _QueueOption(
    id: 490,
    name: 'Quickplay',
    description: 'Summoner\'s Rift · 5v5 · Fastest queue',
    icon: Icons.bolt_outlined,
  ),
  _QueueOption(
    id: 450,
    name: 'ARAM',
    description: 'Howling Abyss · 5v5 · Random champ',
    icon: Icons.ac_unit_outlined,
  ),
  _QueueOption(
    id: 1700,
    name: 'Arena',
    description: 'Rings of Wrath · 2v2v2v2',
    icon: Icons.flash_on_outlined,
  ),
  // Sentinel id for "Custom Game" — handled separately by the picker.
  _QueueOption(
    id: -1,
    name: 'Custom Game',
    description: 'Summoner\'s Rift · 5v5 Tournament Draft · No matchmaking',
    icon: Icons.science_outlined,
  ),
];

class _QueuePicker extends ConsumerWidget {
  const _QueuePicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.watch(lcuActionsProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PLAY',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  letterSpacing: 4,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose your queue.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, c) {
              final cols = c.maxWidth > 1100
                  ? 3
                  : c.maxWidth > 720
                      ? 2
                      : 1;
              return GridView.count(
                crossAxisCount: cols,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.6,
                children: [
                  for (final q in _queues)
                    _QueueCard(
                      option: q,
                      onTap: () => q.id == -1
                          ? actions.createCustomLobby()
                          : actions.createLobby(q.id),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _QueueCard extends StatefulWidget {
  const _QueueCard({required this.option, required this.onTap});
  final _QueueOption option;
  final VoidCallback onTap;

  @override
  State<_QueueCard> createState() => _QueueCardState();
}

class _QueueCardState extends State<_QueueCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          decoration: leaguePanel(
            borderColor: _hovered ? AppColors.gold : AppColors.goldMid,
            borderWidth: _hovered ? 1.4 : 1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.goldMid),
                  color: AppColors.deepNavy,
                ),
                child: Icon(widget.option.icon, color: AppColors.gold),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.option.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.option.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: _hovered ? AppColors.goldLight : AppColors.goldMid,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Matchmaking extends ConsumerWidget {
  const _Matchmaking();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.watch(lcuActionsProvider);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: LeaguePanel(
            title: 'Searching',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                const SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'LOOKING FOR MATCH',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        letterSpacing: 2,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Estimated wait time depends on your queue.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: actions.stopMatchmaking,
                  child: const Text('CANCEL'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

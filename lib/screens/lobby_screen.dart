import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/lobby.dart';
import '../providers/lcu_actions.dart';
import '../providers/lobby_provider.dart';
import '../theme/app_colors.dart';
import '../theme/league_decorations.dart';

class LobbyScreen extends ConsumerWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lobby = ref.watch(lobbyProvider).valueOrNull;
    if (lobby == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final actions = ref.watch(lcuActionsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(lobby: lobby),
          const SizedBox(height: 24),
          LeaguePanel(
            title: 'Party (${lobby.members.length}/${lobby.gameConfig.maxLobbySize})',
            child: Column(
              children: [
                for (final m in lobby.members) _MemberTile(member: m),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              ElevatedButton(
                onPressed: lobby.canStartActivity ? actions.startMatchmaking : null,
                child: const Text('FIND MATCH'),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: actions.leaveLobby,
                child: const Text('LEAVE LOBBY'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.lobby});
  final Lobby lobby;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LOBBY',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                letterSpacing: 4,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Queue ${lobby.gameConfig.queueId} · ${lobby.gameConfig.gameMode}'
          '${lobby.gameConfig.isCustom ? " · Custom" : ""}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member});
  final LobbyMember member;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.deepNavy,
              border: Border.all(
                color: member.isLeader ? AppColors.gold : AppColors.goldMid,
              ),
            ),
            child: const Icon(Icons.person, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.displayName.isEmpty ? 'Summoner' : member.displayName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (member.firstPositionPreference.isNotEmpty)
                  Text(
                    '${member.firstPositionPreference} / ${member.secondPositionPreference}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          if (member.isLeader)
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.star, color: AppColors.gold, size: 18),
            ),
        ],
      ),
    );
  }
}

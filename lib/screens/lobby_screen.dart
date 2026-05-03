import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/lobby.dart';
import '../providers/lcu_actions.dart';
import '../providers/lobby_provider.dart';
import '../theme/app_colors.dart';
import '../theme/league_decorations.dart';

class LobbyScreen extends ConsumerStatefulWidget {
  const LobbyScreen({super.key});

  @override
  ConsumerState<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends ConsumerState<LobbyScreen> {
  bool _busy = false;
  String? _statusLine;

  Future<void> _run(Future<void> Function() op, String runningLabel) async {
    setState(() {
      _busy = true;
      _statusLine = runningLabel;
    });
    try {
      await op();
      if (mounted) setState(() => _statusLine = null);
    } catch (e) {
      if (mounted) setState(() => _statusLine = 'Error: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lobby = ref.watch(lobbyProvider).valueOrNull;
    if (lobby == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final actions = ref.watch(lcuActionsProvider);
    final isCustom = lobby.gameConfig.isCustom;

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
          if (isCustom)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  onPressed: _busy
                      ? null
                      : () => _run(
                            () async {
                              await actions
                                  .fillCustomLobbyWithBots(teamSize: 5);
                              await Future.delayed(
                                const Duration(milliseconds: 600),
                              );
                              await actions.startCustomChampSelect();
                            },
                            'Filling bots and starting champ select…',
                          ),
                  child: const Text('FILL & START CHAMP SELECT'),
                ),
                OutlinedButton(
                  onPressed: _busy
                      ? null
                      : () => _run(
                            () => actions.addBot(teamId: '100'),
                            'Adding ally bot…',
                          ),
                  child: const Text('ADD ALLY BOT'),
                ),
                OutlinedButton(
                  onPressed: _busy
                      ? null
                      : () => _run(
                            () => actions.addBot(teamId: '200'),
                            'Adding enemy bot…',
                          ),
                  child: const Text('ADD ENEMY BOT'),
                ),
                OutlinedButton(
                  onPressed: _busy
                      ? null
                      : () => _run(
                            actions.startCustomChampSelect,
                            'Starting champ select…',
                          ),
                  child: const Text('START CHAMP SELECT'),
                ),
                OutlinedButton(
                  onPressed: _busy ? null : actions.leaveLobby,
                  child: const Text('LEAVE LOBBY'),
                ),
              ],
            )
          else
            Row(
              children: [
                ElevatedButton(
                  onPressed: lobby.canStartActivity
                      ? actions.startMatchmaking
                      : null,
                  child: const Text('FIND MATCH'),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: actions.leaveLobby,
                  child: const Text('LEAVE LOBBY'),
                ),
              ],
            ),
          if (_statusLine != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                _statusLine!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _statusLine!.startsWith('Error')
                          ? AppColors.negative
                          : AppColors.gold,
                    ),
              ),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/friend.dart';
import '../providers/champions_provider.dart';
import '../providers/friends_provider.dart';
import '../theme/app_colors.dart';
import '../theme/league_decorations.dart';
import '../widgets/lcu_image.dart';

class FriendsScreen extends ConsumerWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);
    final friends = friendsAsync.valueOrNull ?? const [];

    final inGame = friends.where((f) => f.lol?.inGame == true).toList();
    final inLobby =
        friends.where((f) => f.lol?.inLobby == true || f.lol?.inChampSelect == true).toList();
    final online = friends
        .where((f) =>
            f.isOnline &&
            !inGame.contains(f) &&
            !inLobby.contains(f))
        .toList();
    final offline = friends.where((f) => !f.isOnline).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FRIENDS',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  letterSpacing: 4,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '${friends.where((f) => f.isOnline).length} online · ${friends.length} total',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 24),
          _Section(label: 'In Game', friends: inGame),
          _Section(label: 'In Lobby / Champ Select', friends: inLobby),
          _Section(label: 'Online', friends: online),
          _Section(label: 'Offline', friends: offline, dimmed: true),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.label,
    required this.friends,
    this.dimmed = false,
  });
  final String label;
  final List<Friend> friends;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    if (friends.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: LeaguePanel(
        title: '$label  ·  ${friends.length}',
        child: Column(
          children: [
            for (final f in friends) _FriendTile(friend: f, dimmed: dimmed),
          ],
        ),
      ),
    );
  }
}

class _FriendTile extends ConsumerWidget {
  const _FriendTile({required this.friend, required this.dimmed});
  final Friend friend;
  final bool dimmed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final champions = ref.watch(championsProvider).valueOrNull ?? const {};
    final champ = champions[friend.lol?.championId];
    final dotColor = switch (friend.availability) {
      FriendAvailability.online ||
      FriendAvailability.chat =>
        AppColors.online,
      FriendAvailability.away => AppColors.away,
      FriendAvailability.dnd => AppColors.negative,
      FriendAvailability.mobile => AppColors.warn,
      _ => AppColors.offline,
    };

    final status = _statusText(friend, champ?.name);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Opacity(
        opacity: dimmed ? 0.55 : 1,
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.deepNavy,
                    border: Border.all(color: AppColors.goldMid),
                  ),
                  child: ClipRect(
                    child: LcuImage(
                      path: '/lol-game-data/assets/v1/profile-icons/${friend.icon}.jpg',
                    ),
                  ),
                ),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.deepNavy, width: 1.4),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.displayName,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  if (status != null)
                    Text(
                      status,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            if (friend.lol?.level != null && friend.lol!.level > 0)
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Lv ${friend.lol!.level}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String? _statusText(Friend f, String? champName) {
    final lol = f.lol;
    if (lol != null) {
      if (lol.inGame) {
        return champName != null ? 'In game · $champName' : 'In game';
      }
      if (lol.inChampSelect) return 'In champion select';
      if (lol.inLobby) return 'In lobby';
    }
    if (f.statusMessage.isNotEmpty) return f.statusMessage;
    return null;
  }
}

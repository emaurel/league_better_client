import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/champ_select.dart';
import '../models/champion.dart';
import '../providers/champ_select_provider.dart';
import '../providers/champions_provider.dart';
import '../providers/lcu_actions.dart';
import '../theme/app_colors.dart';
import '../theme/league_decorations.dart';
import '../widgets/lcu_image.dart';

class ChampSelectScreen extends ConsumerWidget {
  const ChampSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(champSelectProvider).valueOrNull;
    final champs = ref.watch(championsProvider).valueOrNull ?? const {};

    if (session == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final localPlayer = session.localPlayer;
    final activeAction = _activeAction(session);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _Header(session: session),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: _TeamColumn(
                    title: 'Your Team',
                    players: session.myTeam,
                    bans: session.bans.where((b) => b.isAllyAction).toList(),
                    isAlly: true,
                    champs: champs,
                    localCellId: session.localPlayerCellId,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 5,
                  child: _ChampionPicker(
                    champs: champs,
                    activeAction: activeAction,
                    localPlayer: localPlayer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _TeamColumn(
                    title: 'Their Team',
                    players: session.theirTeam,
                    bans: session.bans.where((b) => !b.isAllyAction).toList(),
                    isAlly: false,
                    champs: champs,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ChampSelectAction? _activeAction(ChampSelectSession session) {
    for (final a in session.actions) {
      if (a.actorCellId == session.localPlayerCellId && !a.completed) {
        return a;
      }
    }
    return null;
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.session});
  final ChampSelectSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = session.timer;
    final secsLeft = (timer.adjustedTimeLeftInPhaseMs / 1000).ceil();
    final phaseLabel = switch (timer.phase) {
      'PLANNING' => 'Declare Intent',
      'BAN_PICK' => 'Pick / Ban',
      'FINALIZATION' => 'Finalizing',
      _ => timer.phase,
    };
    return Row(
      children: [
        Text(
          'CHAMPION SELECT',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                letterSpacing: 4,
              ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.goldMid),
          ),
          child: Text(
            phaseLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  letterSpacing: 1.4,
                  color: AppColors.gold,
                ),
          ),
        ),
        const Spacer(),
        Text(
          timer.isInfinite ? '∞' : '00:${secsLeft.clamp(0, 99).toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}

class _TeamColumn extends StatelessWidget {
  const _TeamColumn({
    required this.title,
    required this.players,
    required this.bans,
    required this.isAlly,
    required this.champs,
    this.localCellId,
  });

  final String title;
  final List<ChampSelectPlayer> players;
  final List<ChampSelectAction> bans;
  final bool isAlly;
  final Map<int, Champion> champs;
  final int? localCellId;

  @override
  Widget build(BuildContext context) {
    return LeaguePanel(
      title: title,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final p in players)
            _PlayerSlot(
              player: p,
              champion: champs[p.championId == 0 ? p.championPickIntent : p.championId],
              isLocal: localCellId == p.cellId,
            ),
          const LeagueDivider(padding: EdgeInsets.symmetric(vertical: 8)),
          Text(
            'Bans',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  letterSpacing: 1.6,
                  color: AppColors.gold,
                ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final b in bans)
                _BanIcon(championId: b.championId, champ: champs[b.championId]),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerSlot extends StatelessWidget {
  const _PlayerSlot({
    required this.player,
    required this.champion,
    required this.isLocal,
  });
  final ChampSelectPlayer player;
  final Champion? champion;
  final bool isLocal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isLocal ? AppColors.gold : AppColors.navyOutline,
            width: isLocal ? 1.4 : 1,
          ),
          color: AppColors.deepNavy,
        ),
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.navy,
                border: Border.all(color: AppColors.goldMid),
              ),
              child: champion == null
                  ? const Icon(Icons.help_outline, size: 18)
                  : ClipRect(
                      child: LcuImage(
                        path: '/lol-game-data/assets/v1/champion-icons/${champion!.id}.png',
                      ),
                    ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    champion?.name ?? '—',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  if (player.assignedPosition.isNotEmpty)
                    Text(
                      player.assignedPosition.toLowerCase(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BanIcon extends StatelessWidget {
  const _BanIcon({required this.championId, required this.champ});
  final int championId;
  final Champion? champ;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.deepNavy,
        border: Border.all(color: AppColors.negative),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (champ != null)
            ClipRect(
              child: LcuImage(
                path: '/lol-game-data/assets/v1/champion-icons/$championId.png',
              ),
            ),
          ColoredBox(color: Colors.black.withValues(alpha: 0.5)),
          const Center(
            child: Icon(Icons.block, size: 18, color: AppColors.negative),
          ),
        ],
      ),
    );
  }
}

class _ChampionPicker extends ConsumerStatefulWidget {
  const _ChampionPicker({
    required this.champs,
    required this.activeAction,
    required this.localPlayer,
  });
  final Map<int, Champion> champs;
  final ChampSelectAction? activeAction;
  final ChampSelectPlayer? localPlayer;

  @override
  ConsumerState<_ChampionPicker> createState() => _ChampionPickerState();
}

class _ChampionPickerState extends ConsumerState<_ChampionPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final actions = ref.watch(lcuActionsProvider);
    final list = widget.champs.values
        .where((c) =>
            _query.isEmpty ||
            c.name.toLowerCase().contains(_query.toLowerCase()))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    final action = widget.activeAction;
    final isBan = action?.type == 'ban';
    final canAct = action != null;

    final hoveredId = widget.localPlayer?.championId == 0
        ? widget.localPlayer?.championPickIntent ?? 0
        : widget.localPlayer?.championId ?? 0;

    return LeaguePanel(
      title: action == null
          ? 'Champions'
          : isBan
              ? 'Banning'
              : 'Picking',
      trailing: SizedBox(
        width: 220,
        child: TextField(
          decoration: const InputDecoration(
            hintText: 'Search…',
            prefixIcon: Icon(Icons.search, size: 18),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 80,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 1,
              ),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final c = list[i];
                final hovered = c.id == hoveredId;
                return _PickerTile(
                  champion: c,
                  hovered: hovered,
                  onTap: !canAct
                      ? null
                      : () => actions.hoverChampion(action.id, c.id),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: !canAct || hoveredId == 0
                    ? null
                    : () {
                        if (isBan) {
                          actions.banChampion(action.id, hoveredId);
                        } else {
                          actions.lockChampion(action.id, hoveredId);
                        }
                      },
                child: Text(isBan ? 'LOCK BAN' : 'LOCK IN'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PickerTile extends StatefulWidget {
  const _PickerTile({
    required this.champion,
    required this.hovered,
    required this.onTap,
  });

  final Champion champion;
  final bool hovered;
  final VoidCallback? onTap;

  @override
  State<_PickerTile> createState() => _PickerTileState();
}

class _PickerTileState extends State<_PickerTile> {
  bool _mouse = false;

  @override
  Widget build(BuildContext context) {
    final highlight = widget.hovered || _mouse;
    return MouseRegion(
      onEnter: (_) => setState(() => _mouse = true),
      onExit: (_) => setState(() => _mouse = false),
      cursor: widget.onTap == null
          ? MouseCursor.defer
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.deepNavy,
            border: Border.all(
              color: widget.hovered
                  ? AppColors.gold
                  : highlight
                      ? AppColors.goldHover
                      : AppColors.navyOutline,
              width: widget.hovered ? 1.6 : 1,
            ),
          ),
          child: ClipRect(
            child: LcuImage(
              path: '/lol-game-data/assets/v1/champion-icons/${widget.champion.id}.png',
            ),
          ),
        ),
      ),
    );
  }
}

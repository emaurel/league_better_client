import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/champion.dart';
import '../providers/champions_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/lcu_image.dart';

class ChampionsScreen extends ConsumerStatefulWidget {
  const ChampionsScreen({super.key});

  @override
  ConsumerState<ChampionsScreen> createState() => _ChampionsScreenState();
}

class _ChampionsScreenState extends ConsumerState<ChampionsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final asyncChamps = ref.watch(championsProvider);
    final byId = asyncChamps.valueOrNull ?? const <int, Champion>{};
    final list = byId.values
        .where((c) =>
            _query.isEmpty ||
            c.name.toLowerCase().contains(_query.toLowerCase()))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'CHAMPIONS',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      letterSpacing: 4,
                    ),
              ),
              const Spacer(),
              SizedBox(
                width: 260,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search…',
                    prefixIcon: Icon(Icons.search, size: 18),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: asyncChamps.isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 110,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.82,
                    ),
                    itemCount: list.length,
                    itemBuilder: (_, i) => _ChampTile(champion: list[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ChampTile extends StatefulWidget {
  const _ChampTile({required this.champion});
  final Champion champion;

  @override
  State<_ChampTile> createState() => _ChampTileState();
}

class _ChampTileState extends State<_ChampTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.navy,
          border: Border.all(
            color: _hovered ? AppColors.gold : AppColors.goldMid,
            width: _hovered ? 1.4 : 1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRect(
                child: LcuImage(
                  path: '/lol-game-data/assets/v1/champion-icons/${widget.champion.id}.png',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Text(
                widget.champion.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.goldLight,
                      letterSpacing: 0.6,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class NavItem {
  const NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class LeagueNavRail extends StatelessWidget {
  const LeagueNavRail({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      decoration: BoxDecoration(
        color: AppColors.deepNavy,
        border: Border(
          right: BorderSide(color: AppColors.goldMid.withValues(alpha: 0.4)),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          for (var i = 0; i < items.length; i++)
            _NavTile(
              item: items[i],
              selected: i == selectedIndex,
              onTap: () => onSelected(i),
            ),
        ],
      ),
    );
  }
}

class _NavTile extends StatefulWidget {
  const _NavTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final highlight = widget.selected || _hovered;
    final color = widget.selected
        ? AppColors.goldLight
        : (_hovered ? AppColors.goldHover : AppColors.textSecondary);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 3,
                color: widget.selected ? AppColors.gold : Colors.transparent,
              ),
            ),
            gradient: highlight
                ? LinearGradient(
                    colors: [
                      AppColors.goldMid.withValues(alpha: widget.selected ? 0.18 : 0.08),
                      Colors.transparent,
                    ],
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.item.icon, color: color, size: 22),
              const SizedBox(height: 6),
              Text(
                widget.item.label.toUpperCase(),
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

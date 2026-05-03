import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Standard "League panel" — dark navy fill with gold borders.
BoxDecoration leaguePanel({
  Color? fill,
  Color borderColor = AppColors.goldMid,
  double borderWidth = 1,
  bool gradient = true,
}) {
  return BoxDecoration(
    color: gradient ? null : (fill ?? AppColors.navy),
    gradient: gradient
        ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              fill ?? AppColors.navy,
              AppColors.deepNavy,
            ],
          )
        : null,
    border: Border.all(color: borderColor, width: borderWidth),
  );
}

/// Header strip used on top of section panels.
BoxDecoration leagueHeaderStrip() {
  return const BoxDecoration(
    gradient: LinearGradient(
      colors: [AppColors.goldDark, AppColors.goldMid, AppColors.goldDark],
      stops: [0, 0.5, 1],
    ),
  );
}

/// A thin gold horizontal divider with a small diamond accent in the middle —
/// matches the in-client section dividers.
class LeagueDivider extends StatelessWidget {
  const LeagueDivider({super.key, this.padding = const EdgeInsets.symmetric(vertical: 12)});
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: 8,
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: AppColors.goldMid,
              ),
            ),
            const SizedBox(width: 6),
            Transform.rotate(
              angle: 0.785398,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.gold),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Container(
                height: 1,
                color: AppColors.goldMid,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable framed panel: thin gold border, optional title strip, padded body.
class LeaguePanel extends StatelessWidget {
  const LeaguePanel({
    super.key,
    this.title,
    this.trailing,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final String? title;
  final Widget? trailing;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: leaguePanel(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Container(
              decoration: leagueHeaderStrip(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    title!.toUpperCase(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          letterSpacing: 2,
                          color: AppColors.goldLight,
                        ),
                  ),
                  const Spacer(),
                  ?trailing,
                ],
              ),
            ),
          Padding(
            padding: padding,
            child: child,
          ),
        ],
      ),
    );
  }
}

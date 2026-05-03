import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../lcu/lcu_connector.dart';
import '../providers/lcu_providers.dart';
import '../theme/app_colors.dart';
import '../theme/league_decorations.dart';

class ConnectingScreen extends ConsumerStatefulWidget {
  const ConnectingScreen({super.key});

  @override
  ConsumerState<ConnectingScreen> createState() => _ConnectingScreenState();
}

class _ConnectingScreenState extends ConsumerState<ConnectingScreen> {
  bool _launching = false;
  String? _launchError;

  Future<void> _launch() async {
    setState(() {
      _launching = true;
      _launchError = null;
    });
    try {
      final launcher = ref.read(leagueLauncherProvider);
      final exe = launcher.findExecutable();
      if (exe == null) {
        setState(() {
          _launchError =
              'LeagueClient.exe not found. Set the install path in Settings.';
        });
        return;
      }
      final ok = await launcher.launchAndHide();
      if (!ok && mounted) {
        setState(() => _launchError = 'Failed to launch LeagueClient.exe.');
      }
    } finally {
      if (mounted) setState(() => _launching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lcuConnectionStateProvider).valueOrNull;
    final status = state?.status ?? LcuStatus.idle;
    final message = switch (status) {
      LcuStatus.searching => 'Searching for League client…',
      LcuStatus.connecting => 'Establishing session…',
      LcuStatus.disconnected => 'Disconnected. Waiting for client…',
      LcuStatus.error => 'Connection error',
      LcuStatus.idle => 'Idle',
      LcuStatus.connected => 'Connected',
    };

    return Scaffold(
      backgroundColor: AppColors.hextechBlack,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: LeaguePanel(
              title: 'League Better Client',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  const Center(child: _HexSpinner()),
                  const SizedBox(height: 24),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (state?.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${state!.error}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.negative,
                            ),
                      ),
                    ),
                  const LeagueDivider(),
                  Text(
                    'The League client must be running for this app to function. '
                    'You can let us start it for you — its window will be hidden.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _launching ? null : _launch,
                    child: Text(
                      _launching ? 'LAUNCHING…' : 'LAUNCH LEAGUE CLIENT',
                    ),
                  ),
                  if (_launchError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        _launchError!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.negative,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HexSpinner extends StatefulWidget {
  const _HexSpinner();

  @override
  State<_HexSpinner> createState() => _HexSpinnerState();
}

class _HexSpinnerState extends State<_HexSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 96,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, _) =>
            CustomPaint(painter: _HexPainter(progress: _ctrl.value)),
      ),
    );
  }
}

class _HexPainter extends CustomPainter {
  _HexPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 4;

    final outer = _hexPath(c, r);
    canvas.drawPath(
      outer,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = AppColors.goldMid,
    );

    final inner = _hexPath(c, r * 0.66);
    canvas.drawPath(
      inner,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = AppColors.goldMid.withValues(alpha: 0.6),
    );

    // Rotating arc on outer hex.
    final start = progress * 2 * math.pi;
    const sweep = 1.2;
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      start - math.pi / 2,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..color = AppColors.gold,
    );
  }

  Path _hexPath(Offset c, double r) {
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final angleDeg = i * 60 - 30;
      final rad = angleDeg * math.pi / 180;
      final p = Offset(c.dx + r * math.cos(rad), c.dy + r * math.sin(rad));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _HexPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

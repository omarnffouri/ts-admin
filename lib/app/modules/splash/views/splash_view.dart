import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ts_admin/app/core/gen/assets.gen.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            Assets.images.splash.path,
            fit: BoxFit.cover,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.72,
                colors: [
                  Color(0x14000000),
                  Color(0x66000000),
                  Color(0xB3000000),
                ],
                stops: [0.16, 0.62, 1],
              ),
            ),
          ),
          const Center(
            child: _AnimatedSplashLogo(),
          ),
        ],
      ),
    );
  }
}

class _AnimatedSplashLogo extends StatefulWidget {
  const _AnimatedSplashLogo();

  @override
  State<_AnimatedSplashLogo> createState() => _AnimatedSplashLogoState();
}

class _AnimatedSplashLogoState extends State<_AnimatedSplashLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final logoWidth = math.min(width * 0.68, 280.0);
    final haloSize = logoWidth * 1.34;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, intro, child) {
        return Opacity(
          opacity: intro,
          child: Transform.translate(
            offset: Offset(0, 22 * (1 - intro)),
            child: Transform.scale(
              scale: 0.88 + (intro * 0.12),
              child: child,
            ),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final progress = _controller.value;
          final breath = 1 + (math.sin(progress * math.pi * 2) * 0.025);
          final tilt = math.sin(progress * math.pi * 2) * 0.018;

          return Transform.scale(
            scale: breath,
            child: SizedBox.square(
              dimension: haloSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size.square(haloSize),
                    painter: _SplashLogoHaloPainter(progress),
                  ),
                  Transform.rotate(
                    angle: tilt,
                    child: SizedBox(
                      width: logoWidth,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            Assets.images.appLogoWhite.path,
                            fit: BoxFit.contain,
                          ),
                          Opacity(
                            opacity: 0.5,
                            child: ShaderMask(
                              blendMode: BlendMode.srcATop,
                              shaderCallback: (bounds) {
                                final sweep = (progress * 2.8) - 1.4;

                                return LinearGradient(
                                  begin: Alignment(sweep - 0.55, -1),
                                  end: Alignment(sweep + 0.55, 1),
                                  colors: const [
                                    Color(0x00FFFFFF),
                                    Color(0x99FFFFFF),
                                    Color(0x00FFFFFF),
                                  ],
                                  stops: const [0.34, 0.5, 0.66],
                                ).createShader(bounds);
                              },
                              child: Image.asset(
                                Assets.images.appLogoWhite.path,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SplashLogoHaloPainter extends CustomPainter {
  const _SplashLogoHaloPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.42;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final rotation = progress * math.pi * 2;

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = SweepGradient(
        transform: GradientRotation(rotation),
        colors: const [
          Color(0x00FFFFFF),
          Color(0x52FFFFFF),
          Color(0x00FFFFFF),
        ],
        stops: const [0, 0.45, 1],
      ).createShader(rect);

    canvas.drawCircle(center, radius, glowPaint);
    canvas.drawCircle(center, radius * 0.78, glowPaint..strokeWidth = 0.8);

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.4
      ..color = const Color(0xA6FFFFFF);

    for (var i = 0; i < 3; i++) {
      canvas.drawArc(
        rect,
        rotation + (i * math.pi * 2 / 3),
        math.pi * 0.18,
        false,
        arcPaint,
      );
    }

    final dotPaint = Paint()..color = const Color(0xE6FFFFFF);

    for (var i = 0; i < 6; i++) {
      final angle = rotation + (i * math.pi / 3);
      final dotRadius = i.isEven ? 2.8 : 1.8;
      final orbit = radius * (i.isEven ? 1.02 : 0.82);
      final dotCenter = Offset(
        center.dx + (math.cos(angle) * orbit),
        center.dy + (math.sin(angle) * orbit),
      );

      canvas.drawCircle(dotCenter, dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SplashLogoHaloPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

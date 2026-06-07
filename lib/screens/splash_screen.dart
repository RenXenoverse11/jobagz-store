import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;
  late Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.5, 0.9, curve: Curves.easeIn),
      ),
    );

    _ctrl.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) context.go('/home');
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.navyBlue,
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (ctx, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo circle
              FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.gold, width: 4),
                      color: const Color(0xFF1A3068),
                    ),
                    child: const Center(
                      child: Text('🏪', style: TextStyle(fontSize: 62)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // App name
              FadeTransition(
                opacity: _fade,
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Jobagz',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: 'Store',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.gold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Tagline pill
              FadeTransition(
                opacity: _taglineFade,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppTheme.crimson,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: 'Tindahan mo, ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'KITA',
                          style: TextStyle(
                            color: AppTheme.gold,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(
                          text: ' mo!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Loader bar
              FadeTransition(
                opacity: _taglineFade,
                child: SizedBox(
                  width: 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: const LinearProgressIndicator(
                      backgroundColor: Color(0x26FFFFFF),
                      color: AppTheme.gold,
                      minHeight: 4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

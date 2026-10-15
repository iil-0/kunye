import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../app/theme.dart';
import '../widgets/ambient_layer.dart';

/// Karşılama ekranı: mum ışığı, beliren başlık ve daktiloyla yazılan slogan.
/// Gezgin kitap ve toz zerreleri tüm uygulamayı saran [AmbientLayer]'dan gelir;
/// burada ekranın herhangi bir yerine dokununca kitap oraya uçar.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _enter(BuildContext context) {
    // '/welcome' açılışta '/' sayfasının üstüne konur; geri çekilince raflar görünür.
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (details) => AmbientLayer.of(context)?.flyTo(details.globalPosition),
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.25),
                    radius: 1.1,
                    colors: [Color(0xFF3A2814), KunyeColors.background],
                  ),
                ),
              ),
            ),
            Center(child: _IntroText(onEnter: () => _enter(context))),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 28,
              child: Text(
                'Kitaba dokun, onu sürükle ya da ekranda bir yere dokun.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: KunyeColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Başlık, daktiloyla yazılır gibi beliren slogan ve giriş düğmesi.
class _IntroText extends StatefulWidget {
  const _IntroText({required this.onEnter});

  final VoidCallback onEnter;

  @override
  State<_IntroText> createState() => _IntroTextState();
}

class _IntroTextState extends State<_IntroText>
    with SingleTickerProviderStateMixin {
  static const _slogan = 'Her kitabın bir geçmişi var.';

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _phase(double start, double end) =>
      Curves.easeOut.transform(((_controller.value - start) / (end - start)).clamp(0, 1));

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final title = _phase(0, 0.3);
        final typed = (_slogan.length * _phase(0.35, 0.8)).round();
        final button = _phase(0.8, 1);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: title,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - title)),
                child: const Column(
                  children: [
                    Text('❦', style: TextStyle(fontSize: 28, color: KunyeColors.gold)),
                    SizedBox(height: 8),
                    Text(
                      'Künye',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: KunyeColors.parchment,
                      ),
                    ),
                    Text(
                      'S A H A F',
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 6,
                        color: KunyeColors.gold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 28,
              child: Text(
                _slogan.substring(0, typed),
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: KunyeColors.text,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Opacity(
              opacity: button,
              child: OutlinedButton.icon(
                onPressed: button > 0.5 ? widget.onEnter : null,
                icon: const Icon(Icons.door_front_door_outlined),
                label: const Text('Raflara Gir'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  textStyle: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

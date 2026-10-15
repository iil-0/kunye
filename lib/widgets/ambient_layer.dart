import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../app/theme.dart';
import '../data/quotes.dart';

/// Uygulamanın tamamını saran canlı katman: mum ışığında yükselen toz zerreleri
/// ve ekranda serbestçe dolaşan "gezgin kitap". MaterialApp.builder içinde kullanılır,
/// böylece hangi sayfaya geçilirse geçilsin kitap ekranda kalır.
///
/// Kitap kendi kendine dolaşır, sürüklenip fırlatılabilir, dokununca bir dize söyler.
/// Sayfalar [AmbientLayer.of] ile kitabı istedikleri bir noktaya uçurabilir.
class AmbientLayer extends StatefulWidget {
  const AmbientLayer({super.key, required this.child});

  final Widget child;

  static AmbientLayerState? of(BuildContext context) =>
      context.findAncestorStateOfType<AmbientLayerState>();

  @override
  State<AmbientLayer> createState() => AmbientLayerState();
}

class AmbientLayerState extends State<AmbientLayer>
    with SingleTickerProviderStateMixin {
  static const _bookRadius = 30.0;
  static const _cruiseSpeed = 80.0;
  static const _flySpeed = 320.0;

  final _random = Random();
  late final Ticker _ticker;
  late final List<_Dust> _dust = List.generate(40, (_) => _Dust(_random));
  final _trail = <Offset>[];

  Duration _lastTick = Duration.zero;
  double _time = 0;
  Size _size = Size.zero;
  Offset _position = const Offset(80, 160);
  Offset _velocity = const Offset(70, 50);
  Offset? _target;
  bool _dragging = false;

  Quote? _quote;
  int _quoteIndex = 0;
  Timer? _quoteTimer;

  /// Kitabı ekrandaki bir noktaya uçurur.
  void flyTo(Offset globalPosition) => _target = globalPosition;

  @override
  void initState() {
    super.initState();
    _quoteIndex = _random.nextInt(quotes.length);
    _ticker = createTicker(_tick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _quoteTimer?.cancel();
    super.dispose();
  }

  void _tick(Duration elapsed) {
    final dt = min((elapsed - _lastTick).inMicroseconds / 1e6, 0.05);
    _lastTick = elapsed;
    _time += dt;

    if (!_dragging && _size != Size.zero) _move(dt);

    _trail.add(_position);
    if (_trail.length > 28) _trail.removeAt(0);
    for (final d in _dust) {
      d.update(dt, _random);
    }
    setState(() {});
  }

  void _move(double dt) {
    final target = _target;
    if (target != null) {
      // Hedefe doğru süzül
      final toTarget = target - _position;
      if (toTarget.distance < 14) {
        _target = null;
      } else {
        final desired = Offset.fromDirection(toTarget.direction, _flySpeed);
        _velocity = Offset.lerp(_velocity, desired, min(1, dt * 4))!;
      }
    } else {
      // Serbestçe dolaş: yönü yavaşça ve rastgele değiştir, hızı seyir hızına çek
      final turn = (sin(_time * 0.8) * 0.9 + (_random.nextDouble() - 0.5) * 3) * dt;
      final speed = _velocity.distance + (_cruiseSpeed - _velocity.distance) * min(1, dt * 1.5);
      _velocity = Offset.fromDirection(_velocity.direction + turn, speed);
    }

    _position += _velocity * dt;

    // Ekran kenarlarından sek
    final maxX = _size.width - _bookRadius;
    final maxY = _size.height - _bookRadius;
    if ((_position.dx < _bookRadius && _velocity.dx < 0) ||
        (_position.dx > maxX && _velocity.dx > 0)) {
      _velocity = Offset(-_velocity.dx, _velocity.dy);
    }
    if ((_position.dy < _bookRadius && _velocity.dy < 0) ||
        (_position.dy > maxY && _velocity.dy > 0)) {
      _velocity = Offset(_velocity.dx, -_velocity.dy);
    }
    _position = Offset(
      _position.dx.clamp(_bookRadius, max(_bookRadius, maxX)),
      _position.dy.clamp(_bookRadius, max(_bookRadius, maxY)),
    );
  }

  void _showQuote() {
    _quoteTimer?.cancel();
    setState(() {
      _quote = quotes[_quoteIndex];
      _quoteIndex = (_quoteIndex + 1) % quotes.length;
    });
    _quoteTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _quote = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _size = constraints.biggest;
        return Stack(
          children: [
            widget.child,
            IgnorePointer(
              child: CustomPaint(
                size: _size,
                painter: _DustPainter(_dust, _time),
              ),
            ),
            IgnorePointer(
              child: CustomPaint(
                size: _size,
                painter: _TrailPainter(List.of(_trail)),
              ),
            ),
            Positioned(
              left: _position.dx - _bookRadius,
              top: _position.dy - _bookRadius,
              child: GestureDetector(
                onTap: _showQuote,
                onPanStart: (_) => _dragging = true,
                onPanUpdate: (details) => _position += details.delta,
                onPanEnd: (details) {
                  _dragging = false;
                  _target = null;
                  final fling = details.velocity.pixelsPerSecond;
                  if (fling.distance > 50) {
                    _velocity = Offset.fromDirection(fling.direction, min(fling.distance, 900));
                  }
                },
                child: _FlyingBook(time: _time, velocity: _velocity),
              ),
            ),
            if (_quote != null) _buildQuoteBubble(_quote!),
          ],
        );
      },
    );
  }

  Widget _buildQuoteBubble(Quote quote) {
    const width = 250.0;
    final left = (_position.dx - width / 2)
        .clamp(16.0, max(16.0, _size.width - width - 16))
        .toDouble();
    final below = _position.dy < _size.height * 0.6;
    return Positioned(
      left: left,
      top: below ? _position.dy + _bookRadius + 8 : null,
      bottom: below ? null : _size.height - _position.dy + _bookRadius + 8,
      child: IgnorePointer(
        // MaterialApp.builder içinde Material ata yok; metin stili için şeffaf bir Material ekliyoruz.
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            width: width,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: KunyeColors.parchment,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: KunyeColors.gold.withValues(alpha: 0.25),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '"${quote.text}"',
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                    height: 1.4,
                    color: KunyeColors.parchmentInk,
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '— ${quote.author}',
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 12,
                      color: KunyeColors.parchmentMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Sayfalarını kanat gibi çırpan, uçtuğu yöne hafifçe yatan kitap.
class _FlyingBook extends StatelessWidget {
  const _FlyingBook({required this.time, required this.velocity});

  final double time;
  final Offset velocity;

  @override
  Widget build(BuildContext context) {
    final flap = 0.7 + 0.3 * (sin(time * 10) + 1) / 2;
    final tilt = (velocity.dx / 500).clamp(-0.35, 0.35);
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: KunyeColors.gold.withValues(alpha: 0.35),
            blurRadius: 26,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Transform.rotate(
        angle: tilt,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.diagonal3Values(1, flap, 1),
          child: const Icon(Icons.auto_stories, size: 44, color: KunyeColors.gold),
        ),
      ),
    );
  }
}

/// Mum ışığında yavaşça yükselen toz zerresi.
class _Dust {
  _Dust(Random random) {
    _reset(random, initial: true);
  }

  late double x, y, speed, size, phase;

  void _reset(Random random, {bool initial = false}) {
    x = random.nextDouble();
    y = initial ? random.nextDouble() : 1.05;
    speed = 0.01 + random.nextDouble() * 0.03;
    size = 0.6 + random.nextDouble() * 1.8;
    phase = random.nextDouble() * pi * 2;
  }

  void update(double dt, Random random) {
    y -= speed * dt;
    x += sin(phase + y * 12) * 0.0004;
    if (y < -0.05) _reset(random);
  }
}

class _DustPainter extends CustomPainter {
  _DustPainter(this.dust, this.time);

  final List<_Dust> dust;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final d in dust) {
      final glow = 0.15 + 0.35 * (sin(time * 1.5 + d.phase) + 1) / 2;
      paint.color = KunyeColors.gold.withValues(alpha: glow);
      canvas.drawCircle(Offset(d.x * size.width, d.y * size.height), d.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DustPainter oldDelegate) => true;
}

/// Kitabın arkasında bıraktığı yaldız tozu.
class _TrailPainter extends CustomPainter {
  _TrailPainter(this.trail);

  final List<Offset> trail;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var i = 0; i < trail.length; i++) {
      final t = i / trail.length;
      paint.color = KunyeColors.gold.withValues(alpha: t * 0.45);
      canvas.drawCircle(trail[i], 1 + 3 * t, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrailPainter oldDelegate) => true;
}

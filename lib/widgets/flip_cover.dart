import 'dart:math';

import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/book.dart';

/// Dokununca 3B olarak dönüp arka kapağı gösteren kitap kapağı.
class FlipCover extends StatefulWidget {
  const FlipCover({super.key, required this.book, this.height = 300});

  final Book book;
  final double height;

  @override
  State<FlipCover> createState() => _FlipCoverState();
}

class _FlipCoverState extends State<FlipCover>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_controller.value < 0.5) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.height * 2 / 3;
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final angle = Curves.easeInOut.transform(_controller.value) * pi;
          final showBack = angle > pi / 2;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0015)
              ..rotateY(angle),
            child: Container(
              width: width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: KunyeColors.shadow.withValues(alpha: 0.5),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: showBack
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(pi),
                        child: _BackCover(book: widget.book),
                      )
                    : Image.asset(widget.book.image, fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BackCover extends StatelessWidget {
  const _BackCover({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final random = Random(book.id);
    return Container(
      color: KunyeColors.surfaceHigh,
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: KunyeColors.gold.withValues(alpha: 0.7)),
        ),
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
        child: Column(
          children: [
            const Text(
              'ARKA KAPAK',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 3,
                color: KunyeColors.gold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                book.description,
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.45,
                  fontStyle: FontStyle.italic,
                  color: KunyeColors.text,
                ),
              ),
            ),
            const Text('❦', style: TextStyle(color: KunyeColors.gold)),
            const SizedBox(height: 8),
            // Kitabın numarasından üretilen, her nüshaya özgü barkod
            Container(
              color: KunyeColors.parchment,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Column(
                children: [
                  SizedBox(
                    height: 26,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < 28; i++)
                          Container(
                            width: random.nextInt(3) + 1.0,
                            margin: const EdgeInsets.only(right: 1.5),
                            color: KunyeColors.parchmentInk,
                          ),
                      ],
                    ),
                  ),
                  Text(
                    'KNY-${book.year}-${book.id.toString().padLeft(4, '0')}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8,
                      color: KunyeColors.parchmentInk,
                    ),
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

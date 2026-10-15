import 'package:flutter/material.dart';

import '../app/theme.dart';

/// "Tesadüf Rafı": ne okuyacağını bilmeyenler için rastgele bir kitap açar.
class SerendipityCard extends StatelessWidget {
  const SerendipityCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: KunyeColors.forest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, color: KunyeColors.gold),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tesadüf Rafı',
                      style: TextStyle(
                        color: KunyeColors.parchment,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Ne okuyacağını bilmiyor musun? Rafa gözün kapalı uzan.',
                      style: TextStyle(color: KunyeColors.textMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: KunyeColors.gold),
            ],
          ),
        ),
      ),
    );
  }
}

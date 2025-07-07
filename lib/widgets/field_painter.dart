// lib/widgets/field_painter.dart
import 'package:flutter/material.dart';
import 'dart:math';

// physikalischer Halbraum des Feldes in mm
const double fieldRadiusMm = 100.0;

class FieldPainter extends CustomPainter {
  final double distanceMm; // aktueller Abstand Magnet – Oberfläche
  final int gridSize; // z.B. 60
  final double cellSizePx; // z.B. 10.0

  FieldPainter({
    required this.distanceMm,
    required this.gridSize,
    required this.cellSizePx,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // Mittelpunkt in Pixeln
    final center = Offset(size.width / 2, size.height / 2);

    // mm‐Pro‐Pixel‐Faktor (weil size.width == gridSize*cellSizePx sein sollte)
    final pxToMm = (fieldRadiusMm * 2) / (gridSize * cellSizePx);

    for (var ix = 0; ix < gridSize; ix++) {
      for (var iy = 0; iy < gridSize; iy++) {
        // Pixel‐Koordinaten
        final px = ix * cellSizePx + cellSizePx / 2;
        final py = iy * cellSizePx + cellSizePx / 2;

        // in mm umrechnen relativ zum Zentrum
        final xMm = (px - center.dx) * pxToMm;
        final yMm = (py - center.dy) * pxToMm;

        // räumlicher Abstand vom Magnetmittelpunkt auf der Oberfläche
        final rMm = sqrt(xMm * xMm + yMm * yMm);

        // effektiver Abstand zum Magneten
        final zMm = distanceMm;

        // hier einfache modellhafte Kurve: Feldstärke ~ 1 / (1 + (r² + z²)^(3/2))
        // (das hebt die Abnahme im Zentrum hervor und lässt es nach außen gegen 0 gehen)
        final intensity = (rMm <= fieldRadiusMm)
            ? 1.0 / pow(1 + pow(rMm * rMm + zMm * zMm, 1.5), 1.0)
            : 0.0;

        paint.color = _getFeldFarbe(intensity.clamp(0.0, 1.0));
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(px, py),
            width: cellSizePx,
            height: cellSizePx,
          ),
          paint,
        );
      }
    }
  }

  Color _getFeldFarbe(double t) {
    // t läuft von 0.0 … 1.0
    if (t < 0.33) {
      return Color.lerp(Colors.black, Colors.deepPurple, t * 3)!;
    } else if (t < 0.66) {
      return Color.lerp(Colors.deepPurple, Colors.deepOrange, (t - 0.33) * 3)!;
    } else {
      return Color.lerp(Colors.deepOrange, Colors.yellow, (t - 0.66) * 3)!;
    }
  }

  @override
  bool shouldRepaint(covariant FieldPainter old) {
    return old.distanceMm != distanceMm ||
        old.gridSize != gridSize ||
        old.cellSizePx != cellSizePx;
  }
}

import 'dart:math';
import 'package:flutter/material.dart';

import 'distance_slider.dart';
import 'field_painter.dart';
import 'raster_painter.dart';

/// Zeigt das Magnetfeld‐Raster und den Abstandsslider an.
class MagnetfeldGrid extends StatefulWidget {
  const MagnetfeldGrid({super.key});

  @override
  State<MagnetfeldGrid> createState() => _MagnetfeldGridState();
}

class _MagnetfeldGridState extends State<MagnetfeldGrid> {
  static const int gridSize = 60; // Anzahl Zellen pro Achse
  double abstandMm = 1.0; // Abstand Magnet–Oberfläche in mm

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Das Raster nimmt den verfügbaren Platz ein:
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // ■ Pixel‐Seitenlänge (quadratisch):
              final double gridPxSide = min(
                constraints.maxWidth,
                constraints.maxHeight,
              );

              // ■ Berechnung, ab welchem Radius das Feld ≤ ε ist:
              const double epsilon = 0.01;
              final double spreadFactor = abstandMm * 0.01;
              final double cutoffMm = (1 / epsilon - 1) / spreadFactor;

              // ■ Unser physikalischer Radius und mm‐Seitenlänge:
              final double fieldRadiusMm = cutoffMm;
              final double gridMmSide = fieldRadiusMm * 2;

              // ■ mm‐Größe pro Zelle und Pixel‐Größe pro Zelle:
              final double cellSizeMm = gridMmSide / gridSize;
              final double cellSizePx = gridPxSide / gridSize;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Y‐Achse (alle 10 Zellen ein Label):
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(gridSize + 1, (i) {
                      if (i % 10 != 0) return const SizedBox(height: 0);
                      // yMm = Radius nach oben minus aktueller Zell‐Position
                      final double yMm = fieldRadiusMm - (i * cellSizeMm);
                      return SizedBox(
                        height: cellSizePx * 10,
                        width: 40,
                        child: Text(
                          '${yMm.round()} mm',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      );
                    }),
                  ),

                  // Das Raster mit Feld‐Painter und Raster‐Painter:
                  SizedBox(
                    width: gridPxSide,
                    height: gridPxSide,
                    child: Stack(
                      children: [
                        CustomPaint(
                          size: Size(gridPxSide, gridPxSide),
                          painter: FieldPainter(
                            gridSize: gridSize,
                            cellSizePx: cellSizePx,
                            distanceMm: abstandMm,
                          ),
                        ),
                        CustomPaint(
                          size: Size(gridPxSide, gridPxSide),
                          painter: RasterPainter(
                            gridSize: gridSize,
                            cellSizePx: cellSizePx,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // Der Slider für den Abstand:
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: DistanceSlider(
            value: abstandMm,
            onChanged: (v) => setState(() => abstandMm = v),
            min: 1.0,
            max: 10.0,
            divisions: 100,
            activeColor: Colors.blueGrey,
            inactiveColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}

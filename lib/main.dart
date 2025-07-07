import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'widgets/magnetfeld_grid.dart';

const String appVersion   = '0.25.07.06';
const int    gridSize     = 60;
const double cellSize     = 10.0;
const int    labelSteps   = 6;
const double sliderHeight = 60.0;

// Von dir gemessene Overflows:
const double padRight  = 175.0;
const double padBottom = 153.0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    // 1) Gewünschte Content-Größe berechnen
    final double fieldSize  = gridSize * cellSize;
    final double axisStep   = fieldSize / labelSteps;
    final double contentW   = axisStep + fieldSize;
    final double contentH   = fieldSize + axisStep + sliderHeight;

    // 2) Aktuelles Fenster-Frame abfragen
    final Rect frame = await windowManager.getBounds();

    // 3) Neues Frame setzen: Content + gemessener Puffer
    final Rect newBounds = Rect.fromLTWH(
      frame.left,
      frame.top,
      contentW + padRight,
      contentH + padBottom,
    );
    await windowManager.setBounds(newBounds);

    // 4) Fenstergröße fixieren
    await windowManager.setMinimumSize(newBounds.size);
    await windowManager.setMaximumSize(newBounds.size);
  }

  runApp(const MagnetfeldViewerApp());
}

class MagnetfeldViewerApp extends StatelessWidget {
  const MagnetfeldViewerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magnetfeld Viewer',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Stack(
          children: [
            const MagnetfeldGrid(),
            Positioned(
              bottom: 8,
              right: 8,
              child: Text(
                appVersion,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

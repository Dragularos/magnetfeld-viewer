// lib/widgets/distance_slider.dart
import 'package:flutter/material.dart';

/// Ein Slider, der einen Wert in mm zwischen [min] und [max] auswählt.
class DistanceSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  // neu hinzugefügte Parameter:
  final double min;
  final double max;
  final int? divisions;
  final Color? activeColor;
  final Color? inactiveColor;

  const DistanceSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1.0,
    this.max = 10.0,
    this.divisions,
    this.activeColor,
    this.inactiveColor,
    
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Slider(
        value: value,
        onChanged: onChanged,
        min: min,
        max: max,
        divisions: divisions,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
      ),
    );
  }
}

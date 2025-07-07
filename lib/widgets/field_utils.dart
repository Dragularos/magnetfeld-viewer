import 'dart:math';

/// Magnetparameter für Ø35×5 mm N45
const double magnetBr = 1.32; // Remanenz in Tesla
const double magnetRadius = 17.5; // Radius in mm (halber Ø35 mm)
const double magnetThickness = 5.0; // Dicke in mm

/// Maximalfeld an der Polfläche (r=0, z=0)
/// Wird als Gelb-Referenz genutzt.
final double surfaceField =
    (magnetBr / 2) *
    (magnetThickness /
        sqrt(magnetRadius * magnetRadius + magnetThickness * magnetThickness));

/// Axiales B-Feld Bz(r,z) für einen Scheibenmagneten
double axialField(double radius, double offset) {
  final double term1 =
      (offset + magnetThickness) /
      sqrt(
        magnetRadius * magnetRadius +
            (offset + magnetThickness) * (offset + magnetThickness),
      );
  final double term2 =
      offset / sqrt(magnetRadius * magnetRadius + offset * offset);
  return (magnetBr / 2) * (term1 - term2);
}

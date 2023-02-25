class PatientScanImageResult {
  final String? imagePath;

  PatientScanImageResult({
    this.imagePath,
  });
}

class PrescriptionScanResult {
  final String medicine;

  PrescriptionScanResult({
    required this.medicine,
  });
}

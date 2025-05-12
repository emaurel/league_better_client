


class Overlay {
  String centeredLCOverLayPath;
  String socialCardLCOverlayPath;
  String titleLCOverlayPath;
  String uncenteredLCOverlayPath;


  Overlay({
    required this.centeredLCOverLayPath,
    required this.socialCardLCOverlayPath,
    required this.titleLCOverlayPath,
    required this.uncenteredLCOverlayPath,
  });

  factory Overlay.fromJson(Map<String, dynamic> json) {
    return Overlay(
      centeredLCOverLayPath: json['centeredLCOverLayPath'] ?? '',
      socialCardLCOverlayPath: json['socialCardLCOverlayPath'] ?? '',
      titleLCOverlayPath: json['titleLCOverlayPath'] ?? '',
      uncenteredLCOverlayPath: json['uncenteredLCOverlayPath'] ?? '',
    );
  }
}
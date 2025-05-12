import 'Overlay.dart';

class Augment {
  String contentId;
  List<Overlay> overlays;

  Augment({required this.contentId, required this.overlays});

  factory Augment.fromJson(Map<String, dynamic> json) {
    return Augment(
      contentId: json['contentId'] ?? '',
      overlays: List<Overlay>.from(
        json['overlays']?.map((x) => Overlay.fromJson(x)) ?? [],
      ),
    );
  }
}

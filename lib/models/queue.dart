/// Static metadata about a matchmaking queue. The LCU exposes the full list
/// at `/lol-game-queues/v1/queues`; this model captures the fields we display.
class QueueInfo {
  const QueueInfo({
    required this.id,
    required this.name,
    required this.shortName,
    required this.description,
    required this.gameMode,
    required this.mapId,
    required this.queueAvailability,
  });

  final int id;
  final String name;
  final String shortName;
  final String description;
  final String gameMode;
  final int mapId;

  /// `Available`, `PlatformDisabled`, etc.
  final String queueAvailability;

  bool get isAvailable => queueAvailability == 'Available';

  factory QueueInfo.fromJson(Map<String, dynamic> json) {
    return QueueInfo(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      shortName: json['shortName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      gameMode: json['gameMode'] as String? ?? '',
      mapId: (json['mapId'] as num?)?.toInt() ?? 0,
      queueAvailability: json['queueAvailability'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'shortName': shortName,
        'description': description,
        'gameMode': gameMode,
        'mapId': mapId,
        'queueAvailability': queueAvailability,
      };
}

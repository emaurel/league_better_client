

class MucJwtDto {
  final String channelClaim;
  final String domain;
  final String jwt;
  final String targetRegion;

  MucJwtDto({
    required this.channelClaim,
    required this.domain,
    required this.jwt,
    required this.targetRegion,
  });

  factory MucJwtDto.fromJson(Map<String, dynamic> json) {
    return MucJwtDto(
      channelClaim: json['channelClaim'],
      domain: json['domain'],
      jwt: json['jwt'],
      targetRegion: json['targetRegion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channelClaim': channelClaim,
      'domain': domain,
      'jwt': jwt,
      'targetRegion': targetRegion,
    };
  }
}
class Champion {
  const Champion({
    required this.id,
    required this.name,
    required this.alias,
    required this.title,
    required this.roles,
  });

  final int id;
  final String name;
  final String alias;
  final String title;
  final List<String> roles;

  factory Champion.fromJson(Map<String, dynamic> json) {
    return Champion(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      alias: json['alias'] as String? ?? '',
      title: json['title'] as String? ?? '',
      roles: (json['roles'] as List?)?.whereType<String>().toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'alias': alias,
        'title': title,
        'roles': roles,
      };
}

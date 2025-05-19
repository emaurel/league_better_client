class Spell {
  String description;
  String name;

  Spell({required this.description, required this.name});

  factory Spell.fromJson(Map<String, dynamic> json) {
    return Spell(
      description: json['description'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'description': description, 'name': name};
  }
}

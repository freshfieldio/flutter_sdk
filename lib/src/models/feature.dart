class Feature {
  final String type;
  final String name;
  final String description;
  String? icon;

  Feature({
    required this.type,
    required this.name,
    required this.description,
    this.icon,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      type: json['type'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'description': description,
      if (icon != null) 'icon': icon,
    };
  }
}

import 'feature.dart';

class Update {
  final String id;
  final DateTime created;
  final String title;
  final String description;
  final List<Feature> features;

  Update({
    required this.id,
    required this.created,
    required this.title,
    required this.description,
    required this.features,
  });

  factory Update.fromJson(Map<String, dynamic> json) {
    return Update(
      id: json['id'] as String,
      created: DateTime.parse(json['created'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      features: (json['features'] as List).map((feature) => Feature.fromJson(feature as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created': created.toIso8601String(),
      'title': title,
      'description': description,
      'features': features.map((feature) => feature.toJson()).toList(),
    };
  }
}

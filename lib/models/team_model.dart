class TeamModel {
  final String id;
  final String name;
  final String stadium;
  final String description;
  final String logo;
  bool isFavorite;

  TeamModel({
    required this.id,
    required this.name,
    required this.stadium,
    required this.description,
    required this.logo,
    this.isFavorite = false,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['idTeam'] ?? '',
      name: json['strTeam'] ?? '',
      stadium: json['strStadium'] ?? '',
      description: json['strDescriptionEN'] ?? '',
      logo: json['strBadge'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTeam': id,
      'strTeam': name,
      'strStadium': stadium,
      'strBadge': logo,
      'strDescriptionEN': description,
      'isFavorite': isFavorite,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'stadium': stadium,
      'description': description,
      'logo': logo,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory TeamModel.fromMap(Map<String, dynamic> map) {
    return TeamModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      stadium: map['stadium'] ?? '',
      description: map['description'] ?? '',
      logo: map['logo'] ?? '',
      isFavorite: map['isFavorite'] == 1,
    );
  }
} 
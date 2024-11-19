import 'team_model.dart';

class FavoriteSportModel {
  final String id;
  final String name;
  final String stadium;
  final String description;
  final String logo;

  FavoriteSportModel({
    required this.id,
    required this.name,
    required this.stadium,
    required this.description,
    required this.logo,
  });

  factory FavoriteSportModel.fromJson(Map<String, dynamic> json) {
    return FavoriteSportModel(
      id: json['id'],
      name: json['name'],
      stadium: json['stadium'],
      description: json['description'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'stadium': stadium,
      'description': description,
      'logo': logo,
    };
  }

  factory FavoriteSportModel.fromMap(Map<String, dynamic> map) {
    return FavoriteSportModel(
      id: map['id'],
      name: map['name'],
      stadium: map['stadium'],
      description: map['description'],
      logo: map['logo'],
    );
  }

  factory FavoriteSportModel.fromTeamModel(TeamModel team) {
    return FavoriteSportModel(
      id: team.id!,
      name: team.name,
      stadium: team.stadium,
      description: team.description,
      logo: team.logo,
    );
  }
} 
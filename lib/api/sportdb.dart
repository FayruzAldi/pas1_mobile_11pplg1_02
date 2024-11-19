import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/team_model.dart';

class SportDBService {
  final String baseUrl = 'https://www.thesportsdb.com/api/v1/json/3';

  Future<List<TeamModel>> getTeams() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search_all_teams.php?l=English%20Premier%20League')
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['teams'] != null) {
          return (data['teams'] as List)
              .map((team) => TeamModel.fromJson(team))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching teams: $e');
      return [];
    }
  }
}

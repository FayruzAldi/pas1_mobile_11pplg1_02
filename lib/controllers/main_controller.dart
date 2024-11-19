import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../api/sportdb.dart';
import '../models/team_model.dart';
import '../pages/home_page.dart';
import '../pages/bookmarks_page.dart';
import '../pages/profile_page.dart';

class MainController extends GetxController {
  final SportDBService _sportDBService = SportDBService();
  final storage = GetStorage();
  final RxInt currentIndex = 0.obs;
  final RxList<TeamModel> teamList = <TeamModel>[].obs;
  final RxList<TeamModel> favoriteTeams = <TeamModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString username = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final savedUsername = storage.read('username');
    if (savedUsername != null) {
      username.value = savedUsername;
    }
    loadTeams();
    loadFavoriteTeams();
  }

  void updateUsername(String newUsername) {
    username.value = newUsername;
    storage.write('username', newUsername);
  }

  void changePage(int index) {
    currentIndex.value = index;
    switch (index) {
      case 0:
        Get.off(() => HomePage());
        break;
      case 1:
        Get.off(() => BookmarksPage());
        break;
      case 2:
        Get.off(() => ProfilePage());
        break;
    }
  }

  Future<void> checkLoginStatus() async {
    final savedUsername = storage.read('username');
    if (savedUsername != null) {
      username.value = savedUsername;
      await Future.delayed(Duration(milliseconds: 100));
      Get.offAll(() => HomePage());
    }
  }

  Future<void> login(String username, String password) async {
    try {
      isLoading.value = true;
      storage.write('username', username);
      this.username.value = username;
      Get.offAll(() => HomePage());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    storage.remove('username');
    username.value = '';
    Get.offAllNamed('/login');
  }

  Future<void> loadTeams() async {
    try {
      isLoading.value = true;
      final teams = await _sportDBService.getTeams();
      teamList.assignAll(teams);
      final teamsJson = teams.map((team) => team.toJson()).toList();
      await storage.write('teams', teamsJson);
    } catch (e) {
      print('Error loading teams: $e');
      Get.snackbar(
        'Error',
        'Failed to load teams',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite(TeamModel team) {
    final index = favoriteTeams.indexWhere((t) => t.id == team.id);
    if (index == -1) {
      team.isFavorite = true;
      favoriteTeams.add(team);
      saveFavoriteTeams();
      Get.snackbar('Success', 'Added to favorites');
    } else {
      removeFromFavorites(team);
    }
  }

  void removeFromFavorites(TeamModel team) {
    team.isFavorite = false;
    favoriteTeams.removeWhere((t) => t.id == team.id);
    saveFavoriteTeams();
    Get.snackbar('Success', 'Removed from favorites');
  }

  Future<void> saveFavoriteTeams() async {
    final teamsData = favoriteTeams.map((team) => team.toMap()).toList();
    await storage.write('favorite_teams', teamsData);
  }

  Future<void> loadFavoriteTeams() async {
    final teamsData = storage.read('favorite_teams');
    if (teamsData != null) {
      final teams = (teamsData as List)
          .map((data) => TeamModel.fromMap(data as Map<String, dynamic>))
          .toList();
      favoriteTeams.assignAll(teams);
    }
  }
}

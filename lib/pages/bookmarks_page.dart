import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../models/team_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class BookmarksPage extends StatelessWidget {
  final MainController controller = Get.find<MainController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Favorite Teams', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[900],
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (controller.favoriteTeams.isEmpty) {
          return Center(child: Text(
            'No favorite teams yet',
            style: TextStyle(color: Colors.white),
          ));
        }

        return ListView.builder(
          itemCount: controller.favoriteTeams.length,
          itemBuilder: (context, index) {
            final team = controller.favoriteTeams[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.grey[900],
              child: ListTile(
                leading: _buildTeamLogo(team.logo),
                title: Text(team.name, style: TextStyle(color: Colors.white)),
                subtitle: Text(team.stadium, style: TextStyle(color: Colors.white70)),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirmation(context, team),
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: Colors.black,
        ),
        child: CustomBottomNavigationBar(
          currentIndex: 1,
          onTap: controller.changePage,
        ),
      ),
    );
  }

  Widget _buildTeamLogo(String logoUrl) {
    if (logoUrl.isEmpty) {
      return CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(Icons.sports_soccer),
      );
    }

    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      child: ClipOval(
        child: Image.network(
          logoUrl,
          width: 40,
          height: 40,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading image: $error');
            return Icon(Icons.sports_soccer);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, TeamModel team) {
    showDialog(
      context: context,
      barrierDismissible: true, 
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text('Remove Favorite', style: TextStyle(color: Colors.white)),
          content: Text(
            'Are you sure you want to remove this team from favorites?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: Text('No', style: TextStyle(color: Colors.white70)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes', style: TextStyle(color: Colors.red)),
              onPressed: () {
                controller.removeFromFavorites(team);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

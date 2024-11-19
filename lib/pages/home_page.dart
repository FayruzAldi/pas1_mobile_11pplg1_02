import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../models/team_model.dart';
import '../pages/team_detail_page.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class HomePage extends StatelessWidget {
  final MainController controller = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('English Premier League Teams', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[900],
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (controller.teamList.isEmpty) {
          return Center(child: Text('No teams found'));
        }

        return ListView.builder(
          itemCount: controller.teamList.length,
          itemBuilder: (context, index) {
            final team = controller.teamList[index];
            
            return Obx(() => Card(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.grey[900],
              child: ListTile(
                leading: _buildTeamLogo(team.logo),
                title: Text(
                  team.name,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  team.stadium,
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: IconButton(
                  icon: Icon(
                    controller.favoriteTeams.any((favTeam) => favTeam.id == team.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: controller.favoriteTeams.any((favTeam) => favTeam.id == team.id)
                        ? Colors.red
                        : Colors.white70,
                  ),
                  onPressed: () {
                    controller.toggleFavorite(team);
                  },
                ),
                onTap: () {
                  Get.to(() => TeamDetailPage(team: team));
                },
              ),
            ));
          },
        );
      }),
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: Colors.black,
        ),
        child: CustomBottomNavigationBar(
          currentIndex: 0,
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
}

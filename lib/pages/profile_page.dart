import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../controllers/main_controller.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();
  final ProfileController profileController = Get.find<ProfileController>();
  
  @override
  Widget build(BuildContext context) {
    profileController.getProfile(mainController.username.value);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[900],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: const Color.fromARGB(255, 0, 0, 0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    child: Icon(Icons.person, size: 50, color: Colors.red[900]),
                  ),
                  SizedBox(height: 16),
                  Obx(() => Text(
                    mainController.username.value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
                  SizedBox(height: 8),
                  Obx(() => Text(
                    profileController.profileData.value['email'] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    color: Colors.grey[900],
                    child: ListTile(
                      leading: Icon(Icons.notifications, color: Colors.red),
                      title: Text(
                        'Notifications',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Switch(
                        value: true,
                        activeColor: Colors.red[900],
                        onChanged: (bool value) {},
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    color: Colors.grey[900],
                    child: ListTile(
                      leading: Icon(Icons.language, color: Colors.red),
                      title: Text(
                        'Language',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        'English',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    color: Colors.grey[900],
                    child: ListTile(
                      leading: Icon(Icons.help_outline, color: Colors.red),
                      title: Text(
                        'Help & Support',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Icon(Icons.chevron_right, color: Colors.white70),
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    color: Colors.grey[900],
                    child: ListTile(
                      leading: Icon(Icons.info_outline, color: Colors.red),
                      title: Text(
                        'About App',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Icon(Icons.chevron_right, color: Colors.white70),
                    ),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(Icons.logout),
                    label: Text('Logout', style: TextStyle(fontSize: 16)),
                    onPressed: () async {
                      try {
                        await profileController.logout();
                        mainController.username.value = '';
                        await Get.offAll(() => LoginPage());
                      } catch (e) {
                        print('Error during logout: $e');
                        Get.snackbar(
                          'Error',
                          'Failed to logout. Please try again.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.withOpacity(0.7),
                          colorText: Colors.white,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: Colors.black,
        ),
        child: CustomBottomNavigationBar(
          currentIndex: 2,
          onTap: mainController.changePage,
        ),
      ),
    );
  }
}

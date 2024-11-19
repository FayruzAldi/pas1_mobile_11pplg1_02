import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../pages/home_page.dart';
import 'package:flutter/material.dart';
import '../controllers/main_controller.dart';

class ProfileController extends GetxController {
  final String baseUrl = 'https://mediadwi.com';
  final storage = GetStorage();
  final MainController mainController = Get.find<MainController>();
  
  final Rx<Map<String, dynamic>> profileData = Rx<Map<String, dynamic>>({});
  final RxBool isLoading = false.obs;
  
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      
      print('Attempting login with:');
      print('Username: $username');
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/latihan/login'),
        body: {
          'username': username,
          'password': password,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == true) {
          if (data['data'] != null) {
            profileData.value = {
              'username': data['data']['username'],
              'full_name': data['data']['full_name'],
              'email': data['data']['email'],
            };
          }
          
          mainController.updateUsername(username);
          
          await Future.delayed(Duration(milliseconds: 100));
          
          Get.offAll(() => HomePage());
          
          return true;
        } else {
          Get.snackbar(
            'Error', 
            data['message'] ?? 'Invalid username or password',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white,
          );
          return false;
        }
      } else {
        Get.snackbar(
          'Error', 
          'Server error: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      Get.snackbar(
        'Error', 
        'Connection error. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await storage.erase();
    profileData.value = {};
    mainController.username.value = ''; 
  }

  Future<void> getProfile(String username) async {
    try {
      isLoading.value = true;
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/latihan/profile/$username'),
      );

      print('Get profile response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == true && data['data'] != null) {
          profileData.value = {
            'username': data['data']['username'] ?? username,
            'full_name': data['data']['full_name'] ?? username,
            'email': data['data']['email'] ?? '',
          };
        }
      }
    } catch (e) {
      print('Error getting profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> checkLoginStatus() async {
    final savedUsername = storage.read('username');
    if (savedUsername != null) {
      await getProfile(savedUsername);
      return true;
    }
    return false;
  }
} 
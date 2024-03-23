// ignore_for_file: prefer_interpolation_to_compose_strings
import 'package:albertians/services/api_service.dart';
import 'package:flutter/material.dart';

class ProfileDetailsPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfileDetailsPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userData['name'] ?? 'Unknown'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            // Profile Picture (Replace with your actual image path or URL)
            CircleAvatar(
              radius: 90,
              backgroundImage:
                          NetworkImage(serverUrl + userData['profile_picture']),
                          // NetworkImage('http://192.168.45.72/' + userData['profile_picture']),

            ),
            const SizedBox(height: 24),
            // User Information Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserInfo('Name:', userData['name']),
                    _buildUserInfo('Department:', userData['department']),
                    _buildUserInfo('Program:', userData['program']),
                    _buildUserInfo('Batch:',
                        '${userData['batch_from']} - ${userData['batch_to']}'),
                    _buildUserInfo('Email:', userData['email']),
                    _buildUserInfo('Date of Birth:', userData['DOB']),
                    // Add other information as needed
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Additional Information based on current status
            _buildAdditionalInfo(userData),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          value ?? 'N/A', // If value is null, display 'N/A' instead
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAdditionalInfo(Map<String, dynamic> userData) {
    final String currentStatus = userData['current_status'];

    switch (currentStatus) {
      case 'Working (Govt)':
      case 'Working (Non Govt)':
      case 'Entrepreneur':
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Status:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  currentStatus,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                _buildUserInfo(
                  'Current Organization:',
                  userData['current_org'],
                ),
                _buildUserInfo(
                  'Designation:',
                  userData['current_designation'],
                ),
              ],
            ),
          ),
        );
      case 'Student':
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Status:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  currentStatus,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                _buildUserInfo(
                  'Current Program:',
                  userData['current_program'],
                ),
                _buildUserInfo(
                  'Current Institution:',
                  userData['current_institution'],
                ),
                _buildUserInfo(
                  'Expected Year of Passing:',
                  userData['exp_year_of_passing'],
                ),
              ],
            ),
          ),
        );
      default:
        return const SizedBox
            .shrink(); // Return an empty widget for other cases or 'Not Working'
    }
  }
}

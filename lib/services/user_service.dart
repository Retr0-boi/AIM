import 'package:dio/dio.dart';

class UserService {
  static const String apiUrl = 'http://10.0.2.2:80/AIM/api/api.php'; // Update with your API URL

  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final response = await _dio.get(apiUrl);

      if (response.statusCode == 200) {
        // Parse the JSON string
        final jsonData = response.data;
        
        // Ensure jsonData is a List<dynamic>
        if (jsonData is List<dynamic>) {
          List<Map<String, dynamic>> userList =
              jsonData.map((user) => user as Map<String, dynamic>).toList();

          return userList;
        } else {
          // Handle unexpected response format
          print('Unexpected response format: $jsonData');
          return [];
        }
      } else {
        // Handle error
        print('Error: ${response.statusMessage}');
        return [];
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
      return [];
    }
  }
}

import 'package:dio/dio.dart';
import 'dart:convert';

class ApiService {
  static const String apiUrl =
      'http://10.0.2.2:80/AIM/api/api.php'; // Update with your API URL

  Dio _dio = Dio();

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Request: ${options.method} ${options.path}');
        print('Request data: ${options.data}');
        return handler.next(options);
        
      },
      onResponse: (response, handler) {
        print('Response: ${response.statusCode}');
        print('Response data: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('Error DioException: ${e.message}');
        
        return handler.next(e);
      },
    ));
  }

  Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post(
        '$apiUrl?action=register',
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: json.encode(userData),
      );
      print('registering-Raw Response: ${response.toString()}'); // Add this line
      print('registering-Request Data: ${json.encode(userData)}');
      print('registering-Response Status Code: ${response.statusCode}');
      print('registering-Response Data: ${response.data}');

      dynamic responseData = response.data;

      if (responseData == null) {
        print('Empty response received');
        return {'success': false};
      }

      if (responseData is String) {
        // Handle non-JSON response
        try {
          responseData = json.decode(responseData);
        } catch (e) {
          print('Invalid JSON response format: $responseData');
          return {'success': false, 'error': 'Invalid JSON response format'};
        }
      }

      if (responseData.containsKey('success') && responseData['success'] != null) {
        bool success = responseData['success'];
        

        return {'success': success}; // Include the MongoDB object ID in the response
      } else {
        print('Error api_service.dart: ${response.statusMessage}');
        return {'success': false, 'error': response.statusMessage};
      }
    } catch (e) {
      print('Exception api_service.dart: $e');
      if (e is DioException && e.response != null) {
        print('Full Response api_service.dart: ${e.response}');
        return {'success': false, 'error': e.response?.statusCode};
      } else {
        return {'success': false, 'error': 'Unknown error'};
      }
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await _dio.post(
        apiUrl + '?action=login', // Include the login action in the URL
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: json.encode({'email': email, 'password': password}),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        dynamic responseData = response.data;

        if (responseData is String) {
          responseData = json.decode(responseData);
        }

        // Check if the response contains the expected keys
        if (responseData.containsKey('success') &&
            responseData['success'] != null) {
          bool success = responseData['success'];
          String mongoId = responseData['mongo_id']; // Add this line to get the MongoDB object ID
        String userName = responseData['name']; // Add this line to get the MongoDB object ID
          return {'success': success, 'mongo_id': mongoId,'userName':userName};
        } else {
          return {'success': false};
        }
      } else {
        print('Error api_service.dart: ${response.statusMessage}');
        return {'success': false};
      }
    } catch (e) {
      print('Exception api_service.dart: $e');
      if (e is DioException && e.response != null) {
        print('Full Response api_service.dart: ${e.response}');
      }
      return {'success': false};
    }
  }
}

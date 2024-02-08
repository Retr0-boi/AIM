import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';

class ApiService {
  static const String apiUrl =
      'http://10.0.2.2:80/AIM/api/api.php'; // Update with your API URL

  final Dio _dio = Dio();

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
      print(
          'registering-Raw Response: ${response.toString()}'); // Add this line
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

      if (responseData.containsKey('success') &&
          responseData['success'] != null) {
        bool success = responseData['success'];

        return {
          'success': success
        }; // Include the MongoDB object ID in the response
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
        '$apiUrl?action=login', // Include the login action in the URL
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
          String mongoId = responseData[
              'mongo_id']; // Add this line to get the MongoDB object ID
          String userName = responseData[
              'name']; // Add this line to get the MongoDB object ID
          return {
            'success': success,
            'mongo_id': mongoId,
            'userName': userName
          };
        } else {
          return {'success': false};
        }
      } else {
        print('Error api_service.dart: ${response.statusMessage}');
        return {'success': false};
      }
    } catch (e) {
      print('Exception at api_service.dart: $e');
      if (e is DioException && e.response != null) {
        print('Full Response api_service.dart: ${e.response}');
      }
      return {'success': false};
    }
  }

  Future<Map<String, dynamic>> fetchUserData(String mongoId) async {
    try {
      final response = await _dio.get(
        '$apiUrl?action=getUserData&mongoId=$mongoId',
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Check if response data is not null
        if (response.data != null) {
          // Parse the JSON response
          Map<String, dynamic> responseData = json.decode(response.data!);

          // Check if the response indicates success
          if (responseData['success'] == true) {
            // Extract user data
            Map<String, dynamic> userData = responseData['userData'];

            String department = userData['department'];
            String program = userData['program'];
            String batchFrom = userData['batch_from'];
            String batchTo = userData['batch_to'];
            String name = userData['name'];
            String email = userData['email'];
            String DOB = userData['DOB'];
            String currentStatus = userData['current_status'];
            String currentInstitution = userData['current_institution'];
            String currentProgram = userData['programme'];
            String expYearOfPassing = userData['expected_year_of_passing'];
            String currentOrg = userData['current_organisation'];
            String currentDesignation = userData['designation'];
            String profilePic = userData['profile_picture'];

            // Return the extracted data
            return {
              'success': true,
              'name': name,
              'email': email,
              'department': department,
              'program': program,
              'batch_from': batchFrom,
              'batch_to': batchTo,
              'DOB': DOB,
              'current_status': currentStatus,
              'current_institution': currentInstitution,
              'current_program': currentProgram,
              'exp_year_of_passing': expYearOfPassing,
              'current_org': currentOrg,
              'current_designation': currentDesignation,
              'profile_picture': profilePic,
            };
          } else {
            // Handle case when the API indicates failure
            return {'success': false, 'error': responseData['error']};
          }
        } else {
          // Handle case when response data is null
          return {'success': false, 'error': 'Response data is null'};
        }
      } else {
        int? SC = response.statusCode;

        // Handle HTTP error
        return {'success': false, 'error': 'Failed to fetch user data $SC'};
      }
    } catch (e) {
      // Handle general exception
      print('Exception api_service.dart: $e');
      return {
        'success': false,
        'error-api_services': 'Failed to fetch user data'
      };
    }
  }

  Future<List<Map<String, dynamic>>> searchUsers(String batchFrom,
      String batchTo, String department, String program, String mongoId) async {
    try {
      final response = await _dio.get(
        '$apiUrl?action=searchUsers&batchFrom=$batchFrom&batchTo=$batchTo&department=$department&program=$program&mongoId=$mongoId',
      );

      dynamic responseData = response.data;

      if (responseData == null) {
        print('Empty response received');
        return [];
      }

      if (responseData is String) {
        // Handle non-JSON response
        try {
          responseData = json.decode(responseData);
        } catch (e) {
          print('Invalid JSON response format: $responseData');
          return [];
        }
      }

      if (responseData.containsKey('success') &&
          responseData['success'] == true) {
        // Extract matched users data
        List<dynamic> matchedUsersData = responseData['matchedUsers'];

        // Convert the list of dynamic to List<Map<String, dynamic>>
        List<Map<String, dynamic>> matchingUsers =
            List<Map<String, dynamic>>.from(matchedUsersData);

        return matchingUsers;
      } else {
        print('Error api_service.dart: ${response.statusMessage}');
        return [];
      }
    } catch (e) {
      print('Exception api_service.dart: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchConversation(String mongoId) async {
    try {
      final response = await _dio.get(
        '$apiUrl?action=getConversations&mongoId=$mongoId',
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Check if response data is not null
        if (response.data != null) {
          // Parse the JSON response
          Map<String, dynamic> responseData = json.decode(response.data!);

          // Check if the response indicates success
          if (responseData['success'] == true) {
            // Extract conversation data
            List<dynamic> conversations = responseData['conversations'];

            // Return the extracted data
            return {'success': true, 'conversations': conversations};
          } else {
            // Handle case when the API indicates failure
            return {'success': false, 'error': responseData['error']};
          }
        } else {
          // Handle case when response data is null
          return {'success': false, 'error': 'Response data is null'};
        }
      } else {
        int? statusCode = response.statusCode;

        // Handle HTTP error
        return {
          'success': false,
          'error': 'Failed to fetch conversation data $statusCode'
        };
      }
    } catch (e) {
      // Handle general exception
      print('Exception api_service.dart: $e');
      return {
        'success': false,
        'error-api_services': 'Failed to fetch conversation data'
      };
    }
  }

  Future<String> initiateConversation(
      String senderId, String recipientId) async {
    try {
      final response = await _dio.post(
        '$apiUrl?action=initiateConversation',
        data: FormData.fromMap({
          'senderId': senderId,
          'recipientId': recipientId,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.data!);

        // Check if 'success' key exists in the responseData
        if (responseData.containsKey('success')) {
          if (responseData['success'] == true) {
            // Handle successful initiation
            return 'success';
          } else {
            // Handle case when the API indicates failure
            return 'error: ${responseData['error']}';
          }
        }
      }

      // Handle HTTP error or unexpected response format
      return 'error: Failed to initiate conversation or unexpected response format';
    } catch (e) {
      // Handle general exception
      print('Exception api_service.dart: $e');
      return 'error: Failed to initiate conversation';
    }
  }

   Future<Map<String, dynamic>> postContent(
      String subject, String content, String postedBy, String type,
      {File? image}) async {
        
    try {
      final response = await _dio.post(
        '$apiUrl?action=postContent',
        data: FormData.fromMap({
          'subject': subject,
          'content': content,
          'posted_by': postedBy,
          'type': type,
          if (image != null) 'image': await MultipartFile.fromFile(image.path),
        }),
      );

      print('Post Content Response Status Code: ${response.statusCode}');
      print('Post Content Response Data: ${response.data}');

      if (response.statusCode == 200) {
        dynamic responseData = response.data;

        if (response.data != null && response.data.isNotEmpty) {
          // Parse response data
          if (responseData is String) {
            responseData = json.decode(responseData);
          }

          if (responseData.containsKey('success') &&
              responseData['success'] != null) {
            bool success = responseData['success'];
            return {'success': success};
          } else {
            return {'success': false};
          }
        } else {
          throw Exception('Empty response data');
        }
      } else {
        print('Error api_service.dart: ${response.statusMessage}');
        return {'success': false};
      }
    } catch (e) {
      print('Exception in postContent: $e');
      return {'success': false};
    }
  }
  
}

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

  Future<Map<String, dynamic>> initiateConversation(
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
            return {
              'success': true,
              'conversationId': responseData['conversationId'],
            };
          } else {
            // Handle case when the API indicates failure
            return {'success': false, 'error': responseData['error']};
          }
        }
      }

      // Handle HTTP error or unexpected response format
      return {
        'success': false,
        'error': 'Failed to initiate conversation or unexpected response format'
      };
    } catch (e) {
      // Handle general exception
      print('Exception api_service.dart: $e');
      return {'success': false, 'error': 'Failed to initiate conversation'};
    }
  }

  void printFormData(FormData formData) {
    for (var entry in formData.fields) {
      print('${entry.key}: ${entry.value}');
    }
    for (var entry in formData.files) {
      print('${entry.key}: ${entry.value.filename}');
    }
  }

  Future<Map<String, dynamic>> postJobs(
      String subject,
      String jobDetails,
      String postedBy,
      String type,
      String registrationLink,
      String status) async {
    try {
      final response = await _dio.post(
        '$apiUrl?action=postJobsEvents',
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: json.encode({
          'posted_by': postedBy,
          'subject': subject,
          'job_details': jobDetails,
          'type': type,
          'link': registrationLink,
          'status': status,
        }),
      );

      print('Post Jobs Response Status Code: ${response.statusCode}');
      print('Post Jobs Response Data: ${response.data}');

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
      print('Exception api_service.dart: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<List<Map<String, dynamic>>> getJobs() async {
    try {
      final response = await _dio.get('$apiUrl?action=getJobs');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.data);
        if (responseData['success'] == true) {
          final List<dynamic> jobs = responseData['jobs'];
          final List<Map<String, dynamic>> jobData = jobs
              .cast<Map<String, dynamic>>() // Explicitly cast to correct type
              .map((job) {
            // Assuming 'created_at' is a String in the format 'yyyy-MM-dd HH:mm:ss'
            DateTime createdAt = DateTime.parse(job['created_at']);
            return {
              ...job,
              'created_at': createdAt,
            };
          }).toList();
          return jobData;
        } else {
          throw Exception('Failed to fetch jobs: ${responseData['error']}');
        }
      } else {
        throw Exception('Failed to fetch jobs: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to fetch jobs: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getEvents() async {
    try {
      final response = await _dio.get('$apiUrl?action=getEvents');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.data);
        if (responseData['success'] == true) {
          final List<dynamic> jobs = responseData['jobs'];
          final List<Map<String, dynamic>> jobData = jobs
              .cast<Map<String, dynamic>>() // Explicitly cast to correct type
              .map((job) {
            // Assuming 'created_at' is a String in the format 'yyyy-MM-dd HH:mm:ss'
            DateTime createdAt = DateTime.parse(job['created_at']);
            return {
              ...job,
              'created_at': createdAt,
            };
          }).toList();
          return jobData;
        } else {
          throw Exception('Failed to fetch events: ${responseData['error']}');
        }
      } else {
        throw Exception('Failed to fetch events: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  Future<List<Map<String, dynamic>>> searchAlumni({
    String? name,
    String? department,
    String? course,
    String? batchFrom,
    String? batchTo,
  }) async {
    try {
      final requestData = {
        if (name != null && name.isNotEmpty) 'name': name,
        if (department != null && department.isNotEmpty)
          'department': department,
        if (course != null && course.isNotEmpty) 'course': course,
        if (batchFrom != null && batchFrom.isNotEmpty) 'batchFrom': batchFrom,
        if (batchTo != null && batchTo.isNotEmpty) 'batchTo': batchTo,
      };

      final response = await _dio.get(
        '$apiUrl?action=searchAlumni',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: requestData,
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final responseData = json.decode(response.data);
        // Check if the response indicates success
        if (responseData['success'] == true) {
          // Extract the list of matched users
          final List<dynamic> matchedUsers = responseData['matchedUsers'];
          // Convert each matched user to a map
          final List<Map<String, dynamic>> usersData =
              matchedUsers.map((user) => user as Map<String, dynamic>).toList();
          // Return the list of matched users
          return usersData;
        } else {
          // Handle error from API
          print(
              'Failed to fetch alumni data. Reason: ${responseData['message']}');
          return [];
        }
      } else {
        print(
            'Failed to fetch alumni data. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception api_service.dart: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> updateProfileImage(
      String mongoId, File imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        'mongoId': mongoId,
        'profile_image': await MultipartFile.fromFile(imageFile.path),
      });

      final response = await _dio.post(
        '$apiUrl?action=updateProfilePicture',
        data: formData,
      );

      print(
          'Update Profile Image Response Status Code: ${response.statusCode}');
      print('Update Profile Image Response Data: ${response.data}');

      if (response.statusCode == 200) {
        // Check if response data is empty
        if (response.data == null || response.data.isEmpty) {
          return {'success': false, 'error': 'Empty response data'};
        }

        dynamic responseData = response.data;

        // Parse response data if it's a string
        if (responseData is String) {
          responseData = json.decode(responseData);
        }

        // Check if response data contains success key
        if (responseData.containsKey('success')) {
          bool success = responseData['success'];
          return {'success': success};
        } else {
          return {
            'success': false,
            'error': 'Response data does not contain success key'
          };
        }
      } else {
        // Handle non-200 status codes
        return {
          'success': false,
          'error': 'HTTP error: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Exception api_service.dart: $e');
      return {'success': false, 'error': 'Exception occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> postContent(
      String subject, String content, String postedBy, String type,
      {File? image}) async {
    try {
      FormData formData = FormData.fromMap({
        'subject': subject,
        'content': content,
        'posted_by': postedBy,
        'type': type,
        if (image != null) 'image': await MultipartFile.fromFile(image.path),
      });

      print('Sending post content with the following data:');
      printFormData(formData);

      final response = await _dio.post(
        '$apiUrl?action=postContent',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: formData,
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
      print('Exception api_service.dart: $e');
      return {'success': false};
    }
  }

  Future<List<Map<String, dynamic>>> getPosts() async {
    try {
      final response = await _dio.get('$apiUrl?action=getPosts');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.data);
        if (responseData['success'] == true) {
          final List<dynamic> posts = responseData['posts'];
          final List<Map<String, dynamic>> postData = posts
              .cast<Map<String, dynamic>>() // Explicitly cast to correct type
              .map((post) {
            // Extract user information from the post
            final Map<String, dynamic> user = post['user'];
            final Map<String, dynamic> postWithoutUser = Map.from(post);
            postWithoutUser
                .remove('user'); // Remove user information from the post
            return {
              ...postWithoutUser,
              'user': user, // Add user information to the post
            };
          }).toList();
          return postData;
        } else {
          throw Exception('Failed to fetch posts: ${responseData['error']}');
        }
      } else {
        throw Exception('Failed to fetch posts: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  Future<Map<String, dynamic>> fetchMessages(String conversationId) async {
    try {
      final response = await _dio.get(
        '$apiUrl?action=getMessages&conversationId=$conversationId',
      );

      if (response.statusCode == 200) {
        if (response.data != null) {
          Map<String, dynamic> responseData = json.decode(response.data!);

          if (responseData['success'] == true) {
            List<dynamic> messages = responseData['messages'];
            return {'success': true, 'messages': messages};
          } else {
            return {'success': false, 'error': responseData['error']};
          }
        } else {
          return {'success': false, 'error': 'Response data is null'};
        }
      } else {
        int? statusCode = response.statusCode;
        return {
          'success': false,
          'error': 'Failed to fetch messages data $statusCode'
        };
      }
    } catch (e) {
      print('Exception api_service.dart: $e');
      return {
        'success': false,
        'error-api_services': 'Failed to fetch messages data'
      };
    }
  }
}

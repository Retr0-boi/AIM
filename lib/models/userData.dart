import 'package:flutter/material.dart';

class UserData extends ChangeNotifier {
  String? mongoId;
  String? username;
  String? email;
  String? password;
  String? department;
  String? batchFrom;
  String? batchTo;
  bool isLoggedIn;

  UserData({
    this.mongoId,
    this.username,
    this.email,
    this.password,
    this.department,
    this.batchFrom,
    this.batchTo,
    this.isLoggedIn = false,
  });

  // Method to update user data
  void updateUserData({
    String? mongoId,
    String? username,
    String? email,
    String? password,
    String? department,
    String? batchFrom,
    String? batchTo,
    bool? isLoggedIn,
  }) {
    this.mongoId = mongoId ?? this.mongoId;
    this.username = username ?? this.username;
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.department = department ?? this.department;
    this.batchFrom = batchFrom ?? this.batchFrom;
    this.batchTo = batchTo ?? this.batchTo;
    this.isLoggedIn = isLoggedIn ?? this.isLoggedIn;

    notifyListeners();
  }

  // Factory method to create UserData instance from JSON
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      mongoId: json['mongo_id'],
      username: json['userName'],
      email: json['email'],
      password: json['password'],
      department: json['department'],
      batchFrom: json['batch_from'],
      batchTo: json['batch_to'],
      isLoggedIn: true,
    );
  }

  // Method to print user data
  void printUserData() {
    print('UserData:');
    print('mongoId: $mongoId');
    print('username: $username');
    print('email: $email');
    print('password: $password');
    print('department: $department');
    print('batchFrom: $batchFrom');
    print('batchTo: $batchTo');
    // Print other fields
  }
}

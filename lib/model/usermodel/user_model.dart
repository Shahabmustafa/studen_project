import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userId;
  String? userName;
  String? email;
  String? profileImage;
  bool? status;
  String? type;
  List? likes;
  List? favourite;
  DateTime? createAccount;
  String? token;
  String? location;
  bool? form;
  List? messageList;

  UserModel(
      {this.userId,
        this.userName,
        this.email,
        this.profileImage,
        this.status,
        this.type,
        this.likes,
        this.favourite,
        this.createAccount,
        this.token,
        this.location,
        this.form,
        this.messageList,
      });

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    email = json['email'];
    profileImage = json['profileImage'];
    status = json['status'];
    type = json['type'];
    likes = json['likes'];
    favourite = json['favourite'];
    createAccount = (json['createAccount'] as Timestamp).toDate();
    token = json['token'];
    location = json['location'];
    form = json['form'];
    messageList = json['messageList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['profileImage'] = this.profileImage;
    data['status'] = this.status;
    data['type'] = this.type;
    data['likes'] = this.likes;
    data['favourite'] = this.favourite;
    data['createAccount'] = this.createAccount;
    data['token'] = this.token;
    data['location'] = this.location;
    data['form'] = this.form;
    data['messageList'] = this.messageList;
    return data;
  }
}
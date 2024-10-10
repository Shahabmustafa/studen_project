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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['email'] = email;
    data['profileImage'] = profileImage;
    data['status'] = status;
    data['type'] = type;
    data['likes'] = likes;
    data['favourite'] = favourite;
    data['createAccount'] = createAccount;
    data['token'] = token;
    data['location'] = location;
    data['form'] = form;
    data['messageList'] = messageList;
    return data;
  }
}
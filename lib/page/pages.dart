import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:project_uas_chat/models/UserModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
// Untuk import page agar tidak melakukan import yang berulang
part 'login.dart';
part 'register.dart';
part 'halamanutama.dart';
part 'contact.dart';
part 'roomChat.dart';
part 'chat.dart';

final _auth = FirebaseAuth.instance;
final FirebaseFirestore frs = FirebaseFirestore.instance;

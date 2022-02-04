import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:project_uas_chat/models/UserModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/utils.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// Untuk import page agar tidak melakukan import yang berulang
part 'login.dart';
part 'register.dart';
part 'halamanutama.dart';
part 'contact.dart';
part 'roomChat.dart';
part 'chat.dart';

final _auth = FirebaseAuth.instance;
final FirebaseFirestore frs = FirebaseFirestore.instance;
final FirebaseChatCore firebaseChatCore = FirebaseChatCore.instance;
final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

void _handlePressed(String imageUrl, String name, String lastname,
    BuildContext context, types.Room room) async {
  // final room = await firebaseChatCore.createRoom(otherUser);
  pushNewScreen(
    context,
    screen: ChatPage(
        room: room,
        image: imageUrl.toString(),
        name: name.toString(),
        lastname: lastname.toString()),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.fade,
  );
}

Widget _buildAvatar(types.User user) {
  final color = getUserAvatarNameColor(user);
  final hasImage = user.imageUrl != null;
  final name = getUserName(user);

  return Container(
    margin: const EdgeInsets.only(right: 16),
    child: CircleAvatar(
      backgroundColor: hasImage ? Colors.transparent : color,
      backgroundImage: hasImage ? NetworkImage(user.imageUrl!) : null,
      radius: 20,
      child: !hasImage
          ? Text(
              name.isEmpty ? '' : name[0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            )
          : null,
    ),
  );
}

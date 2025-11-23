import 'dart:io';

import 'package:realestate_app/customWidget/blocModelProvider/BLoCModelBase.dart';
import 'package:realestate_app/model/ServerGateway.dart';
import 'package:realestate_app/model/entity/Role.dart';
import 'package:realestate_app/model/entity/User.dart';

class ProfileModel extends BLoCModelBase {
  static const ProfilePicUploadedEvent = "ProfilePicUploadedEvent";
  static const ProfilePicCouldNotUploadEvent = "ProfilePicCouldNotUploadEvent";

  User get user => ServerGateway.instance().signedInUser;

  Role get selectedRole => ServerGateway.instance().selectedRole;

  ProfileModel() {
    createStream(ProfilePicUploadedEvent);
    createStream(ProfilePicCouldNotUploadEvent);
  }

  void modifyProfilePic(File pic) {
    if (isLoading) return;

    broadcastToStream(BLoCModelBase.IsLoadingEvent, true);

    final result = ServerGateway.instance().uploadUserProfilePicture(pic);

    result.then((value) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);
      broadcastToStream(ProfilePicUploadedEvent, "");
      // this.profilePic;
    }, onError: (e) {
      broadcastToStream(BLoCModelBase.IsLoadingEvent, false);

      broadcastToStream(
          ProfilePicCouldNotUploadEvent, "Something is not right $e");
    });
  }

  Future<File> get profilePic {
    return ServerGateway.instance().loadProfileImage(user.email);
  }
}

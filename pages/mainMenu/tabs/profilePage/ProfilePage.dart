import 'dart:io';

import 'package:flutter/material.dart';
import 'package:realestate_app/customWidget/general/DeviceFractionSpace.dart';
import 'package:realestate_app/customWidget/general/FutureWidget.dart';
import 'package:realestate_app/customWidget/general/Utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realestate_app/customWidget/Util.dart';
import 'package:realestate_app/customWidget/blocModelProvider/ModelProvidedState.dart';
import 'package:realestate_app/customWidget/blocModelProvider/ModelProvider.dart';
import 'package:realestate_app/model/ServerGateway.dart';
import 'package:realestate_app/model/entity/Agent.dart';
import 'package:realestate_app/model/entity/Role.dart';
import 'package:realestate_app/pages/Router.dart';
import 'package:realestate_app/pages/mainMenu/tabs/profilePage/ModifyNameDialog.dart';
import 'package:realestate_app/pages/mainMenu/tabs/profilePage/ProfileModel.dart';


class ProfilePage extends StatefulWidget {
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ModelProvidedState<ProfilePage, ProfileModel> {
  buildContent(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _createProfilePicture(),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    halveticaText(model.user.fullNameOrNoName,
                        color: Color(0xff1e2022)),
                    IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: 14,
                        ),
                        onPressed: _modifyName),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                halveticaText(model.user.phoneOrEmail, color: Color(0xff1e2022)),
                SizedBox(
                  height: 30,
                ),


                if(_userIsAgentAndHasCompany())
                  halveticaText("Company : "+_userCompany(), color: Color(0xff1e2022),fontSize: 12),

                if(_userIsAgentAndHasCompany())
                  SizedBox(
                    height: 30,
                  ),

                if(_userIsAgentAndHasWebsite())
                  halveticaText("Website : "+_userWebsite(), color: Color(0xff1e2022),fontSize: 12),

                if(_userIsAgentAndHasWebsite())
                  SizedBox(
                    height: 30,
                  ),


                createRoundedCornerRaisedButton("Log Out",fontSize: 16.0, onPress: _doLogOut,minWidth: 240.0),
                SizedBox(
                  height: 27,
                ),

                buildLogoImage()
              ]
          ),
        ),
      ),
    );
  }

  bool _userIsAgentAndHasWebsite()
  {
    return (model.selectedRole == Role.Seller
        && (model.user as Agent).website!=null
        && (model.user as Agent).website.isNotEmpty
    );
  }

  bool _userIsAgentAndHasCompany()
  {
    return (model.selectedRole == Role.Seller
        && (model.user as Agent).company!=null
        && (model.user as Agent).company.isNotEmpty
    );
  }

  String _userWebsite()
  {
    return (model.user as Agent).website;
  }

  String _userCompany()
  {
    return (model.user as Agent).company;
  }

  _createProfilePicture() => Container(
        width: percentageOfDeviceWidth(context, 0.3),
        height: percentageOfDeviceWidth(context, 0.3),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            FutureWidget(
              initialLoadingBoxHeight: percentageOfDeviceWidth(context, 0.3),
              initialLoadingBoxWidth: percentageOfDeviceWidth(context, 0.3),
              future: FutureValue(
                  computation: () => model.profilePic,
                  key: "profilePic_${model.user.userId}"),
              builder: (context, profilePicFile) => ClipOval(
                child: Container(
                  width: percentageOfDeviceWidth(context, 0.3),
                  height: percentageOfDeviceWidth(context, 0.3),
                  child: Image.file(
                    profilePicFile,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 5,
                left: 5,
                child: FloatingActionButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    mini: true,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: _chooseAndUploadPicture)),
          ],
        ),
      );

  _chooseAndUploadPicture() async {
    final ImagePicker _picker = ImagePicker();

    showDialogWithOptions(context, "Pick", ["Gallery", "Camera"],
        (option) async {
      // PickedFile pickedFile;
      XFile image;
      if (option == "Gallery")
        image = await _picker.pickImage(source: ImageSource.gallery);

      // pickedFile = await _picker.getImage(source: ImageSource.gallery);
      else
        image = await _picker.pickImage(source: ImageSource.camera);

      // pickedFile = await _picker.getImage(source: ImageSource.camera);

      if (image != null) {
        File file = File(image.path);
        model.modifyProfilePic(file);
      } else {
        // User canceled the picker
      }
    });
  }

  _doLogOut() async {
    await ServerGateway.instance().logout();
    ModelProvider.instance.disposeAllModels();
    Navigator.pushNamedAndRemoveUntil(
        context, MainMenuPagePath, (route) => false);
  }

  _modifyName() {
    showDialog(
        context: context,
        builder:(context)=> Center(
          child: Container(
              width: percentageOfDeviceWidth(context, 0.8),
              child: ModifyNameDialog(
                nameModified: () {
                  setState(() {});
                },
              )),
        ));
  }

  DeviceFractionSpace buildLogoImage() {
    return DeviceFractionSpace(
      child: Image.asset('images/houselogiqsmall.png', fit: BoxFit.contain),
      percentageOfDeviceWidth: 1,
      percentageOfDeviceHeight: 0.20,
    );
  }

  /**_mapButton() {
    return SizedBox(
      height: 45,
      child: (
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18))
            ),
            label: Text('            Map                 ',
            style: TextStyle(fontSize:20,fontWeight: FontWeight.bold ),),
            icon: Icon(Icons.map),
            onPressed: () {
              showMapFullOfMarkersPage(context);
            },
          )
      ),
    );
  }*/

}

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odc_pointage/avatar/service.dart';

import '../carteApprenant.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var imageURL = '';

  late final CarteApprenantState carteApprenantState =
      new CarteApprenantState();

  void uploadImage(ImageSource imageSource, id, token) async {
    try {
      // ignore: deprecated_member_use
      final pickedFile = await ImagePicker().getImage(source: imageSource);
      isLoading(true);
      if (pickedFile != null) {
        var response =
            await ImageService.uploadFile(pickedFile.path, id, token);

        if (response.statusCode == 200) {
          //get image url from api response
          imageURL = response.data['avatar'];
          Get.snackbar('Success', 'Image uploaded successfully',
              margin: const EdgeInsets.only(top: 5, left: 10, right: 10));
        } else {
          Get.snackbar('Failed', 'Choisissez une image inférieur à 2MB',
              margin: const EdgeInsets.only(top: 5, left: 10, right: 10));
        }
      } else {
        Get.snackbar('Failed', 'Image not selected',
            margin: const EdgeInsets.only(top: 5, left: 10, right: 10));
      }
    } finally {
      isLoading(false);
    }
  }
}

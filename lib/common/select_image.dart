// ignore_for_file: invalid_use_of_protected_member

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/common/base_64_convert_util.dart';
import 'package:shop_app/common/base_controller.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/utils/app_images.dart';
import 'package:shop_app/widgets/common_extension.dart';
import 'package:shop_app/widgets/helper.dart';
import 'package:shop_app/widgets/tap_anim_button.dart';
import 'package:velocity_x/velocity_x.dart';

class ImgData {
  String imagePath = "";
  String? url = "";
  RxBool isLoading = false.obs;
  bool canEdit = true;
  bool isbase64 = false;
  ImgData({
    required this.imagePath,
    this.url,
    this.canEdit = true,
    this.isbase64 = false,
  });
}

class UploadImageController extends BaseController {
  final RxList<ImgData> _photoURLs = RxList<ImgData>();
  final ImagePicker picker = ImagePicker();
  XFile? photo;
  final int maxCount;
  RxBool isFull = false.obs;
  RxBool isEmpty = false.obs;
  RxBool isLoading = false.obs;
  String entityId = "";
  Function()? onImagesChangeListner;

  UploadImageController({this.maxCount = 1});

  void setOnChangeListner(Function()? onChange) {
    onImagesChangeListner = onChange;
  }

  void setUploadedImages64(List<ImgData>? imageList) {
    if (imageList == null) {
      return;
    }
    _photoURLs.value = imageList;
    isEmpty.value = _photoURLs.isEmpty;
    _photoURLs.refresh();
  }

  void _setUploadedImages(List<String>? imageList) {
    if (imageList == null) {
      return;
    }
    for (var e in imageList) {
      final image = ImgData(imagePath: e);
      image.isLoading.value = false;
      image.canEdit = false;
      _photoURLs.add(image);
    }
    _photoURLs.refresh();
  }

  void pickFromGallery({required void Function(String) onComplete}) {
    if ((maxCount - _photoURLs.length) == 1) {
      pickSingleFromGallery(onComplete: onComplete);
    } else {
      pickMultipleFromGallery(onComplete: onComplete);
    }
  }

  Future<String?> pickSingleFromGallery({
    required void Function(String) onComplete,
  }) async {
    photo = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (photo != null && photo?.path != '') {
      if (!contains(photo?.path)) {
        final image = ImgData(imagePath: photo?.path ?? "");
        _photoURLs.add(image);
        // uploadImage(image, fileType);
      }
    }
    _isMaxSelected();
    onImagesChangeListner?.call();
    return photo?.path;
  }

  void pickMultipleFromGallery({
    required void Function(String) onComplete,
  }) async {
    List<XFile> photos = await picker.pickMultiImage(
      limit: maxCount - _photoURLs.length,
      maxHeight: 1000,
      maxWidth: 1000,
      imageQuality: 70,
    );

    for (XFile mPhoto in photos) {
      if (mPhoto.path != '') {
        if (!contains(mPhoto.path)) {
          final image = ImgData(imagePath: mPhoto.path);
          _photoURLs.add(image);
          // uploadImage(image, fileType);
        }
      }
      _isMaxSelected();
      onImagesChangeListner?.call();
    }
  }

  Future<String?> pickFromCamera({
    required void Function(String) onComplete,
  }) async {
    photo = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 40,
    );
    if (photo != null && photo?.path != '') {
      final image = ImgData(imagePath: photo?.path ?? "");
      if (!contains(photo?.path)) {
        _photoURLs.add(image);
        // uploadImage(image, fileType);
      }
    }
    _isMaxSelected();
    onImagesChangeListner?.call();

    return photo?.path;
  }

  void reset() {
    _photoURLs.clear();
    _isMaxSelected();
    onImagesChangeListner?.call();
    _photoURLs.refresh();
  }

  void removeImage(ImgData imagePath) {
    _photoURLs.remove(imagePath);
    _isMaxSelected();
    onImagesChangeListner?.call();
  }

  List<String> getImages() {
    return _photoURLs.value.map((e) => e.url ?? "").toList();
  }

  List<String> getImagesBase64() {
    return _photoURLs.value
        .map((e) => imageToBase64(e.imagePath))
        .toList();
  }

  void _isMaxSelected() {
    isEmpty.value = _photoURLs.isEmpty;
    isFull.value = _photoURLs.value.length >= maxCount;
  }

  bool contains(String? path) {
    bool contains = false;
    for (var e in _photoURLs) {
      if (e.imagePath == path) {
        contains = true;
      }
    }
    return contains;
  }
}

class UploadImageWidget extends StatelessWidget {
  final UploadImageController controller;
  final bool enabled;
  const UploadImageWidget({
    super.key,
    required this.controller,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Obx(
            () => Visibility(
              visible: controller._photoURLs.isEmpty,
              child: const Icon(Icons.upload, size: 24),
            ),
          ),
          verticalSpacing(10),
          Obx(
            () => Visibility(
              visible: controller._photoURLs.isEmpty,
              child: Text(
                "Click to Choose File",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Obx(
            () => Column(
              children: List.generate(controller._photoURLs.length, (index) {
                return uploadedImageTile(context, controller._photoURLs[index]);
              }),
            ),
          ),
          verticalSpacing(8),
          Text(
            "Max ${controller.maxCount} Images",
            // context.localized.maxFileSize,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.greyText,
              fontWeight: FontWeight.w400,
            ),
          ),
          verticalSpacing(12),
          Obx(
            () => IgnorePointer(
              ignoring: controller.isFull.value,
              child: Opacity(
                opacity: controller.isFull.value ? 0.5 : 1.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => TapAnimationButton(
                        disabled: controller.isFull.value || !enabled,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Open Camera",
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: enabled
                                      ? AppColors.black01
                                      : AppColors.textGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          controller.pickFromCamera(onComplete: (value) {});
                        },
                      ),
                    ),
                    // horizontalSpacing(12),
                    // Obx(
                    //   () => TapAnimationButton(
                    //     disabled: controller.isFull.value || !enabled,
                    //     child: Container(
                    //       alignment: Alignment.center,
                    //       padding: const EdgeInsets.symmetric(
                    //         horizontal: 16,
                    //         vertical: 8,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: enabled
                    //             ? AppColors.primary
                    //             : AppColors.disabled,
                    //         borderRadius: const BorderRadius.all(
                    //           Radius.circular(8.0),
                    //         ),
                    //       ),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Text(
                    //             "Choose File",
                    //             style: GoogleFonts.inter(
                    //               fontSize: 12,
                    //               fontWeight: FontWeight.w400,
                    //               color: AppColors.white,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     onTap: () {
                    //       controller.pickFromGallery(onComplete: (value) {});
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget uploadedImageTile(BuildContext context, ImgData model) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: model.canEdit
                ? Image.file(File(model.imagePath), width: 30, height: 30)
                : SizedBox(
                    width: 30,
                    height: 30,
                    child: base64ToImage(model.imagePath),
                  ),
          ),
          horizontalSpacing(16),
          SizedBox(
            width: 40.w(context),
            child: Text(
              model.imagePath.split("/").last,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          if (model.isLoading.value)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(),
              ),
            ),
          if (model.isbase64)
            const Icon(Icons.check, size: 16, color: AppColors.green),
          if (model.canEdit)
            InkWell(
              onTap: () {
                controller.removeImage(model);
              },
              child: const Image(
                image: AssetImages.close,
                height: 16,
                width: 16,
              ),
            ),
        ],
      ),
    );
  }
}

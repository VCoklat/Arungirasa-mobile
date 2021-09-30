import 'dart:io';
import 'dart:typed_data';

import 'package:arungi_rasa/generated/l10n.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class ImageUtil {
  Uint8List? image;
  String? _path;
  ImageUtil([this.image]);
  Future<ImageUtil> loadImageFromFile(final File file) async {
    _path = file.path;
    image = await file.readAsBytes();
    return this;
  }

  Future<ImageUtil> loadImageFromPath(final String path) async {
    _path = path;
    final file = File(path);
    if (!(await file.exists())) throw Exception("file was not found");
    return loadImageFromFile(file);
  }

  Future<Uint8List> compress() async {
    if (image == null) throw Exception("Image is empty");
    return await FlutterImageCompress.compressWithList(image!);
  }

  Future<ImageUtil> pickImage() async {
    final source = await Get.bottomSheet<ImageSource>(
      SizedBox(
        width: Get.width,
        child: Material(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget?>[
                ListTile(
                  title: Text(S.current.close),
                  leading: const Icon(Icons.close),
                  onTap: () => Get.back(result: null),
                ),
                ListTile(
                  title: Text(S.current.camera),
                  leading: const Icon(Icons.camera),
                  onTap: () => Get.back(result: ImageSource.camera),
                ),
                ListTile(
                  title: Text(S.current.gallery),
                  leading: const Icon(Icons.camera_alt),
                  onTap: () => Get.back(result: ImageSource.gallery),
                ),
              ].where((e) => e != null).cast<Widget>().toList(growable: false),
            ),
          ),
        ),
      ),
    );
    if (source == null) return this;
    if (source == ImageSource.camera) {
      if (!await Permission.camera.request().isGranted) {
        return this;
      }
    } else {
      if (!await Permission.storage.request().isGranted) {
        return this;
      }
    }
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return this;
    this.image = await image.readAsBytes();
    return this;
  }

  Future<ImageUtil> crop({
    int? maxWidth,
    int? maxHeight,
    CropAspectRatio? aspectRatio,
    List<CropAspectRatioPreset> aspectRatioPresets = const [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
    CropStyle cropStyle = CropStyle.rectangle,
    ImageCompressFormat compressFormat = ImageCompressFormat.jpg,
    int compressQuality = 90,
    AndroidUiSettings? androidUiSettings,
    IOSUiSettings? iosUiSettings,
  }) async {
    if (image == null) throw Exception("Image is empty");
    String path;
    if (_path == null) {
      final tempDirPath = (await getTemporaryDirectory()).path;
      path = "$tempDirPath/${const Uuid().v4()}";
      final tempFile = File(path);
      await tempFile.writeAsBytes(image!.toList());
    } else {
      path = _path!;
    }
    final croppedFile = await ImageCropper.cropImage(
      sourcePath: path,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      aspectRatio: aspectRatio,
      aspectRatioPresets: aspectRatioPresets,
      cropStyle: cropStyle,
      compressFormat: compressFormat,
      compressQuality: compressQuality,
      androidUiSettings: androidUiSettings,
      iosUiSettings: iosUiSettings,
    );
    if (croppedFile == null) throw Exception("unable to crop image");
    image = await croppedFile.readAsBytes();
    return this;
  }

  Future<String> uploadToFirebase() async {
    if (image == null) throw Exception("Image is empty");
    final instance = FirebaseStorage.instance;
    final fileName = "${const Uuid().v4()}.png";
    final ref = instance.ref().child("user").child("profile").child(fileName);
    final task = ref.putData(
      image!,
      SettableMetadata(
        contentDisposition: "attachment; filename=\"$fileName\"",
        cacheControl: "public, max-age=604800, immutable",
        contentType: "image/png",
      ),
    );
    await task;
    return await ref.getDownloadURL();
  }
}

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageUtil {
  Uint8List? image;
  ImageUtil([this.image]);
  Future<ImageUtil> loadImageFromFile(final File file) async {
    image = await file.readAsBytes();
    return this;
  }

  Future<ImageUtil> loadImageFromPath(final String path) async {
    final file = new File(path);
    if (!(await file.exists())) throw new Exception("file was not found");
    return loadImageFromFile(file);
  }

  Future<Uint8List> compress() async {
    if (image == null) throw new Exception("Image is empty");
    return await FlutterImageCompress.compressWithList(image!);
  }
}

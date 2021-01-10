import 'dart:io';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter/file_input.dart';

Future<Size> sizeGetter(String filePath) async {
  final file = File(filePath);
  final size = ImageSizeGetter.getSize(FileInput(file));
  return size;
}

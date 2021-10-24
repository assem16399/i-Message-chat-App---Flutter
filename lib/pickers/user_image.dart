import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImage extends StatefulWidget {
  final void Function(File? image) onImageSelected;
  const UserImage({Key? key, required this.onImageSelected}) : super(key: key);

  @override
  _UserImageState createState() => _UserImageState();
}

File? _image;

class _UserImageState extends State<UserImage> {
  void _pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    if (pickedImageFile == null) return;
    setState(() {
      _image = File(pickedImageFile.path);
    });
    widget.onImageSelected(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: _image != null ? FileImage(_image!) : null,
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.photo),
            label: const Text('Add picture')),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

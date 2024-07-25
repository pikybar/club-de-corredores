import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.image,
    required this.onUpload
  });

  final XFile? image;
  final void Function(XFile image) onUpload;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        if (image == null) return;
        onUpload(image);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(border: Border.all(style: BorderStyle.solid), borderRadius: BorderRadius.circular(4)),
            foregroundDecoration: image != null ? BoxDecoration(color: const Color.fromARGB(54, 0, 0, 0)) : null,
            child: image != null
              ? Image.file(File(image!.path), height: 120, fit: BoxFit.cover)
              : SizedBox(height: 120),
          ),
          Column(
            children: [
              Icon(Icons.upload, color: Colors.white, size: 40,),
              Text("Cargar foto", style: TextStyle(color: Colors.white, fontSize: 18),)
            ],
          ),
        ],
      )
    );
  } 
}
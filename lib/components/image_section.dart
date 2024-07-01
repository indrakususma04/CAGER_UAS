import 'package:flutter/material.dart';

class ImageSection extends StatelessWidget {
  // ignore: use_super_parameters
  const ImageSection({Key? key, required this.image}) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    );
  }
}

import "package:flutter/material.dart";

class TextContainer extends StatelessWidget {
  final String text;
  final Color color;

  // ignore: use_super_parameters
  const TextContainer({
    required this.text,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      width: 100,
      height: 50,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

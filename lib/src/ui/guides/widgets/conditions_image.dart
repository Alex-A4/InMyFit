import 'package:flutter/material.dart';

/// Dark image with specified condition
/// There are dark image with dark-grey blur
class ConditionImage extends StatelessWidget {
  final String image;
  final String title;

  const ConditionImage({Key key, this.image, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0),
        child: Text(title.toUpperCase(),
            style: TextStyle(
              fontSize: 30.0,
              fontFamily: 'ProstoSans',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Color(0x9F757575), BlendMode.color),
        ),
      ),
    );
  }
}

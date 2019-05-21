import 'package:flutter/material.dart';
import 'package:inmyfit/src/ui/widgets/edge_clipper.dart';

///This widget needs to be shown on top of page with short summary information
/// inside clipped-edge widget
class ClippedTopInfo extends StatelessWidget {
  /// This widget will be sown on left side of title
  final Widget leftWidget;
  final String title;
  final String image;
  final String subtitle;
  final isGrey;

  const ClippedTopInfo({
    Key key,
    this.leftWidget,
    @required this.title,
    @required this.image,
    this.subtitle,
    this.isGrey = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: EdgeClipper(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        width: double.infinity,
        height: 170.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (leftWidget != null) leftWidget,
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'ProstoSans',
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold),
                ),
                if (leftWidget != null) SizedBox(width: 30.0),
              ],
            ),
            if (subtitle != null)
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0, color: Colors.white, fontFamily: 'ProstoSans'),
              )
          ],
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                isGrey ? Color(0x9F757575) : Colors.transparent,
                BlendMode.color),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EdgeClipper extends CustomClipper<Path> {
  /// If true then edges will be drown at the top of canvas
  bool isTopEdge;
  final double edgeHeight = 10.0;
  final double edgeWidthHalf = 8.0;

  EdgeClipper({this.isTopEdge});

  @override
  Path getClip(Size size) {
    final path = Path();
    double positionX = 0.0;
    double positionY;
    double direction;

    if (isTopEdge) {
      positionY = 0.0;
      direction = 1.0;
    } else {
      positionY = size.height;
      direction = -1.0;
    }

    /// To clip top, the bypass will be performed counterclockwise
    /// To clip bottom. the pypass will be performed clockwise
    path.moveTo(positionX, positionX);

    //Go to left: bottom for top clipping and top for bottom clipping corner
    positionY += size.height * direction;
    path.lineTo(positionX, positionY);

    //Go to right corner
    positionX = size.width;
    path.lineTo(positionX, positionY);

    //Go to right: top for top clipping and bottom for bottom clipping corner
    positionY += size.height * direction * (-1);
    path.lineTo(positionX, positionY);

    // Clip edges
    while (positionX > 0) {
      path.lineTo(
          positionX - edgeWidthHalf, positionY + edgeHeight * direction);
      positionX -= edgeWidthHalf * 2;
      path.lineTo(positionX, positionY);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
//
//  @override
//  void paint(Canvas canvas, Size size) {
//    Paint line = Paint();
//
//    double positionX = 0.0;
//    double positionY;
//    if (isTopEdge)
//      positionY = 0.0;
//    else
//      positionY = size.height - edgeHeight;
//
////    Offset begin = Offset(0.0, positionY);
////    Offset end;
//    Path path = Path();
//    path.moveTo(positionX, positionY);
//
//    while (positionX < size.width) {
//      path.lineTo(positionX + edgeWidthHalf, positionY + edgeHeight);
//      positionX += edgeWidthHalf * 2;
//      path.lineTo(positionX, positionY);
//    }
//    path.close();
//
//    canvas.clipPath(path);
////    while (begin.dx <= size.width) {
////      end = Offset(begin.dx + edgeWidthHalf, begin.dy + edgeHeight);
////      canvas.drawLine(begin, end, line);
////      begin = Offset(begin.dx + edgeWidthHalf * 2, begin.dy);
////      canvas.drawLine(end, begin, line);
////    }
//  }
//
//  @override
//  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

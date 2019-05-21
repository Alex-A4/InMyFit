import 'package:flutter/material.dart';

/// Widget that displays percent of some data
class PersentScale extends StatelessWidget {
  /// Percent of 'completed' data. Must be from 0 to 100 inclusive
  final int percent;

  const PersentScale({Key key, this.percent})
      : assert(percent >= 0 && percent <= 100,
            'Percent value must be from 0 to 100, inclusive'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 4.0,
              child: CustomPaint(
                painter: PercentPainter(percent),
              ),
            ),
          ),
          SizedBox(width: 7.0),
          Flexible(
            child: Text('% от суточной нормы',
                style: TextStyle(fontSize: 12.0, color: Colors.grey[350])),
          ),
        ],
      ),
    );
  }
}

/// Draw rectangle with colorful completed [percent]
class PercentPainter extends CustomPainter {
  /// There percent is value from 0.0 to 1.0
  final double percent;

  /// Send to constructor int percent from 0 to 100
  PercentPainter(int prntg) : percent = prntg / 100.0;

  @override
  void paint(Canvas canvas, Size size) {
    final double completedWidth = size.width * percent;

    final completedRect = Offset.zero & Size(completedWidth, size.height);
    final completedPaint = Paint()..color = Color(0xFF34EBE9);

    final notCompletedRect = Offset(completedWidth, 0) &
        Size(size.width - completedWidth, size.height);
    final notCompletedPaint = Paint()..color = Colors.grey[300];

    canvas.drawRect(completedRect, completedPaint);
    canvas.drawRect(notCompletedRect, notCompletedPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

import 'package:flutter/material.dart';
import 'package:inmyfit/src/controller/watertip_controller.dart';


/// Widget with some information about water
class WaterTipWidget extends StatefulWidget {
  const WaterTipWidget({Key key}) : super(key: key);

  @override
  _WaterTipWidgetState createState() => _WaterTipWidgetState();
}

class _WaterTipWidgetState extends State<WaterTipWidget> {
  WaterTipController _waterTipController = WaterTipController();
  WaterTip _currentTip;

  @override
  void initState() {
    super.initState();
    _currentTip = _waterTipController.initTip();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('WaterTipKey'),
      height: 175.0,
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: ShapeDecoration(
                  color: _tipColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
            Image.asset(
              'assets/watertips/watertip${_currentTip.index}.png',
              alignment: AlignmentDirectional.bottomStart,
            ),
            Container(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'watertip #${_currentTip.index}',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(_currentTip.tipText,
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                        softWrap: true),
                  ],
                ),
              ),
            ),
          ],
        ),
        onTap: () =>
            setState(() => _currentTip = _waterTipController.getNextTip()),
      ),
    );
  }

  final Color _tipColor = Color(0xFF4EEBE4);
}

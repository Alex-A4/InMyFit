import 'package:flutter/material.dart';
import '../../models/water_intake.dart';
import '../../redux/activity_redux.dart';
import '../../controller/current_activity_controller.dart';
import 'package:flutter_redux/flutter_redux.dart';

class WaterSettingsRoute<T> extends PopupRoute<T> {
  @override
  Color get barrierColor => Color(0xEF9E9E9E);

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => 'WaterSettings';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget dialog = Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Настройки воды',
                            textAlign: TextAlign.center,
                            style: textStyle.copyWith(fontSize: 16.0)),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          'Измените способы отслеживания и суточную цель',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Neue',
                              fontSize: 14.0,
                              color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  getSettingsItem(() {}, 'Рекомендованные приёмы'),
                  Divider(),
                  getSettingsItem(() {}, 'Выбрать цель'),
                  Divider(),
                  getSettingsItem(() {}, 'Стаканы'),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            //Close button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child:
                  getSettingsItem(() => Navigator.of(context).pop(), 'Закрыть'),
            ),
          ],
        ),
      ),
    );

    return dialog;
  }

  Widget getSettingsItem(Function onTap, String text) {
    return ListTile(
      title: Text(
        text,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
      onTap: onTap,
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 100);

  var textStyle = TextStyle(
      fontSize: 20.0,
      color: Colors.grey[700],
      fontFamily: 'ProstoSans',
      fontWeight: FontWeight.w600);
}

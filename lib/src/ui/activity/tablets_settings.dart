import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:inmyfit/main.dart';
import 'package:inmyfit/src/models/date_interval.dart';
import 'package:inmyfit/src/models/tablet_intake.dart';
import 'package:inmyfit/src/redux/activity_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/cupertino.dart';

/// Empty widget with [Scaffold] that needs to show [BottomSheet]
class TabletsSettings extends StatelessWidget {
  final Store<ActivityState> store;

  TabletsSettings({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsScreen(store: store),
    );
  }
}

/// Widget that needs to show info about tablets
class SettingsScreen extends StatefulWidget {
  final Store<ActivityState> store;

  SettingsScreen({Key key, this.store}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Store<ActivityState> get store => widget.store;

  final _formKey = GlobalKey<FormState>();

  /// Step of tablet settings, this variable helps to show specified info
  /// on each step.
  /// For example, on first step here must be:
  /// 1) Form to input name of new medicine
  /// 2) Active courses
  /// 3) All medicine
  /// On second step here must be:
  /// 1) Form to input name of new medicine (filled)
  /// 2) Forms to input dosage and count of units
  /// 3) If there is editing mode, then button to remove medicine
  /// e.t.c
  int settingsStep = 1;

  /// Controller to enter name of new medicine
  TextEditingController nameController = TextEditingController();

  /// How many pills per one intake
  int dosage = 0;

  /// Variable that indicate whether is editing mode or not
  /// Editing mode can be activate by pressing on medicine in MyActiveCourses
  /// section
  bool isEditing = false;

  /// Medicine that user selected for editing
  TabletsIntake selectedTablet;

  /// How many times per day need to intake tablet
  int countOfIntakes = 0;

  /// Dates that need to set up interval of new tablet
  DateTime startDate;
  DateTime endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 45.0),
        child: GradientAppBar(
          flexibleSpace: Container(
            margin: const EdgeInsets.only(top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text('Отмена', style: appBarStyle),
                ),
                Text('Настройки таблеток', style: appBarStyle),
                InkWell(
                  onTap: () => setState(() {
                        if (settingsStep == 1 &&
                            _formKey.currentState.validate())
                          ++settingsStep;
                        else if (settingsStep == 2 &&
                            _formKey.currentState.validate())
                          ++settingsStep;
                        else if (settingsStep == 3 &&
                            _formKey.currentState.validate()) {
                          /// Add new tablet to list
                          store.dispatch(AddOrUpdateTabletsDataAction(
                            interval: DateInterval(
                                startDate: startDate, endDate: endDate),
                            tablet: TabletsIntake(
                                name: nameController.text,
                                countOfIntakes: countOfIntakes,
                                dosage: dosage),
                          ));

                          Navigator.of(context).pop();
                        }
                      }),
                  child: Text(settingsStep == 3 ? 'Добавить' : 'Дальше',
                      style: appBarStyle),
                ),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColorStart: theme.primaryColor,
          backgroundColorEnd: theme.primaryColorLight,
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  settingsStep < 3 ? getNameEditor() : Container(),
                  settingsStep == 2
                      ? getDosageAndCountInput(context)
                      : Container(),
                  settingsStep == 3 ? getIntervalPicker() : Container(),
                ],
              ),
            ),
            settingsStep == 1 ? getActiveCourses() : Container(),
          ],
        ),
      ),
    );
  }

  /// Widget that contains text form to input name of medicine
  /// This filed will have access only on when [settingsStep] == 1
  /// This widget must be inside Form
  Widget getNameEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Название препарата', style: subtitleStyle)),
        Container(
          height: 50.0,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.white,
          child: TextFormField(
            validator: (text) {
              if (text.isEmpty) return 'Введите название';
            },
            style: mainTextStyle,
            // Allow to modify name only on first step
            enabled: settingsStep == 1,
            decoration: InputDecoration(
                hintText: 'Введите название',
                hintStyle: hintStyle,
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0.0)),
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0.0)),
                disabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(width: 0.0, color: Colors.transparent))),
            controller: nameController,
          ),
        ),
      ],
    );
  }

  /// If user input name then show field to input dosage and count of intakes
  Widget getDosageAndCountInput(BuildContext context) {
    var padding = const EdgeInsets.only(left: 16.0);
    return Material(
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20.0),
          Container(
              padding: padding,
              child:
                  Text('Как часто принимать таблетки', style: subtitleStyle)),
          FormField<int>(
            validator: (val) =>
                countOfIntakes != 0 ? null : 'Выберите количество приёмов',
            builder: (state) => InkWell(
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    padding: padding,
                    color: Colors.white,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        state.hasError && countOfIntakes == 0
                            ? state.errorText
                            : countOfIntakes == 0
                                ? 'Количество приёмов'
                                : '$countOfIntakes раза',
                        style: countOfIntakes == 0 ? hintStyle : mainTextStyle,
                      ),
                    ),
                  ),
                  onTap: () => showCountOfIntakesSelecter(context),
                ),
          ),
          SizedBox(height: 20.0),
          Container(
              padding: padding,
              child:
                  Text('Сколько таблеток за один приём', style: subtitleStyle)),
          FormField<int>(
            validator: (val) => dosage != 0 ? null : 'Выберите дозировку',
            builder: (state) => InkWell(
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    color: Colors.white,
                    padding: padding,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        state.hasError && dosage == 0
                            ? state.errorText
                            : dosage == 0 ? 'Дозировка' : '$dosage штук',
                        style: dosage == 0 ? hintStyle : mainTextStyle,
                      ),
                    ),
                  ),
                  onTap: () => showDosageSelecter(context),
                ),
          ),
          SizedBox(height: 25.0),
          Container(
            alignment: Alignment.center,
            child: !isEditing
                ? Container()
                : RaisedButton(
                    onPressed: () {
                      store.dispatch(
                          DeleteTabletsAction(tablet: selectedTablet));
                      setState(() => settingsStep = 1);
                    },
                    child: Text('Удалить препарат', style: appBarStyle),
                    color: Colors.red[300],
                  ),
          ),
        ],
      ),
    );
  }

  /// Get list of active courses of user
  Widget getActiveCourses() {
    List<TabletsIntake> tablets = [];
    if (store.state.currentActivityController.tablets.isNotEmpty)
      store.state.currentActivityController.tablets.values
          .forEach((tablet) => tablets.add(tablet));

    // If there is no courses then return empty container
    return tablets.isEmpty
        ? Container()
        : Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: Text('Активные курсы', style: subtitleStyle)),
                Column(
                  children:
                      tablets.map((tablet) => getActiveTablet(tablet)).toList(),
                ),
              ],
            ),
          );
  }

  /// Get dismissed widget with one tablet representation
  Widget getActiveTablet(TabletsIntake tablet) {
    return GestureDetector(
      /// Open page for editing [tablet]
      onTap: () => setState(() {
            selectedTablet = tablet;
            nameController.text = tablet.name;
            dosage = tablet.dosage;
            countOfIntakes = tablet.countOfIntakes;
            settingsStep = 2;
            isEditing = true;
          }),
      child: Slidable(
        delegate: SlidableScrollDelegate(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 16.0),
              color: Colors.white,
              height: 50.0,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(child: Text(tablet.name, style: coursesStyle)),
                    Icon(Icons.chevron_right,
                        color: coursesStyle.color, size: 35.0),
                  ],
                ),
              ),
            ),
            Divider(height: 1.0),
          ],
        ),
        direction: Axis.horizontal,
        secondaryActions: <Widget>[
          IconSlideAction(
            icon: Icons.delete,
            color: Colors.red[400],
            foregroundColor: Colors.white,
            caption: 'Удалить',
            onTap: () {
              store.dispatch(DeleteTabletsAction(tablet: tablet));
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  /// Widget for 3-rd step of [settingsStep] that needs to pick start and end
  /// date of course
  Widget getIntervalPicker() {
    var padding = const EdgeInsets.only(left: 16.0);
    return Material(
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
              padding: padding,
              child: Text('Дата начала', style: subtitleStyle)),
          FormField(
            validator: (val) =>
                startDate != null ? null : 'Выберите начальную дату',
            builder: (state) => InkWell(
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    padding: padding,
                    color: Colors.white,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        state.hasError && startDate == null
                            ? state.errorText
                            : startDate == null
                                ? 'Начало приёма'
                                : getFormattedDate(startDate),
                        style: startDate == null ? hintStyle : mainTextStyle,
                      ),
                    ),
                  ),
                  onTap: () => DatePicker.showDatePicker(
                        context,
                        theme: dateStyle,
                        onConfirm: (date) => setState(() => startDate = date),
                        locale: LocaleType.ru,
                        currentTime: startDate ?? DateTime.now(),
                      ),
                ),
          ),
          SizedBox(height: 20.0),
          Container(
              padding: padding,
              child: Text('Дата окончания', style: subtitleStyle)),
          FormField(
            validator: (val) =>
                endDate != null ? null : 'Выберите конечную дату',
            builder: (state) => InkWell(
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    color: Colors.white,
                    padding: padding,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        state.hasError && endDate == null
                            ? state.errorText
                            : endDate == null
                                ? 'Конец приёма'
                                : getFormattedDate(endDate),
                        style: endDate == null ? hintStyle : mainTextStyle,
                      ),
                    ),
                  ),
                  onTap: () => DatePicker.showDatePicker(
                        context,
                        theme: dateStyle,
                        onConfirm: (date) => setState(() => endDate = date),
                        locale: LocaleType.ru,
                        currentTime: endDate ?? DateTime.now(),
                      ),
                ),
          ),
        ],
      ),
    );
  }

  /// Get formatted date that contains only month and day and looks like:
  /// January, 28  or April, 13
  String getFormattedDate(DateTime date) {
    /// Split date by space.
    /// At 0 place - day
    /// At 1 place - month
    /// At 2 place - year
    List<String> parts = DateFormat.yMMMMd("ru_RU").format(date).split(' ');
    var day = parts[0];
    var month = parts[1];

    /// First symbol in month
    var firstSymbol = month.substring(0, 1);
    month = month.replaceFirst(firstSymbol, firstSymbol.toUpperCase());

    return '$month, $day';
  }

  /// Show bottom sheet dialog to select [countOfIntakes] variable
  void showCountOfIntakesSelecter(BuildContext context) {
    Scaffold.of(context).showBottomSheet((context) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: Text('Выберите количество приёмов',
                  style: mainTextStyle, textAlign: TextAlign.center),
              subtitle: Text('Сколько раз в день принимать медикамент',
                  style: mainTextStyle.copyWith(fontSize: 15.0),
                  textAlign: TextAlign.center),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(3, (index) {
                return InkWell(
                  child: Container(
                    height: 40.0,
                    width: double.infinity,
                    child: Center(
                      child: Text('${index + 1} раза в день',
                          style: mainTextStyle, textAlign: TextAlign.center),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() => countOfIntakes = index + 1);
                  },
                );
              }),
            ),
          ],
        ));
  }

  /// Show bottom sheet dialog to select [dosage] variable
  void showDosageSelecter(BuildContext context) {
    showBottomSheet(
        context: context,
        builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: Text('Выберите количество',
                      style: mainTextStyle, textAlign: TextAlign.center),
                  subtitle: Text('Сколько количетство таблеток за один приём',
                      style: mainTextStyle.copyWith(fontSize: 15.0),
                      textAlign: TextAlign.center),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return InkWell(
                      child: Container(
                        height: 35.0,
                        width: double.infinity,
                        child: Center(
                          child: Text('${index + 1}',
                              style: mainTextStyle,
                              textAlign: TextAlign.center),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() => dosage = index + 1);
                      },
                    );
                  }),
                ),
              ],
            ));
  }

  var dateStyle = DatePickerTheme(
    doneStyle: TextStyle(
      fontSize: 16.0,
      fontFamily: 'ProstoSans',
      fontWeight: FontWeight.w600,
      color: theme.primaryColor,
    ),
    cancelStyle: TextStyle(
      fontSize: 16.0,
      fontFamily: 'ProstoSans',
      fontWeight: FontWeight.w600,
      color: Colors.grey[600],
    ),
  );

  var coursesStyle = TextStyle(
      fontSize: 20.0, color: Colors.grey[600], fontFamily: 'ProstoSans');
  var appBarStyle = TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontFamily: 'ProstoSans',
      fontWeight: FontWeight.w500);
  var mainTextStyle = TextStyle(
      fontSize: 18.0,
      color: Colors.grey[600],
      fontFamily: 'Neue',
      fontWeight: FontWeight.w700);
  var hintStyle = TextStyle(fontSize: 18.0, color: Colors.red[400]);
  var subtitleStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
      color: Colors.grey[600],
      fontFamily: 'ProstoSans');
}

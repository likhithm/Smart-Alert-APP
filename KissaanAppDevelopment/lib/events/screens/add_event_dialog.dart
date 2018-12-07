import 'package:flutter/material.dart';
import 'package:kissaan_flutter/events/utils/event_state.dart';
import 'package:kissaan_flutter/events/widgets/event_icon.dart';
import 'package:intl/intl.dart';
import 'package:kissaan_flutter/locale/locales.dart';

class AddEventDialog extends StatefulWidget {
  AddEventDialog(this.gender);

  final String gender;

  @override
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  List<String> healthEventNames = [];
  List<String> statusEventNames = [];
  List<String> breedingEventNames = [];
  List<String> deliveryEventNames = [];

  List<EventState> healthEventButtons;
  List<EventState> breedingEventButtons;
  List<EventState> statusEventButtons;
  List<EventState> deliveryEventButtons;

  List<String> events = [];
  TextEditingController desController = new TextEditingController();
  DateTime dateTime = DateTime.now();
  final format = new DateFormat('dd-MM-yyyy');
  bool isLoaded = false;
  String time = '', date = '';

  @override
  void initState() {
    super.initState();
    date = format.format(DateTime.now());
    //_initHelper();
  }

  void _initHelper() {
    healthEventNames.add(AppLocalizations.of(context).dryCowTherapy);
    healthEventNames.add(AppLocalizations.of(context).generalCheckUp);
    healthEventNames.add(AppLocalizations.of(context).intramammaryAntibiotics);

    breedingEventNames.add(AppLocalizations.of(context).pregnancy);
    breedingEventNames.add(AppLocalizations.of(context).insemination);

    statusEventNames.add(AppLocalizations.of(context).sold);
    statusEventNames.add(AppLocalizations.of(context).dead);

    deliveryEventNames.add(AppLocalizations.of(context).maleCalf);
    deliveryEventNames.add(AppLocalizations.of(context).femaleCalf);
    deliveryEventNames.add(AppLocalizations.of(context).deadCalf);

    Map<String, String> healthMap = {
      AppLocalizations.of(context).dryCowTherapy: "Dry Cow Therapy",
      AppLocalizations.of(context).generalCheckUp: "General Check-up",
      AppLocalizations.of(context).intramammaryAntibiotics: "Intramammary Antibiotics",
    };

    Map<String, String> breedingMap = {
      AppLocalizations.of(context).pregnancy: "pregnancy",
      AppLocalizations.of(context).insemination: "insemination"
    };

    Map<String, String> deliveryMap = {
      AppLocalizations.of(context).maleCalf: "Male Calf",
      AppLocalizations.of(context).femaleCalf: "Female Calf",
      AppLocalizations.of(context).deadCalf: "Dead Calf"
    };

    Map<String, String> statusMap = {
      AppLocalizations.of(context).sold: "Sold",
      AppLocalizations.of(context).dead: "Dead"
    };

    healthEventButtons = healthEventNames
      .map((value) =>
      EventState(
        child: EventIcon(healthMap[value], "Medication", value),
        onTap: handleSelection
      )
    ).toList();

    breedingEventButtons =  breedingEventNames
      .map((value) =>
      EventState(
        child: EventIcon(breedingMap[value], "Breeding", value),
        onTap: handleSelection
      ),
    ).toList();

    statusEventButtons = statusEventNames
      .map((value) =>
      EventState(
        child: EventIcon(statusMap[value], "Status", value),
        onTap: handleSelection
      )
    ).toList();

    deliveryEventButtons = deliveryEventNames
      .map((value) =>
      EventState(
        child: EventIcon(deliveryMap[value], "Delivered", value),
        onTap: handleSelection
      )
    ).toList();
  }

  void handleSelection(bool selected, String event, String category) {
    if (selected) {
      events.add(category + "+" + event);
    } else {
      events.remove(category + "+" + event);
    }
  }

  void _setTime() async{
    final DateTime picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2018),
        lastDate: DateTime(2025),
        initialDate: DateTime.now()
    );
    setState(() {
      date = format.format(picked);
      //date = picked.toString().substring(0,10);
      dateTime = picked;
    });
  }

  Widget _buildDateTimeSection(Color color) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _setTime();
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0
                ),
                child: Text(
                  '$date',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: color,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );

  }

  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: TextField(
        controller: desController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            bottom: 10.0
          ),
          hintText: AppLocalizations.of(context).enterEventDesc,
          labelText: AppLocalizations.of(context).description,
          labelStyle: TextStyle(
            fontSize: 20.0, 
            fontWeight: FontWeight.w500
          )
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(!isLoaded) {
      _initHelper();
      isLoaded = true;
    }

    ThemeData theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(91,190,133,1.0),
        title: Text(AppLocalizations.of(context).addEvent),
        actions: [
          FlatButton(
            onPressed: () {
              List<String> tempList = new List();
              tempList.addAll(events);
              events.clear();
              for(String event in tempList) {
                events.add(event + "+" + dateTime.millisecondsSinceEpoch.toString());
              }
              events.add(desController.text.toString());
              Navigator.of(context).pop(events);
            },
            child: Text(AppLocalizations.of(context).save,
              style: theme
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.white))),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.white,
            child: _buildDateTimeSection(theme.accentColor),
          ),
          Divider(),
          widget.gender == "Female" 
            ? EventSection(AppLocalizations.of(context).breeding, breedingEventButtons)
            : Container(),
          widget.gender == "Female" 
            ? Divider()
            : Container(),
          widget.gender == "Female" 
            ? EventSection(AppLocalizations.of(context).medicalAndHealth, healthEventButtons)
            : Container(),
          widget.gender == "Female" 
            ? Divider()
            : Container(),
          widget.gender == "Female" 
            ? EventSection(AppLocalizations.of(context).delivery, deliveryEventButtons)
            : Container(),
          widget.gender == "Female" 
            ? Divider()
            : Container(),
          EventSection(AppLocalizations.of(context).status, statusEventButtons),
          Divider(),
          _buildDescriptionSection()
        ],
      ),
      
    );
  }
}

class EventSection extends StatelessWidget {
  final String title;
  final List<Widget> iconButtons;

  EventSection(this.title, this.iconButtons);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      constraints: BoxConstraints(
        maxWidth: size.width, 
        maxHeight: 150.0
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16.0,
            fontWeight: FontWeight.w500
          ),
        ),
        isThreeLine: true,
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: iconButtons
        )
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kissaan_flutter/cattle/utils/cattle_enums.dart';
import 'package:kissaan_flutter/cattle/utils/date_validation.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/tasks/utils/task_date_state.dart';

class TaskDateInputField extends StatelessWidget {
  TaskDateInputField();
  final TextEditingController _controller =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    final format = new DateFormat('dd-MM-yyyy');

    TaskDateState state = TaskDateState.of(context);
    _controller.text = state.taskDate != null ? format.format(state.taskDate):"";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: TextFormField(
        controller: _controller,
        decoration: _buildInputDecoration(context),
        validator: (value) {
          if (!isValidDob(value)) {
            if (!value.isNotEmpty) {
              return AppLocalizations.of(context).notValidDate;
            }
          }
        },
      ),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    TaskDateState state = TaskDateState.of(context);
    ThemeData theme = Theme.of(context);

    return InputDecoration(
        suffixIcon: IconButton(
            color: theme.accentColor,
            icon: Icon(
                Icons.calendar_today
            ),
            onPressed: () {state.onPress(context);}
        ),
        contentPadding: EdgeInsets.only(bottom: 10.0),
        hintText: AppLocalizations.of(context).enterEventDate,
        labelText: AppLocalizations.of(context).date,
        labelStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500)
    );
  }
}
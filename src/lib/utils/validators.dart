import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/pages/events/event_form.dart';

Map<String, String> validateEventForm(BuildContext context, String title,
    DateTime? startDate, DateTime? endDate, List<Activity> activities) {
  Map<String, String> errors = {};
  if (title == "") {
    errors['title'] = AppLocalizations.of(context).event_title_error;
  }
  if (startDate!.isAfter(endDate!)) {
    errors['date'] = AppLocalizations.of(context).event_date_error;
  }
  if (activities.isEmpty) {
    errors['activities'] = AppLocalizations.of(context).event_activities_error;
  }
  return errors;
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/models/media/media.dart';
import 'package:src/pages/events/choose_activity_form.dart';
import 'package:src/utils/service_locator.dart';

import 'package:src/widgets/events/lists/activities_list.dart';

class MediaList extends ActivitiesList {
  const MediaList(
      {super.key,
      required super.activities,
      required super.addActivity,
      required super.removeActivity,
      required super.errors});

  @override
  Future<List<ChooseActivity>> getActivities() async {
    List<ChooseActivity> mediaActivities = [];
    List<Media> media = await serviceLocator<MediaDao>().findMediaActivities();

    for (Media m in media) {
      if (activities.every((element) => element.id != m.id)) {
        mediaActivities.add(ChooseActivity(
          id: m.id!,
          title: m.name,
          description: m.description,
          isSelected: false,
        ));
      }
    }

    return mediaActivities;
  }

  @override
  ChooseActivityForm getChooseActivityForm(
    BuildContext context,
    ScrollController scrollController,
    List<ChooseActivity> snapshot,
  ) {
    return ChooseActivityForm(
      title: AppLocalizations.of(context).choose_media,
      noActivitiesMsg: AppLocalizations.of(context).no_media,
      icon: Icons.live_tv_outlined,
      scrollController: scrollController,
      activities: snapshot,
      addActivityCallback: addActivity,
    );
  }
}

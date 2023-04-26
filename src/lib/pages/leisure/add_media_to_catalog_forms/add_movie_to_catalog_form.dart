import 'package:flutter/material.dart';
import 'package:src/daos/media/media_video_movie_super_dao.dart';
import 'package:src/models/media/media_video_movie_super_entity.dart';
import 'package:src/pages/leisure/add_media_to_catalog_forms/add_media_to_catalog_form.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/service_locator.dart';

class AddMovieToCatalogForm
    extends AddMediaToCatalogForm<MediaVideoMovieSuperEntity> {
  const AddMovieToCatalogForm(
      {Key? key,
      required String startDate,
      required String endDate,
      required Status status,
      required MediaVideoMovieSuperEntity item,
      required void Function(int) setMediaId,
      required Future Function() showReviewForm,
      required VoidCallback? refreshStatus})
      : super(
            key: key,
            startDate: startDate,
            endDate: endDate,
            status: status,
            item: item,
            setMediaId: setMediaId,
            showReviewForm: showReviewForm,
            refreshStatus: refreshStatus);

  @override
  AddMovieToCatalogFormState createState() => AddMovieToCatalogFormState();
}

class AddMovieToCatalogFormState
    extends AddMediaToCatalogFormState<MediaVideoMovieSuperEntity> {
  @override
  Future<int> storeMediaInDatabase() async {
    return serviceLocator<MediaVideoMovieSuperDao>()
        .insertMediaVideoMovieSuperEntity(widget.item);
  }
}

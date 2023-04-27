import 'package:flutter/material.dart';
import 'package:src/daos/media/media_book_super_dao.dart';
import 'package:src/models/media/media_book_super_entity.dart';
import 'package:src/pages/leisure/add_media_to_catalog_forms/add_media_to_catalog_form.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/service_locator.dart';

class AddBookToCatalogForm extends AddMediaToCatalogForm<MediaBookSuperEntity> {
  const AddBookToCatalogForm(
      {Key? key,
      required String startDate,
      required String endDate,
      required Status status,
      required MediaBookSuperEntity item,
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
  AddBookToCatalogFormState createState() => AddBookToCatalogFormState();
}

class AddBookToCatalogFormState
    extends AddMediaToCatalogFormState<MediaBookSuperEntity> {
  @override
  Future<int> storeMediaInDatabase(Status status) async {
    return serviceLocator<MediaBookSuperDao>()
        .insertMediaBookSuperEntity(widget.item.copyWith(status: status));
  }
}

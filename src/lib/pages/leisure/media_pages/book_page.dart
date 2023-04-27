import 'package:flutter/material.dart';
import 'package:src/models/media/media_book_super_entity.dart';
import 'package:src/pages/leisure/media_pages/media_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookPage extends MediaPage<MediaBookSuperEntity> {
  const BookPage(
      {Key? key,
      required MediaBookSuperEntity media,
      required Function(bool) toggleFavorite,
      required List<String> leisureTags})
      : super(
            key: key,
            item: media,
            toggleFavorite: toggleFavorite,
            leisureTags: leisureTags,
            );

  @override
  BookPageState createState() => BookPageState();
}

class BookPageState extends MediaPageState<MediaBookSuperEntity> {
  @override
  void initState() {
    super.initState();
    super.isFavorite = widget.item.favorite;
  }

  @override
  String getLength(context) {
    return widget.item.totalPages.toString() +
        AppLocalizations.of(context).pages;
  }

  @override
  Image showImage() {
    if (widget.item.linkImage != '') {
      return Image.network(
        widget.item.linkImage,
        fit: BoxFit.fitWidth,
      );
    } else {
      return Image.asset("assets/images/no_image.jpg");
    }
  }

  @override
  String getType() {
    return 'Book';
  }
}

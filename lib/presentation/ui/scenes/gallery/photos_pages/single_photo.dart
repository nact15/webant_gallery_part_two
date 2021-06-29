import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/domain/usecases/date_formatter.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/photo_bottom_sheet.dart';

class ScreenInfo extends StatelessWidget {
  ScreenInfo({Key key, this.photo}) : super(key: key);
  final PhotoModel photo;
  final DateFormatter dateFormatter = DateFormatter();

  @override
  Widget build(BuildContext context) {
    List<bool> types = [photo.newType, photo.popularType];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
              color: AppColors.mainColor,
              iconSize: 17,
            );
          },
        ),
        backgroundColor: AppColors.colorWhite,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            GestureDetector(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 350.0,
                  ),
                  child: Hero(
                    tag: photo.id,
                    child: selectPhoto(context),
                  ),
                ),
                onLongPress: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) =>
                          PhotoBottomSheet(photo: photo));
                },
                onTap: () {
                   return Center(
                     child: Hero(
                      tag: photo.id,
                        child: CachedNetworkImage(
                          imageUrl: photo.getImage(),
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          alignment: Alignment.center,
                        ),
                  ),
                   );
                }),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 11, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        photo.name ?? '',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '999+', //и тут
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mainColorAccent,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Icon(
                      Icons.visibility,
                      size: 17,
                      color: AppColors.mainColorAccent,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      photo.user ?? 'no user',
                      style: TextStyle(
                        color: AppColors.mainColorAccent,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        dateFormatter.fromDate(photo.dateCreate),
                        style: TextStyle(
                          color: AppColors.mainColorAccent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 0, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: photo.description != null
                      ? Text(
                          photo.description,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        )
                      : null,
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 15, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 6.0,
                  runSpacing: 6.0,
                  children: types
                      .map<Widget>(
                        (item) => Chip(
                          label: Text(
                            '$item',
                            style: TextStyle(color: AppColors.colorWhite),
                          ),
                          backgroundColor: AppColors.decorationColor,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget selectPhoto(BuildContext context) {
    return photo.isPhotoSVG()
        ? SvgPicture.network(
            photo.getImage(),
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.topCenter,
          )
        : CachedNetworkImage(
            imageUrl: photo.getImage(),
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width,
            errorWidget: (context, url, error) => Icon(Icons.error),
            alignment: Alignment.center,
          );
  }
}

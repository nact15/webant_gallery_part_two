import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';

class ScreenInfo extends StatelessWidget {
  const ScreenInfo({Key key, this.photo}) : super(key: key);
  final PhotoModel photo;

  @override
  Widget build(BuildContext context) {
    return
      // WillPopScope(
      // onWillPop:() async => false,
      // child:
      Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
                    // Navigator.of(context).pushAndRemoveUntil(
                    // MaterialPageRoute(builder: (context) => Gallery()),
                    //     (Route<dynamic> route) => false),
                color: AppColors.mainColor,
                iconSize: 17,
              );
            },
          ),
          backgroundColor: AppColors.colorWhite,
        ),
        body: Column(
          children: <Widget>[
            Hero(
              tag: photo.id,
              child: selectPhoto(),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  photo.name ?? '', //и тут
                  style:
                      TextStyle(fontSize: 26, color: AppColors.decorationColor),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                child: Text(
                  photo.description ?? ' ', //а еще тут
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, color: AppColors.mainColor),
                ),
              ),
            )
          ],
        ),
      //),
    );
  }

  Widget selectPhoto() {
    return photo.isPhotoSVG()
        ? SvgPicture.network(photo.getImage(),
            fit: BoxFit.fill,
            width: 412,
            alignment: Alignment.topCenter,
            height: 309)
        : CachedNetworkImage(
            imageUrl: photo.getImage(),
            fit: BoxFit.fill,
            errorWidget: (context, url, error) => Icon(Icons.error),
            width: 412,
            alignment: Alignment.topCenter,
            height: 309);
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/domain/models/user/user_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/photos_pages/single_photo.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/user_profile/user_bloc/user_bloc.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/user_profile/user_settings.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  UserModel user;
  List<PhotoModel> photos;
  final dateFormatter = DateFormat('dd.MM.yyyy');

  @override
  void initState() {
    super.initState();
  }

  String fromDate(stringDate) {
    var date = dateFormatter.format(DateTime.parse(stringDate));
    return date.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.black,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) => UserSettings()),
            ),
            alignment: Alignment.centerRight,
          ),
        ],
        elevation: 1,
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserData) {
            user = state.user;
            photos = state.usersPhotos;
            return Column(
              children: [
                Container(
                  height: 230,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom:
                          BorderSide(width: 1.0, color: AppColors.mainColorAccent),
                    ),
                  ),
                  child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Container(
                          child: Icon(
                            Icons.camera_alt,
                            size: 55,
                            color: AppColors.mainColorAccent,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.mainColorAccent),
                            borderRadius: BorderRadius.all(Radius.circular(90)),
                          ),
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Center(
                        child: Text(
                          user.username,
                          style:
                              TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: Text(
                          fromDate(user.birthday),
                          style: TextStyle(
                              fontSize: 12, color: AppColors.mainColorAccent),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 27, 0, 0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Loaded: ${state.countOfPhotos}'),
                      ),
                    ),
                  ],
                  ),
                ),
                Container(
                  height: 1.63 * (MediaQuery.of(context).size.height / 3),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverPadding(
                        padding: const EdgeInsets.all(16.0),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                                (c, i) => Container(
                              child: GestureDetector(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Hero(
                                    tag: photos[i].id,
                                    child: photos[i].isPhotoSVG()
                                        ? SvgPicture.network(photos[i].getImage())
                                        : CachedNetworkImage(
                                      imageUrl: photos[i].getImage(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                onTap: () => _toScreenInfo(photos[i]),
                              ),
                            ),
                            childCount: photos.length,
                          ),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
  void _toScreenInfo(PhotoModel photo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScreenInfo(photo: photo),
      ),
    );
  }
}
